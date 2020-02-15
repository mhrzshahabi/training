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

import java.text.ParseException;
import java.text.SimpleDateFormat;
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

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    private final IEvaluationService evaluationService;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final ParameterService parameterService;
    boolean FERPass = false;
    boolean FETPass = false;
    boolean FECRPass = false;
    Set<ClassStudent> classStudents;
    Long teacherId;
    double studentsGradeToTeacher = 0.0;
    double studentsGradeToGoals = 0.0;
    double studentsGradeToFacility = 0.0;

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
//        TclassDTO.Info tclass = modelMapper.map(request, TclassDTO.Info.class);
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
//        request.setTrainingPlaceSet(null);
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

//    @Transactional(readOnly = true)
//    @Override
//    public List<StudentDTO.Info> getOtherStudents(Long classID) {
//        final Optional<Tclass> ssById = tclassDAO.findById(classID);
//        final Tclass tclass = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));
//
//        List<Student> currentStudent = tclass.getStudentSet();
//        List<Student> allStudent = studentDAO.findAll();
//        List<Student> otherStudent = new ArrayList<>();
//
//        for (Student student : allStudent) {
//            if (!currentStudent.contains(student))
//                otherStudent.add(student);
//        }
//
//        List<StudentDTO.Info> studentInfoSet = new ArrayList<>();
//        Optional.of(otherStudent)
//                .ifPresent(students ->
//                        students.forEach(student ->
//                                studentInfoSet.add(modelMapper.map(student, StudentDTO.Info.class))
//                        ));
//        return studentInfoSet;
//    }


//    @Transactional
//    @Override
//    public void addStudent(Long studentId, Long classId) {
//        Tclass tclass = tclassDAO.getOne(classId);
//        Student student = studentDAO.getOne(studentId);
//
//        tclass.getStudentSet().add(student);
//    }


    @Transactional
    @Override
    public void delete(TclassDTO.Delete request) {
        final List<Tclass> gAllById = tclassDAO.findAllById(request.getIds());
        for (Tclass tclass : gAllById) {
            delete(tclass.getId());
        }
    }

//    @Transactional
//    @Override
//    public void addStudents(StudentDTO.Delete request, Long classId) {
//        Tclass tclass = tclassDAO.getOne(classId);
//        List<Student> gAllById = studentDAO.findAllById(request.getIds());
//        for (Student student : gAllById) {
//            tclass.getStudentSet().add(student);
//        }
//    }

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
        return tclassDAO.updateClassState(classId, workflowEndingStatus, workflowEndingStatusCode);
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

    @Override
    @Transactional
    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId) {
        Tclass tclass = getTClass(classId);
        classStudents = tclass.getClassStudents();
        teacherId = tclass.getTeacherId();
        TclassDTO.ReactionEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.ReactionEvaluationResult.class);

        evaluationResult.setStudentCount(getStudentCount());

//        calculateStudentsReactionEvaluationResult();
//        evaluationResult.setFERGrade(getFERGrade(classId));
//        evaluationResult.setFERPass(FERPass);
//        evaluationResult.setFETGrade(getFETGrade());
//        evaluationResult.setFETPass(FETPass);
//        evaluationResult.setFECRGrade(getFECRGrade(evaluationResult.getFERGrade()));
//        evaluationResult.setFECRPass(FECRPass);

        evaluationResult.setNumberOfEmptyReactionEvaluationForms(getNumberOfEmptyReactionEvaluationForms());
        evaluationResult.setNumberOfFilledReactionEvaluationForms(getNumberOfFilledReactionEvaluationForms());
        evaluationResult.setNumberOfInCompletedReactionEvaluationForms(getNumberOfInCompletedReactionEvaluationForms());
        evaluationResult.setPercenetOfFilledReactionEvaluationForms(getPercenetOfFilledReactionEvaluationForms());

        return evaluationResult;
    }

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    public void calculateStudentsReactionEvaluationResult() {
        studentsGradeToTeacher = 0;
        studentsGradeToFacility = 0;
        studentsGradeToGoals = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2) {
                Evaluation evaluation = evaluationService.getStudentEvaluationForClass(classStudent.getTclassId(), classStudent.getStudentId());
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
                    Optional<QuestionnaireQuestion> question = questionnaireQuestionDAO.findById(answer.getEvaluationQuestionId());
                    QuestionnaireQuestion questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (answer.getQuestionSource().getCode().equals("3")) {
                        weight = questionnaireQuestion.getWeight();
                    }
                    grade = Double.parseDouble(answer.getAnswer().getValue());
                    if (questionnaireQuestion.getEvaluationQuestion().getDomain().getCode().equalsIgnoreCase("PRF")) { // teacher
                        teacherTotalGrade += grade * weight;
                        teacherTotalWeight += weight;
                    } else if (questionnaireQuestion.getEvaluationQuestion().getDomain().getCode().equalsIgnoreCase("EQP")) { //Facilities
                        facilityTotalGrade += grade * weight;
                        facilityTotalWeight += weight;
                    } else if (questionnaireQuestion.getEvaluationQuestion().getDomain().getCode().equalsIgnoreCase("Content")) {//Goals
                        goalsTotalGrade += grade * weight;
                        goalsTotalWeight += weight;
                    }
                }
                studentsGradeToTeacher += (teacherTotalGrade / teacherTotalWeight);
                studentsGradeToFacility += (facilityTotalGrade / facilityTotalWeight);
                studentsGradeToGoals += (goalsTotalGrade / goalsTotalWeight);
            }
        }
        studentsGradeToTeacher /= getNumberOfCompletedReactionEvaluationForms();
        studentsGradeToFacility /= getNumberOfCompletedReactionEvaluationForms();
        studentsGradeToGoals /= getNumberOfCompletedReactionEvaluationForms();
    }

    public Double getTeacherGradeToClass(Long classId) {
        double result = 0.0;
        Evaluation evaluation = evaluationService.getTeacherEvaluationForClass(teacherId, classId);
        List<EvaluationAnswer> answers = evaluation.getEvaluationAnswerList();
        double totalGrade = 0.0;
        double totalWeight = 0.0;
        for (EvaluationAnswer answer : answers) {
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
        result = totalGrade / totalWeight;
        return result;
    }

    public Double getTrainingGradeToTeacher() {
        double result = 0.0;
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
        double minScore_ER = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z3"))
                z3 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z4"))
                z4 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z5"))
                z5 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z6"))
                z6 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQus_ER"))
                minQus_ER = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScore_ER"))
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
        double minScore_ET = 0.0;
        double minQus_ET = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z1"))
                z1 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z2"))
                z2 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScore_ET "))
                minScore_ET = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQus_ET"))
                minQus_ET = Double.parseDouble(parameterValue.getValue());
        }
        result = z2 * studentsGradeToTeacher + z1 * getTrainingGradeToTeacher();
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
//            else if (parameterValue.getCode().equalsIgnoreCase("minScore_ET "))
//                minScore_ET  = Double.parseDouble(parameterValue.getValue());
//            else if (parameterValue.getCode().equalsIgnoreCase("minQus_ET"))
//                minQus_ET = Double.parseDouble(parameterValue.getValue());
        }
        result = ferGrade * FECRZ;
//        if (result>=minScore_ET && getPercenetOfFilledReactionEvaluationForms()>=minQus_ET)
//            FECRPass = true;
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

    public Double getPercenetOfFilledReactionEvaluationForms() {
        double r1 = getNumberOfFilledReactionEvaluationForms();
        double r2 = getNumberOfFilledReactionEvaluationForms() + getNumberOfEmptyReactionEvaluationForms();
        double result = (r1 / r2) * 100;
        return result;
    }
    ///---------------------------------------------- Reaction Evaluation ----------------------------------------------

}
