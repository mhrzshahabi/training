package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.repository.QuestionnaireQuestionDAO;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TrainingPlaceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.ColumnResult;
import javax.persistence.ConstructorResult;
import javax.persistence.EntityManager;
import javax.persistence.SqlResultSetMapping;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class TclassService implements ITclassService {

    private final ModelMapper modelMapper;
    private final TclassDAO tclassDAO;
    private final StudentDAO studentDAO;
    private final ClassSessionService classSessionService;
    private final TrainingPlaceDAO trainingPlaceDAO;
    private final AttachmentService attachmentService;

    private final EntityManager entityManager;

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    private final IEvaluationService evaluationService;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final ParameterService parameterService;
    private boolean FERPass = false;
    private boolean FETPass = false;
    private boolean FECRPass = false;
    private Set<ClassStudent> classStudents;
    private Long teacherId;
    private double studentsGradeToTeacher = 0.0;
    private double studentsGradeToGoals = 0.0;
    private double studentsGradeToFacility = 0.0;
    private double minScore_ER = 0.0;
    private double minScore_ET = 0.0;
    private double minScoreFECR = 0.0;
    private double trainingGradeToTeacher = 0.0;
    //----------------------------------------------- Reaction Evaluation ----------------------------------------------

    @Transactional(readOnly = true)
    @Override
    public TclassDTO.Info get(Long id) {
        return modelMapper.map(getTClass(id), TclassDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Tclass getTClass(Long id) {
        final Optional<Tclass> gById = tclassDAO.findById(id);
        return gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public List<String> getPreCourseTestQuestions(Long classId) {
        Tclass tclass = getTClass(classId);
        if (tclass.getPreCourseTestQuestions().isEmpty())
            return new ArrayList<>();
        return tclass.getPreCourseTestQuestions();
    }

    @Transactional()
    @Override
    public void updatePreCourseTestQuestions(Long classId, List<String> preCourseTestQuestions) {
        Tclass tclass = getTClass(classId);
        if (tclass.getWorkflowEndingStatusCode() != null && tclass.getWorkflowEndingStatusCode() == 2)
            throw new TrainingException(TrainingException.ErrorType.NotEditable);
        tclass.setPreCourseTestQuestions(preCourseTestQuestions);
    }

    @Transactional(readOnly = true)
    @Override
    public Tclass getEntity(Long id) {
        final Optional<Tclass> gById = tclassDAO.findById(id);
        final Tclass tclass = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));
        return tclass;
    }

    @Transactional(readOnly = true)
    @Override
    public List<TclassDTO.Info> list() {
        final List<Tclass> gAll = tclassDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<TclassDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public TclassDTO.Info create(TclassDTO.Create request) {
        List<Long> list = request.getTrainingPlaceIds();
        List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
        Set<TrainingPlace> set = new HashSet<>(allById);
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        tclass.setTrainingPlaceSet(set);
        return save(tclass);
    }

    @Transactional
    @Override
    public TclassDTO.Info update(Long id, TclassDTO.Update request) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        List<Long> trainingPlaceIds = request.getTrainingPlaceIds();
        List<TrainingPlace> allById = trainingPlaceDAO.findAllById(trainingPlaceIds);
        Set<TrainingPlace> set = new HashSet<>(allById);
        Tclass updating = new Tclass();
        modelMapper.map(tclass, updating);
        modelMapper.map(request, updating);
        updating.setTrainingPlaceSet(set);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        tclassDAO.deleteById(id);
        List<AttachmentDTO.Info> attachmentInfoList = attachmentService.search(null, "Tclass", id).getList();
        for (AttachmentDTO.Info attachment : attachmentInfoList) {
            attachmentService.delete(attachment.getId());
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.Info.class));
    }

      @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search1(SearchDTO.SearchRq request, Class<T> infoType) {
        return SearchUtil.search(tclassDAO, request, e -> modelMapper.map(e, infoType));
    }
    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> evaluatedSearch(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq criteriaRq = null;

        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else {
                criteriaRqList.add(criteriaRq);
                request.getCriteria().setCriteria(criteriaRqList);
            }
        } else
            request.setCriteria(criteriaRq);

        SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> searchRs = SearchUtil.search(tclassDAO, request, needAssessment -> modelMapper.map(needAssessment,
                TclassDTO.EvaluatedInfoGrid.class));

        List<TclassDTO.EvaluatedInfoGrid> unAcceptedClasses = new ArrayList<>();
        for (TclassDTO.EvaluatedInfoGrid tClass : searchRs.getList()) {
            int accepted = tClass.getNumberOfStudentCompletedEvaluation();
            if (accepted == 0) {
                unAcceptedClasses.add(tClass);
                searchRs.setTotalCount(searchRs.getTotalCount() - 1);
            }
            tClass.setEvaluationStatus("3");
        }

        for (TclassDTO.EvaluatedInfoGrid unAcceptedClass : unAcceptedClasses) {
            searchRs.getList().remove(unAcceptedClass);
        }

        return searchRs;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> searchById(SearchDTO.SearchRq request, Long classId) {

        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (classId != null) {
            list.add(makeNewCriteria("id", classId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }

        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.Info.class));

    }

    // ------------------------------

    private TclassDTO.Info save(Tclass tclass) {
        final Tclass saved = tclassDAO.saveAndFlush(tclass);
        return modelMapper.map(saved, TclassDTO.Info.class);
    }

    @Transactional()
    @Override
    public List<ClassStudentDTO.AttendanceInfo> getStudents(Long classID) {
        final Optional<Tclass> ssById = tclassDAO.findById(classID);
        final Tclass tclass = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));

        List<ClassStudentDTO.AttendanceInfo> studentInfoSet = new ArrayList<>();
        Optional.ofNullable(tclass.getClassStudents())
                .ifPresent(classStudents ->
                        classStudents.forEach(cs ->
                                {
                                    if (!cs.getPresenceType().getCode().equals("kh"))
                                        studentInfoSet.add(modelMapper.map(cs, ClassStudentDTO.AttendanceInfo.class));
                                }
                        ));
        return studentInfoSet;
    }



    @Transactional
    @Override
    public void delete(TclassDTO.Delete request) {
        final List<Tclass> gAllById = tclassDAO.findAllById(request.getIds());
        for (Tclass tclass : gAllById) {
            delete(tclass.getId());
        }
    }


    @Transactional(readOnly = true)
    @Override
    public Long sessionsHourSum(Long classId) {
        List<ClassSessionDTO.Info> sessions = classSessionService.loadSessions(classId);
        Long sum = 0L;
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        for (ClassSessionDTO.Info session : sessions) {
            try {
                sum += sdf.parse(session.getSessionEndHour()).getTime() - sdf.parse(session.getSessionStartHour()).getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return sum;
    }


    @Transactional
    @Override
    public Long getEndGroup(Long courseId, Long termId) {
        List<Tclass> classes = tclassDAO.findByCourseIdAndTermId(courseId, termId);
        Long max = 0L;
        for (Tclass aClass : classes) {
            if (aClass.getGroup() > max) {
                max = aClass.getGroup();
            }
        }
        return max + 1;
    }

    @Transactional(readOnly = true)
    @Override
    public int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode) {
        Date today = new Date();
        return tclassDAO.updateClassState(classId, workflowEndingStatus, workflowEndingStatusCode, today);
    }

    @Override
    public Integer getWorkflowEndingStatusCode(Long classId) {
        return tclassDAO.getWorkflowEndingStatusCode(classId);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    @Override
    @Transactional
    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId, Long trainingId) {
        Tclass tclass = getTClass(classId);
        classStudents = tclass.getClassStudents();
        teacherId = tclass.getTeacherId();
        TclassDTO.ReactionEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.ReactionEvaluationResult.class);

        evaluationResult.setStudentCount(getStudentCount());

        trainingGradeToTeacher = getTrainingGradeToTeacher(classId, trainingId);

        calculateStudentsReactionEvaluationResult();
        evaluationResult.setFERGrade(getFERGrade(classId));
        evaluationResult.setFERPass(FERPass);
        evaluationResult.setFETGrade(getFETGrade());
        evaluationResult.setFETPass(FETPass);
        evaluationResult.setFECRGrade(getFECRGrade(evaluationResult.getFERGrade()));
        evaluationResult.setFECRPass(FECRPass);

        evaluationResult.setNumberOfEmptyReactionEvaluationForms(getNumberOfEmptyReactionEvaluationForms());
        evaluationResult.setNumberOfFilledReactionEvaluationForms(getNumberOfFilledReactionEvaluationForms());
        evaluationResult.setNumberOfInCompletedReactionEvaluationForms(getNumberOfInCompletedReactionEvaluationForms());
        evaluationResult.setPercenetOfFilledReactionEvaluationForms(getPercenetOfFilledReactionEvaluationForms());
        evaluationResult.setNumberOfExportedReactionEvaluationForms(getNumberOfExportedEvaluationForms());
        evaluationResult.setMinScore_ER(minScore_ER);
        evaluationResult.setMinScore_ET(minScore_ET);
        evaluationResult.setMinScoreFECR(minScoreFECR);

        evaluationResult.setStudentsGradeToFacility(studentsGradeToFacility);
        evaluationResult.setStudentsGradeToGoals(studentsGradeToGoals);
        evaluationResult.setStudentsGradeToTeacher(studentsGradeToTeacher);
        evaluationResult.setTrainingGradeToTeacher(getTrainingGradeToTeacher(classId, trainingId));
        evaluationResult.setTeacherGradeToClass(getTeacherGradeToClass(classId));
        return evaluationResult;
    }

    public Double getStudentsGradeToTeacher(Set<ClassStudent> classStudentList){
        this.classStudents = classStudentList;
        this.calculateStudentsReactionEvaluationResult();
        return this.studentsGradeToTeacher;
    }

    public void calculateStudentsReactionEvaluationResult() {
        double studentsGradeToTeacher_l = 0;
        double studentsGradeToFacility_l = 0;
        double studentsGradeToGoals_l = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3) {
                Evaluation evaluation = evaluationService.getStudentEvaluationForClass(classStudent.getTclassId(), classStudent.getId());
                if (evaluation != null) {
                    List<EvaluationAnswer> answers = evaluation.getEvaluationAnswerList();
                    double teacherTotalGrade = 0.0;
                    double facilityTotalGrade = 0.0;
                    double goalsTotalGrade = 0.0;
                    double teacherTotalWeight = 0.0;
                    double facilityTotalWeight = 0.0;
                    double goalsTotalWeight = 0.0;
                    for (EvaluationAnswer answer : answers) {
                        double weight = 1.0;
                        double grade = 1.0;
                        QuestionnaireQuestion questionnaireQuestion = null;
                        Optional<QuestionnaireQuestion> question = questionnaireQuestionDAO.findById(answer.getEvaluationQuestionId());
                        if (question.isPresent())
                            questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                        if (answer.getQuestionSource().getCode().equals("3") && question.isPresent()) {
                            weight = questionnaireQuestion.getWeight();
                        }
                        grade = Double.parseDouble(answer.getAnswer().getValue());
                        if (questionnaireQuestion != null) {
                            if (questionnaireQuestion.getEvaluationQuestion().getDomain().getCode().equalsIgnoreCase("SAT")) { // teacher
                                teacherTotalGrade += grade * weight;
                                teacherTotalWeight += weight;
                            } else if (questionnaireQuestion.getEvaluationQuestion().getDomain().getCode().equalsIgnoreCase("EQP")) { //Facilities
                                facilityTotalGrade += grade * weight;
                                facilityTotalWeight += weight;
                            }
                        }
                        else {//Goals
                            goalsTotalGrade += grade * weight;
                            goalsTotalWeight += weight;
                        }
                    }
                    if (teacherTotalWeight != 0)
                        studentsGradeToTeacher_l += (teacherTotalGrade / teacherTotalWeight);
                    if (facilityTotalWeight != 0)
                        studentsGradeToFacility_l += (facilityTotalGrade / facilityTotalWeight);
                    if (goalsTotalWeight != 0)
                        studentsGradeToGoals_l += (goalsTotalGrade / goalsTotalWeight);
                }
            }
        }
        if (getNumberOfFilledReactionEvaluationForms() != 0)
            studentsGradeToTeacher_l /= getNumberOfFilledReactionEvaluationForms();
        if (getNumberOfFilledReactionEvaluationForms() != 0)
            studentsGradeToFacility_l /= getNumberOfFilledReactionEvaluationForms();
        if (getNumberOfFilledReactionEvaluationForms() != 0)
            studentsGradeToGoals_l /= getNumberOfFilledReactionEvaluationForms();

        studentsGradeToTeacher = studentsGradeToTeacher_l;
        studentsGradeToFacility = studentsGradeToFacility_l;
        studentsGradeToGoals = studentsGradeToGoals_l;
    }

    public Double getTeacherGradeToClass(Long classId) {
        double result = 0.0;
        Evaluation evaluation = evaluationService.getTeacherEvaluationForClass(teacherId, classId);
        if (evaluation != null) {
            List<EvaluationAnswer> answers = evaluation.getEvaluationAnswerList();
            double totalGrade = 0.0;
            double totalWeight = 0.0;
            for (EvaluationAnswer answer : answers) {
                if (answer != null) {
                    double weight = 1.0;
                    double grade = 1.0;
                    Optional<QuestionnaireQuestion> question = questionnaireQuestionDAO.findById(answer.getEvaluationQuestionId());
                    QuestionnaireQuestion questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (answer.getQuestionSource().getCode().equals("3")) {
                        weight = questionnaireQuestion.getWeight();
                    }
                    grade = Double.parseDouble(answer.getAnswer().getValue());
                    totalGrade += grade * weight;
                    totalWeight += weight;
                }
            }
            if (totalWeight != 0)
                result = totalGrade / totalWeight;
        }
        return result;
    }

    public Double getTrainingGradeToTeacher(Long classId, Long trainingId) {
        double result = 0.0;
        Evaluation evaluation = evaluationService.getTrainingEvaluationForTeacher(teacherId, classId, trainingId);
        if (evaluation != null) {
            List<EvaluationAnswer> answers = evaluation.getEvaluationAnswerList();
            double totalGrade = 0.0;
            double totalWeight = 0.0;
            for (EvaluationAnswer answer : answers) {
                if (answer != null) {
                    double weight = 1.0;
                    double grade = 1.0;
                    Optional<QuestionnaireQuestion> question = questionnaireQuestionDAO.findById(answer.getEvaluationQuestionId());
                    QuestionnaireQuestion questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (answer.getQuestionSource().getCode().equals("3")) {
                        weight = questionnaireQuestion.getWeight();
                    }
                    grade = Double.parseDouble(answer.getAnswer().getValue());
                    totalGrade += grade * weight;
                    totalWeight += weight;
                }
            }
            if (totalWeight != 0)
                result = totalGrade / totalWeight;
        }
        return result;
    }

    public Double getFERGrade(Long classId) {
        double result = 0.0;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FER");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        double z3 = 0.0;
        double z4 = 0.0;
        double z5 = 0.0;
        double z6 = 0.0;
        double minQus_ER = 0.0;
        minScore_ER = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z3"))
                z3 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z4"))
                z4 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z5"))
                z5 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z6"))
                z6 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQusER"))
                minQus_ER = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreER"))
                minScore_ER = Double.parseDouble(parameterValue.getValue());
        }
        result = z4 * studentsGradeToTeacher + z3 * studentsGradeToGoals +
                z6 * studentsGradeToFacility + z5 * getTeacherGradeToClass(classId);
        result /= 100;
        if (result >= minScore_ER && getPercenetOfFilledReactionEvaluationForms() >= minQus_ER)
            FERPass = true;
        return result;
    }

    public Double getFETGrade() {
        double result = 0.0;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FET");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        double z1 = 0.0;
        double z2 = 0.0;
        minScore_ET = 0.0;
        double minQus_ET = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z1"))
                z1 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z2"))
                z2 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreET "))
                minScore_ET = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQusET"))
                minQus_ET = Double.parseDouble(parameterValue.getValue());
        }
        result = z2 * studentsGradeToTeacher + z1 * trainingGradeToTeacher;
        result /= 100;
        if (result >= minScore_ET && getPercenetOfFilledReactionEvaluationForms() >= minQus_ET)
            FETPass = true;
        return result;
    }

    public double getFECRGrade(double ferGrade) {
        double result = 0.0;
        double FECRZ = 0.0;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_R");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("FECRZ"))
                FECRZ = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                minScoreFECR = Double.parseDouble(parameterValue.getValue());
        }
        result = ferGrade * FECRZ;
        if (result >= minScoreFECR)
            FECRPass = true;
        return result;
    }

    public Integer getStudentCount() {
        if (classStudents != null)
            return classStudents.size();
        else
            return 0;
    }

    public Integer getNumberOfStudentCompletedEvaluation() {
        int studentEvaluations = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusLearning()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusBehavior()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusResults()).orElse(0) == 2) {
                studentEvaluations++;
            }
        }
        return studentEvaluations;
    }

    public Integer getNumberOfFilledReactionEvaluationForms() {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3)
                result++;
        }
        return result;
    }

    public Integer getNumberOfInCompletedReactionEvaluationForms() {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3)
                result++;
        }
        return result;
    }

    public Integer getNumberOfCompletedReactionEvaluationForms() {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2)
                result++;
        }
        return result;
    }

    public Integer getNumberOfEmptyReactionEvaluationForms() {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 0)
                result++;
        }
        return result;
    }


    public Integer getNumberOfExportedEvaluationForms() {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1)
                result++;
        }
        return result;
    }

    public Double getPercenetOfFilledReactionEvaluationForms() {
        double r1 = getNumberOfFilledReactionEvaluationForms();
        double r2 = getNumberOfFilledReactionEvaluationForms() + getNumberOfEmptyReactionEvaluationForms();
        double result = (r1 / r2) * 100;
        return result;
    }
    ///---------------------------------------------- Reaction Evaluation ----------------------------------------------

    //----------------------------------------------- Behavioral Evaluation --------------------------------------------
    @Override
    @Transactional
    public TclassDTO.BehavioralEvaluationResult getBehavioralEvaluationResult(Long classId) {
        Tclass tclass = getTClass(classId);
        TclassDTO.BehavioralEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.BehavioralEvaluationResult.class);

        Double[] studentsGrade = new Double[tclass.getClassStudents().size()];
        Double[] supervisorsGrade = new Double[tclass.getClassStudents().size()];
        String[] classStudentsName = new String[tclass.getClassStudents().size()];
        Integer numberOfFilledFormsByStudents = 0;
        Integer numberOfFilledFormsBySuperviosers = 0;
        double supervisorsMeanGrade = 0.0;
        double studentsMeanGrade = 0.0;
        int classMonthPassedTime = 0;
        int classDayPassedTime = 0;
        String classPassedTime = "";
        double FEBGrade = 0.0;
        boolean FEBPass = false;

        int index = 0;
        for (ClassStudent classStudent : tclass.getClassStudents()) {
            Evaluation evaluation = evaluationService.getBehavioralEvaluationByStudent(classStudent.getId(),classId);
            supervisorsGrade[index] = Double.parseDouble("50");
            studentsGrade[index] = getEvaluationGrade(evaluation);
            classStudentsName[index] = classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName();
            index++;
            if(evaluation != null)
                numberOfFilledFormsByStudents++;
        }

        numberOfFilledFormsBySuperviosers = index;

        for (Double aDouble : studentsGrade) {
            studentsMeanGrade += aDouble;
        }

        for (Double aDouble : supervisorsGrade) {
            supervisorsMeanGrade += aDouble;
        }

        if(numberOfFilledFormsByStudents != 0)
            studentsMeanGrade = studentsMeanGrade / numberOfFilledFormsByStudents;
        if(numberOfFilledFormsBySuperviosers != 0)
            supervisorsMeanGrade = supervisorsMeanGrade / numberOfFilledFormsBySuperviosers;

        Date todayDate = new Date();
        Calendar calendar = getGregorianCalendar(Integer.parseInt(tclass.getEndDate().substring(0,4)),Integer.parseInt(tclass.getEndDate().substring(5,7)),Integer.parseInt(tclass.getEndDate().substring(8,10)));
        Date classDate = calendar.getTime();
        classMonthPassedTime = getdifference(classDate,todayDate)/30;
        classDayPassedTime = getdifference(classDate,todayDate)%30;
        classPassedTime += "ماه: " + classMonthPassedTime + "، روز: " + classDayPassedTime;

        double percentOfFilledFormsByStudents = ((double) numberOfFilledFormsByStudents / (double) index )*100;

        Map<String,Object> result = getFEBGrade(studentsMeanGrade,supervisorsMeanGrade,percentOfFilledFormsByStudents);
        FEBGrade = (double) result.get("grade");
        FEBPass = (boolean) result.get("pass");

        evaluationResult.setClassPassedTime(classPassedTime);
        evaluationResult.setNumberOfFilledFormsByStudents(numberOfFilledFormsByStudents);
        evaluationResult.setNumberOfFilledFormsBySuperviosers(index);
        evaluationResult.setSupervisorsMeanGrade(supervisorsMeanGrade);
        evaluationResult.setStudentsMeanGrade(studentsMeanGrade);
        evaluationResult.setFEBGrade(FEBGrade);
        evaluationResult.setFEBPass(FEBPass);
        evaluationResult.setFECBGrade(50);
        evaluationResult.setFECBPass(true);
        evaluationResult.setStudentsGrade(studentsGrade);
        evaluationResult.setSupervisorsGrade(supervisorsGrade);
        evaluationResult.setClassStudentsName(classStudentsName);

        return evaluationResult;
    }

    public static int j_days_in_month[] = { 31, 31, 31, 31, 31, 31, 30, 30, 30,
            30, 30, 29 };

    public static int g_days_in_month[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30,
            31, 30, 31 };

    private static int parsBooleanToInt(Boolean sample) {
        if (sample)
            return 1;
        else
            return 0;
    }

    public static int getdifference(Date start, Date current) {
        Date[] datesofcperiod;
        double startdayofyear, currentdatofyear;
        int def = 0, periodnm = 0;
        GregorianCalendar gc = new GregorianCalendar();
        GregorianCalendar gc1 = new GregorianCalendar();
        gc.setTime(start);
        gc1.setTime(current);
        return def = (int) ((gc1.get(Calendar.YEAR) - gc.get(Calendar.YEAR)) * 365.2425)
                + gc1.get(Calendar.DAY_OF_YEAR) - gc.get(Calendar.DAY_OF_YEAR);
    }

    public static Calendar getGregorianCalendar(int year, int month, int day) {

        int gy, gm, gd;
        int jy, jm, jd;
        long g_day_no, j_day_no;
        boolean leap;

        int i;

        jy = year - 979;
        jm = month - 1;
        jd = day - 1;

        j_day_no = 365 * jy + (jy / 33) * 8 + (jy % 33 + 3) / 4;
        for (i = 0; i < jm; ++i)
            j_day_no += j_days_in_month[i];

        j_day_no += jd;

        g_day_no = j_day_no + 79;

        gy = (int) (1600 + 400 * (g_day_no / 146097)); /*
         * 146097 = 365*400 +
         * 400/4 - 400/100 +
         * 400/400
         */
        g_day_no = g_day_no % 146097;

        leap = true;
        if (g_day_no >= 36525) /* 36525 = 365*100 + 100/4 */
        {
            g_day_no--;
            gy += 100 * (g_day_no / 36524); /* 36524 = 365*100 + 100/4 - 100/100 */
            g_day_no = g_day_no % 36524;

            if (g_day_no >= 365)
                g_day_no++;
            else
                leap = false;
        }

        gy += 4 * (g_day_no / 1461); /* 1461 = 365*4 + 4/4 */
        g_day_no %= 1461;

        if (g_day_no >= 366) {
            leap = false;

            g_day_no--;
            gy += g_day_no / 365;
            g_day_no = g_day_no % 365;
        }

        for (i = 0; g_day_no >= g_days_in_month[i]
                + parsBooleanToInt(i == 1 && leap); i++)
            g_day_no -= g_days_in_month[i] + parsBooleanToInt(i == 1 && leap);

        gm = i + 1;
        gd = (int) (g_day_no + 1);

        GregorianCalendar gregorian = new  GregorianCalendar(gy, gm - 1, gd);
        return gregorian;
    }

    Double getEvaluationGrade(Evaluation evaluation){
        double result = 0.0;
        if (evaluation != null) {
            List<EvaluationAnswer> answers = evaluation.getEvaluationAnswerList();
            double totalGrade = 0.0;
            double totalWeight = 0.0;
            for (EvaluationAnswer answer : answers) {
                if (answer != null) {
                    double weight = 1.0;
                    double grade = 1.0;
                    Optional<QuestionnaireQuestion> question = questionnaireQuestionDAO.findById(answer.getEvaluationQuestionId());
                    QuestionnaireQuestion questionnaireQuestion = null;
                    if(question.isPresent())
                        questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (answer.getQuestionSource().getCode().equals("2") && questionnaireQuestion!=null) {
                        weight = questionnaireQuestion.getWeight();
                    }
                    grade = Double.parseDouble(answer.getAnswer().getValue());
                    totalGrade += grade * weight;
                    totalWeight += weight;
                }
            }
            if (totalWeight != 0)
                result = totalGrade / totalWeight;
        }

        return result;
    }

    public Map<String,Object> getFEBGrade(double studentsMeanGrade, double supervisorsMeanGrade, double percentOfFilledFormsByStudents) {
        double grade = 0.0;
        boolean pass = false;
        Map<String,Object> result = new HashMap<>();

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEB");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        double z7 = 0.0;
        double z8 = 0.0;
        double minScore_EB = 0.0;
        double minQus_EB = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z7"))
                z7 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z8"))
                z8 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreEB"))
                minScore_EB = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQusEB"))
                minQus_EB = Double.parseDouble(parameterValue.getValue());
        }
        grade = z7 * supervisorsMeanGrade + z8 * studentsMeanGrade;
        grade /= 100;
        if (grade >= minScore_EB && percentOfFilledFormsByStudents >= minQus_EB)
            pass = true;

        result.put("grade",grade);
        result.put("pass",pass);
        return result;
    }

    //----------------------------------------------- Behavioral Evaluation --------------------------------------------


    @Transactional(readOnly = true)
    @Override
    public List<TclassDTO.PersonnelClassInfo> findAllPersonnelClass(String national_code) {

        List<TclassDTO.PersonnelClassInfo> personnelClassInfo = null;

        List<?> personnelClassInfoList = tclassDAO.findAllPersonnelClass(national_code);

        if (personnelClassInfoList != null) {

            personnelClassInfo = new ArrayList<>(personnelClassInfoList.size());

            for (int i = 0; i < personnelClassInfoList.size(); i++) {
                Object[] classInfo = (Object[]) personnelClassInfoList.get(i);
                personnelClassInfo.add(new TclassDTO.PersonnelClassInfo(
                        Long.parseLong(classInfo[0].toString()),
                        classInfo[1].toString(),
                        classInfo[2].toString(),
                        Long.parseLong(classInfo[3].toString()),
                        classInfo[4].toString(),
                        classInfo[5].toString(),
                        Long.parseLong(classInfo[6].toString()),
                        classInfo[7].toString(),
                        Long.parseLong(classInfo[8].toString()),
                        classInfo[9].toString(),
                        classInfo[10].toString(),
                        Long.parseLong(classInfo[11].toString()),
                        classInfo[12].toString()));
            }
        }

        return (personnelClassInfo != null ? modelMapper.map(personnelClassInfo, new TypeToken<List<TclassDTO.PersonnelClassInfo>>() {
        }.getType()) : null);

    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.TeachingHistory> searchByTeachingHistory(SearchDTO.SearchRq request, Long tId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("teacherId", tId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);

         teacherId = tId;
        SearchDTO.SearchRs<TclassDTO.TeachingHistory> response = SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.TeachingHistory.class));
        for (TclassDTO.TeachingHistory aClass : response.getList()) {
            Tclass tclass = getTClass(aClass.getId());
            classStudents = tclass.getClassStudents();
            calculateStudentsReactionEvaluationResult();
            aClass.setEvaluationGrade(studentsGradeToTeacher);
        }
        return response;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.TeachingHistory> searchByTeacherId(SearchDTO.SearchRq request, Long tId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        list.add(makeNewCriteria("teacherId", tId, EOperator.equals, null));
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else
                request.getCriteria().setCriteria(list);
        } else
            request.setCriteria(criteriaRq);

        SearchDTO.SearchRs<TclassDTO.TeachingHistory> response = SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.TeachingHistory.class));

        return response;
    }

    @Transactional(readOnly = true)
    @Override
    public Double getClassReactionEvaluationGrade(Long classId, Long tId){
        teacherId = tId;
        Tclass tclass = getTClass(classId);
        classStudents = tclass.getClassStudents();
        calculateStudentsReactionEvaluationResult();
        return getFERGrade(classId);
    }

    @Transactional(readOnly = true)
    @Override
     public List<TclassDTO.Info> PersonnelClass(Long id) {

        List<Tclass> tclass= tclassDAO.findTclassesByCourseId(id);
        return modelMapper.map(tclass, new TypeToken<List<TclassDTO.Info>>() {
        }.getType());
    }
}
