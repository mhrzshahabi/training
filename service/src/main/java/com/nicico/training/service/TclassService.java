package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.TrainingClassBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Service
@RequiredArgsConstructor
public class TclassService implements ITclassService {

    private final ModelMapper modelMapper;
    private final TclassDAO tclassDAO;
    private final ClassSessionDAO classSessionDAO;
    private final ClassSessionService classSessionService;
    private final TrainingPlaceDAO trainingPlaceDAO;
    private final AttachmentService attachmentService;
    private final IEvaluationService evaluationService;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final ParameterService parameterService;
    private final ParameterValueService parameterValueService;
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final CourseDAO courseDAO;
    private final MessageSource messageSource;
    private final TargetSocietyService societyService;
    private final TargetSocietyDAO societyDAO;
    private final AttendanceDAO attendanceDAO;
    private final ParameterValueDAO parameterValueDAO;
    private final TrainingClassBeanMapper trainingClassBeanMapper;

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
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        List<Long> list = request.getTrainingPlaceIds();
        if(list != null) {
            List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
            Set<TrainingPlace> set = new HashSet<>(allById);
            tclass.setTrainingPlaceSet(set);
        }
        return save(tclass);
    }

    @Transactional
    public TclassDTO.Info safeCreate(TclassDTO.Create request, HttpServletResponse response) {
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        if (checkDuration(tclass)) {
            List<Long> list = request.getTrainingPlaceIds();
            if(list != null) {
                List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
                Set<TrainingPlace> set = new HashSet<>(allById);
                tclass.setTrainingPlaceSet(set);
            }
            Tclass save = tclassDAO.save(tclass);
            save.setTargetSocietyList(saveTargetSocieties(request.gettargetSocieties(), request.getTargetSocietyTypeId(), save.getId()));
            return modelMapper.map(save, TclassDTO.Info.class);
        } else {
            try {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(405, messageSource.getMessage("msg.invalid.data", null, locale));
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
        return null;
    }


    @Transactional
//    @Override
    public TclassDTO.Info update(Long id, TclassDTO.Update request, List<Long> cancelClassesIds) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Long classOldSupervisor = tclass.getSupervisor();
        Long classOldTeacher = tclass.getTeacherId();

        Tclass mappedClass = trainingClassBeanMapper.updateTClass(request, tclass);
        List<Long> trainingPlaceIds = request.getTrainingPlaceIds();
        Set<TrainingPlace> set = new HashSet<>();
        if(trainingPlaceIds != null) {
            List<TrainingPlace> allById = trainingPlaceDAO.findAllById(trainingPlaceIds);
            set.addAll(allById);
        }

        mappedClass.setTrainingPlaceSet(set);

        if(!mappedClass.getClassStatus().equals("4")){
            mappedClass.setClassCancelReasonId(null);
            mappedClass.setAlternativeClassId(null);
            mappedClass.setPostponeStartDate(null);
        }
        if(cancelClassesIds != null){
            Set<Tclass> canceledClasses = mappedClass.getCanceledClasses();
            for (Tclass canceledClass : canceledClasses) {
                canceledClass.setAlternativeClassId(null);
            }
            List<Tclass> tclasses = tclassDAO.findAllById(cancelClassesIds);
            HashSet<Tclass> tclassHashSet = new HashSet<>(tclasses);
            for (Tclass c : tclassHashSet) {
                c.setAlternativeClassId(id);
                c.setPostponeStartDate(mappedClass.getStartDate());
            }
        }

        Tclass updatedClass = tclassDAO.save(mappedClass);

        //TODO CHANGE THE WAY OF MAPPING ASAP
            //updateTargetSocieties(request.getTargetSocieties(), request.getTargetSocietyTypeId(), updatedClass);
            //updatedClass.setTargetSocietyTypeId(request.getTargetSocietyTypeId());
        //--------------------DONE BY ROYA---------------------
        if(classOldSupervisor!= null && request.getSupervisor() != null){
            if(!classOldSupervisor.equals(request.getSupervisor())){
                HashMap<String,Object> evaluation = new HashMap<>();
                evaluation.put("questionnaireTypeId",141L);
                evaluation.put("classId",id);
                evaluation.put("evaluatorId",classOldSupervisor);
                evaluation.put("evaluatorTypeId",454L);
                evaluation.put("evaluatedId",classOldTeacher);
                evaluation.put("evaluatedTypeId",187L);
                evaluation.put("evaluationLevelId",154L);
                evaluationService.deleteEvaluation(evaluation);
            }
        }
        if(classOldTeacher!= null && request.getTeacherId() != null){
            if(!classOldTeacher.equals(request.getTeacherId())){
                HashMap<String,Object> evaluation = new HashMap<>();
                evaluation.put("questionnaireTypeId",140L);
                evaluation.put("classId",id);
                evaluation.put("evaluatorId",classOldTeacher);
                evaluation.put("evaluatorTypeId",187L);
                evaluation.put("evaluatedId",id);
                evaluation.put("evaluatedTypeId",504L);
                evaluation.put("evaluationLevelId",154L);
                evaluationService.deleteEvaluation(evaluation);
            }
        }
        //-----------------------------------------------------

        TclassDTO.Info info = new TclassDTO.Info();
        info.setId(updatedClass.getId());
        return info;
    }

    @Transactional
//    @Override
    public void delete(Long id, HttpServletResponse resp) throws IOException {
        Optional<Tclass> byId = tclassDAO.findById(id);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<Attendance> attendances = attendanceDAO.findBySessionIn(tclass.getClassSessions());
        if(!attendances.isEmpty()){
            for (Attendance a : attendances) {
                if(!a.getState().equals("0")){
                    resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن حضور و غیاب قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
                    return;
                }
            }
        }
        if(!tclass.getClassSessions().isEmpty()){
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن جلسه قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }
        if(!tclass.getClassStudents().isEmpty()){
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن فراگیر قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }
        tclassDAO.deleteById(id);
        attendanceDAO.deleteAll(attendances);
        List<AttachmentDTO.Info> attachmentInfoList = attachmentService.search(null, "Tclass", id).getList();
        for (AttachmentDTO.Info attachment : attachmentInfoList) {
            attachmentService.delete(attachment.getId());
        }
    }

    @Transactional
//    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> mainSearch(SearchDTO.SearchRq request) {
        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {

        return BaseService.<Tclass, TclassDTO.Info, TclassDAO>optimizedSearch(tclassDAO, p->modelMapper.map(p, TclassDTO.Info.class), request);
   }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search1(SearchDTO.SearchRq request, Class<T> infoType) {
        return SearchUtil.search(tclassDAO, request, e -> modelMapper.map(e, infoType));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> evaluatedSearch(SearchDTO.SearchRq request) {
        Page<Tclass> all = tclassDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
        List<Tclass> list = all.getContent();

        Long totalCount = all.getTotalElements();
        SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> searchRs = null;

        if (totalCount == 0) {

            searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<TclassDTO.EvaluatedInfoGrid>());

        } else {
            List<Long> ids = new ArrayList<>();
            int len = list.size();

            for (int i = 0; i < len; i++) {
                ids.add(list.get(i).getId());
            }

            request.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));
            request.setStartIndex(null);


            searchRs = SearchUtil.search(tclassDAO, request, tclassDAO -> modelMapper.map(tclassDAO,
                    TclassDTO.EvaluatedInfoGrid.class));
        }

        searchRs.setTotalCount(totalCount);

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
    private List<TargetSociety> updateTargetSocieties(List<Object> societies, Long typeId, Tclass tclass) {
        List<TargetSociety> targets = tclass.getTargetSocietyList();
        String type = parameterValueService.get(typeId).getCode();
        for (int i = 0; i < targets.size(); i++) {

            TargetSociety society = targets.get(i);
            if (tclass.getTargetSocietyTypeId() == null || !tclass.getTargetSocietyTypeId().equals(typeId)) {

            } else if (type.equals("single")) {
                Object id = societies.stream().filter(s -> ((Integer) s).longValue() == society.getSocietyId()).findFirst().orElse(null);
                if (id != null) {
                    societies.remove(id);
                    continue;
                }
            } else if (type.equals("etc")) {
                Object id = societies.stream().filter(s -> (String) s == society.getTitle()).findFirst().orElse(null);
                if (id != null) {
                    societies.remove(id);
                    continue;
                }
            }
            targets.set(i, null);
        }
        targets.addAll(saveTargetSocieties(societies, typeId, tclass.getId()));
        return targets;
    }

    private List<TargetSociety> saveTargetSocieties(List<Object> societies, Long typeId, Long tclassId) {
        List<TargetSociety> result = new ArrayList<>();
        String type = parameterValueService.get(typeId).getCode();
        for (Object society : societies) {
            TargetSociety create = new TargetSociety();
            if (type.equals("single"))
                create.setSocietyId(((Integer) society).longValue());
            else if (type.equals("etc"))
                create.setTitle((String) society);
            create.setTclassId(tclassId);
            result.add(create);
        }
        return result;
    }

    public ParameterValue getTargetSocietyTypeById(Long id){
        Tclass tclass = tclassDAO.findById(id).orElse(null);
        return tclass != null ? tclass.getTargetSocietyType() : null;
    }

    @Transactional()
    public List<TargetSocietyDTO.Info> getTargetSocietiesListById(Long id){
        Tclass tclass = tclassDAO.findById(id).orElse(null);
        return tclass != null ? modelMapper.map(tclass.getTargetSocietyList(),new TypeToken<List<TargetSocietyDTO.Info>>(){}.getType()) : null;
    }

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
//    @Override
    public void delete(TclassDTO.Delete request, HttpServletResponse resp) throws IOException {
        final List<Tclass> gAllById = tclassDAO.findAllById(request.getIds());
        for (Tclass tclass : gAllById) {
            delete(tclass.getId(), resp);
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


    public boolean compareTodayDate(Long id) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        Tclass tclass = getTClass(id);
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));
        String startingDate = tclass.getStartDate();

        return todayDate.compareTo(startingDate) > 0 ? true : false;
    }

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    @Override
    @Transactional
    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId_l) {
        boolean FERPass = false;
        boolean FETPass = false;
        boolean FECRPass = false;
        double FERGrade = 0.0;
        double FETGrade = 0.0;
        double FECRGrade = 0.0;
        double minQus_ER = 0.0;
        double minScore_ER = 0.0;
        double minScore_ET = 0.0;
        double minQus_ET = 0.0;
        double minScoreFECR = 0.0;
        Set<ClassStudent> classStudents;
        Long teacherId = null;
        Long classId = classId_l;
        Long trainingId = null;
        double studentsGradeToTeacher = 0.0;
        double studentsGradeToGoals = 0.0;
        double studentsGradeToFacility = 0.0;
        double trainingGradeToTeacher = 0.0;
        double teacherGradeToClass = 0.0;
        double percenetOfFilledReactionEvaluationForms = 0.0;
        Integer studentCount = 0;

        Tclass tclass = getTClass(classId);
        classStudents = tclass.getClassStudents();
        teacherId = tclass.getTeacherId();
        trainingId = tclass.getSupervisor();
        TclassDTO.ReactionEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.ReactionEvaluationResult.class);

        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        teacherGradeToClass = getTeacherGradeToClass(classId, teacherId);
        trainingGradeToTeacher = getTrainingGradeToTeacher(classId, trainingId, teacherId);
        studentCount = getStudentCount(classStudents);


        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);


        FERGrade = (double) FERGradeResult.get("FERGrade");
        FERPass = (boolean) FERGradeResult.get("FERPass");
        minQus_ER = (double) FERGradeResult.get("minQus_ER");
        minScore_ER = (double) FERGradeResult.get("minScore_ER");

        Map<String, Object> FETGradeResult = getFETGrade(studentsGradeToTeacher,
                trainingGradeToTeacher,
                percenetOfFilledReactionEvaluationForms);
        FETGrade = (double) FETGradeResult.get("FETGrade");
        FETPass = (boolean) FETGradeResult.get("FETPass");
        minScore_ET = (double) FETGradeResult.get("minScore_ET");
        minQus_ET = (double) FETGradeResult.get("minQus_ET");

        Map<String, Object> FECRResult = getFECRGrade(FERGrade);

        FECRGrade = (double) FECRResult.get("FECRGrade");
        FECRPass = (boolean) FECRResult.get("FECRPass");
        minScoreFECR = (double) FECRResult.get("minScoreFECR");

        evaluationResult.setStudentCount(studentCount);
        evaluationResult.setFERGrade(FERGrade);
        evaluationResult.setFERPass(FERPass);
        evaluationResult.setFETGrade(FETGrade);
        evaluationResult.setFETPass(FETPass);
        evaluationResult.setFECRGrade(FECRGrade);
        evaluationResult.setFECRPass(FECRPass);
        evaluationResult.setMinScore_ER(minScore_ER);
        evaluationResult.setMinScore_ET(minScore_ET);
        evaluationResult.setMinScoreFECR(minScoreFECR);

        evaluationResult.setNumberOfEmptyReactionEvaluationForms(getNumberOfEmptyReactionEvaluationForms(classStudents));
        evaluationResult.setNumberOfFilledReactionEvaluationForms(getNumberOfFilledReactionEvaluationForms(classStudents));
        evaluationResult.setNumberOfInCompletedReactionEvaluationForms(getNumberOfInCompletedReactionEvaluationForms(classStudents));
        evaluationResult.setPercenetOfFilledReactionEvaluationForms(getPercenetOfFilledReactionEvaluationForms(classStudents));
        evaluationResult.setNumberOfExportedReactionEvaluationForms(getNumberOfExportedEvaluationForms(classStudents));


        evaluationResult.setStudentsGradeToFacility(studentsGradeToFacility);
        evaluationResult.setStudentsGradeToGoals(studentsGradeToGoals);
        evaluationResult.setStudentsGradeToTeacher(studentsGradeToTeacher);
        evaluationResult.setTrainingGradeToTeacher(trainingGradeToTeacher);
        evaluationResult.setTeacherGradeToClass(teacherGradeToClass);
        return evaluationResult;
    }

    public Double getStudentsGradeToTeacher(Set<ClassStudent> classStudentList) {
        Map<String, Double> result = calculateStudentsReactionEvaluationResult(classStudentList);
        return result.get("studentsGradeToTeacher");
    }

    @Transactional
    public Map<String, Double> calculateStudentsReactionEvaluationResult(Set<ClassStudent> classStudents) {
        double studentsGradeToTeacher_l = 0;
        double studentsGradeToFacility_l = 0;
        double studentsGradeToGoals_l = 0;
        Map<String, Double> result = new HashMap<>();
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3) {
                EvaluationDTO.Info evaluationDTO =  evaluationService.getEvaluationByData(139L, classStudent.getTclass().getId(), classStudent.getId(), 188L,
                        classStudent.getTclass().getId(), 504L, 154L);
                Evaluation evaluation = modelMapper.map(evaluationDTO,Evaluation.class);
                if (evaluation != null) {
                    List<EvaluationAnswerDTO.EvaluationAnswerFullData> answers =  evaluationService.getEvaluationFormAnswerDetail(evaluation);
                    double teacherTotalGrade = 0.0;
                    double facilityTotalGrade = 0.0;
                    double goalsTotalGrade = 0.0;
                    double teacherTotalWeight = 0.0;
                    double facilityTotalWeight = 0.0;
                    double goalsTotalWeight = 0.0;
                    for (EvaluationAnswerDTO.EvaluationAnswerFullData answer : answers) {
                        if (answer.getAnswerId() != null) {
                            if(answer.getDomainId().equals(54L)){ //Facilities
                                if(answer.getWeight() != null)
                                    facilityTotalWeight += answer.getWeight();
                                else
                                    facilityTotalWeight ++;
                                facilityTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue()))*answer.getWeight();
                            }
                            else if(answer.getDomainId().equals(183L)){ //Content
                                if(answer.getWeight() != null)
                                    goalsTotalWeight += answer.getWeight();
                                else
                                    goalsTotalWeight ++;
                                goalsTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue()))*answer.getWeight();
                            }
                            else if(answer.getDomainId().equals(53L)){ //teacher
                                if(answer.getWeight() != null)
                                    teacherTotalWeight += answer.getWeight();
                                else
                                    teacherTotalWeight ++;
                                teacherTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue()))*answer.getWeight();
                            }
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
        if (getNumberOfFilledReactionEvaluationForms(classStudents) != 0)
            studentsGradeToTeacher_l /= getNumberOfFilledReactionEvaluationForms(classStudents);
        if (getNumberOfFilledReactionEvaluationForms(classStudents) != 0)
            studentsGradeToFacility_l /= getNumberOfFilledReactionEvaluationForms(classStudents);
        if (getNumberOfFilledReactionEvaluationForms(classStudents) != 0)
            studentsGradeToGoals_l /= getNumberOfFilledReactionEvaluationForms(classStudents);

        result.put("studentsGradeToTeacher", studentsGradeToTeacher_l);
        result.put("studentsGradeToFacility", studentsGradeToFacility_l);
        result.put("studentsGradeToGoals", studentsGradeToGoals_l);
        return result;
    }

    public Double getTeacherGradeToClass(Long classId, Long teacherId) {
        EvaluationDTO.Info evaluationDTO =  evaluationService.getEvaluationByData(140L, classId, teacherId,
                187L, classId, 504L, 154L);
        if(evaluationDTO != null) {
            Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);
            return evaluationService.getEvaluationFormGrade(evaluation);
        }
        else
            return 0.0;
    }

    public Double getTrainingGradeToTeacher(Long classId, Long trainingId, Long teacherId) {
        EvaluationDTO.Info evaluationDTO =  evaluationService.getEvaluationByData(141L, classId, trainingId,
                454L, teacherId, 187L, 154L);
        if(evaluationDTO != null) {
            Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);
            return evaluationService.getEvaluationFormGrade(evaluation);
        }
        else
            return 0.0;
    }

    @Override
    @Transactional
    public double getJustFERGrade(Long classId) {
        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        double studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        double studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        double studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        double percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        double teacherGradeToClass = getTeacherGradeToClass(classId, tclass.getTeacherId());
        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        return (double) FERGradeResult.get("FERGrade");
    }

    @Override
    @Transactional
    public Map<String, Object> getFERAndFETGradeResult(Long classId) {
        Tclass tclass = getTClass(classId);
        Map<String, Object> result = new HashMap<>();
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        double studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        double studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        double studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        double percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        double teacherGradeToClass = getTeacherGradeToClass(classId, tclass.getTeacherId());
        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        result.put("FERGrade",FERGradeResult.get("FERGrade"));
        result.put("FERPass",FERGradeResult.get("FERPass"));

        double trainingGradeToTeacher = getTrainingGradeToTeacher(classId, tclass.getSupervisor(), tclass.getTeacherId());
        Map<String,Object> FETGradeResult = getFETGrade(studentsGradeToTeacher,trainingGradeToTeacher,percenetOfFilledReactionEvaluationForms);
        result.put("FETGrade", FETGradeResult.get("FETGrade"));
        result.put("FETPass", FETGradeResult.get("FETPass"));

        return result;
    }

    public Map<String, Object> getFERGrade(double studentsGradeToTeacher,
                                           double studentsGradeToGoals,
                                           double studentsGradeToFacility,
                                           double percenetOfFilledReactionEvaluationForms,
                                           double teacherGradeToClass) {
        Map<String, Object> result = new HashMap<>();
        boolean FERPass = false;
        double FERGrade = 0.0;

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
            else if (parameterValue.getCode().equalsIgnoreCase("minQusER"))
                minQus_ER = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreER"))
                minScore_ER = Double.parseDouble(parameterValue.getValue());
        }
        FERGrade = z4 * studentsGradeToTeacher + z3 * studentsGradeToGoals +
                z6 * studentsGradeToFacility + z5 * teacherGradeToClass;
        FERGrade /= 100;
        if (FERGrade >= minScore_ER && percenetOfFilledReactionEvaluationForms >= minQus_ER)
            FERPass = true;

        result.put("FERGrade", FERGrade);
        result.put("FERPass", FERPass);
        result.put("minQus_ER", minQus_ER);
        result.put("minScore_ER", minScore_ER);

        return result;
    }

    public Map<String, Object> getFETGrade(double studentsGradeToTeacher,
                                           double trainingGradeToTeacher,
                                           double percenetOfFilledReactionEvaluationForms) {
        Map<String, Object> result = new HashMap<>();
        boolean FETPass = false;
        double FETGrade = 0.0;

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
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreET "))
                minScore_ET = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQusET"))
                minQus_ET = Double.parseDouble(parameterValue.getValue());
        }
        FETGrade = z2 * studentsGradeToTeacher + z1 * trainingGradeToTeacher;
        FETGrade /= 100;
        if (FETGrade >= minScore_ET && percenetOfFilledReactionEvaluationForms >= minQus_ET)
            FETPass = true;

        result.put("FETGrade", FETGrade);
        result.put("FETPass", FETPass);
        result.put("minScore_ET", minScore_ET);
        result.put("minQus_ET", minQus_ET);

        return result;
    }

    public Map<String, Object> getFECRGrade(double FERGrade) {
        Map<String, Object> result = new HashMap<>();
        boolean FECRPass = false;
        double FECRGrade = 0.0;

        double FECRZ = 0.0;
        double minScoreFECR = 0.0;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_R");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("FECRZ"))
                FECRZ = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                minScoreFECR = Double.parseDouble(parameterValue.getValue());
        }
        FECRGrade = FERGrade * FECRZ;
        if (FECRGrade >= minScoreFECR)
            FECRPass = true;

        result.put("FECRGrade", FECRGrade);
        result.put("FECRPass", FECRPass);
        result.put("minScoreFECR", minScoreFECR);

        return result;
    }

    public Integer getStudentCount(Set<ClassStudent> classStudents) {
        if (classStudents != null)
            return classStudents.size();
        else
            return 0;
    }

    public Integer getNumberOfStudentCompletedEvaluation(Set<ClassStudent> classStudents) {
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

    public Integer getNumberOfFilledReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3)
                result++;
        }
        return result;
    }

    public Integer getNumberOfInCompletedReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3)
                result++;
        }
        return result;
    }

    public Integer getNumberOfCompletedReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2)
                result++;
        }
        return result;
    }

    public Integer getNumberOfEmptyReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 0)
                result++;
        }
        return result;
    }


    public Integer getNumberOfExportedEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1)
                result++;
        }
        return result;
    }

    public Double getPercenetOfFilledReactionEvaluationForms(Set<ClassStudent> classStudents) {
        double r1 = getNumberOfFilledReactionEvaluationForms(classStudents);
        double r2 = getNumberOfFilledReactionEvaluationForms(classStudents) + getNumberOfEmptyReactionEvaluationForms(classStudents);
        double result = (r1 / r2) * 100;
        return result;
    }


    @Transactional(readOnly = true)
    @Override
    public Double getClassReactionEvaluationGrade(Long classId, Long teacherId) {
        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        calculateStudentsReactionEvaluationResult(classStudents);

        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        double studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        double studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        double studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        double percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        double teacherGradeToClass = getTeacherGradeToClass(classId, teacherId);
        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        return (double) FERGradeResult.get("FERGrade");
    }

    ///---------------------------------------------- Reaction Evaluation ----------------------------------------------

    //----------------------------------------------- Behavioral Evaluation Old ----------------------------------------
    @Override
    @Transactional
    public TclassDTO.BehavioralEvaluationResult getBehavioralEvaluationResult(Long classId) {
        Tclass tclass = getTClass(classId);
        TclassDTO.BehavioralEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.BehavioralEvaluationResult.class);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Long teacherId = tclass.getTeacherId();

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
        double FECBGrade = 0.0;
        boolean FECBPass = false;

        int index = 0;
        for (ClassStudent classStudent : tclass.getClassStudents()) {
            Evaluation evaluation = evaluationService.getBehavioralEvaluationByStudent(classStudent.getId(), classId);
            supervisorsGrade[index] = Double.parseDouble("50");
            studentsGrade[index] = getEvaluationGrade(evaluation);
            classStudentsName[index] = classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName();
            index++;
            if (evaluation != null)
                numberOfFilledFormsByStudents++;
        }

        numberOfFilledFormsBySuperviosers = index;

        for (Double aDouble : studentsGrade) {
            studentsMeanGrade += aDouble;
        }

        for (Double aDouble : supervisorsGrade) {
            supervisorsMeanGrade += aDouble;
        }

        if (numberOfFilledFormsByStudents != 0)
            studentsMeanGrade = studentsMeanGrade / numberOfFilledFormsByStudents;
        if (numberOfFilledFormsBySuperviosers != 0)
            supervisorsMeanGrade = supervisorsMeanGrade / numberOfFilledFormsBySuperviosers;

        Date todayDate = new Date();
        Calendar calendar = getGregorianCalendar(Integer.parseInt(tclass.getEndDate().substring(0, 4)), Integer.parseInt(tclass.getEndDate().substring(5, 7)), Integer.parseInt(tclass.getEndDate().substring(8, 10)));
        Date classDate = calendar.getTime();
        classMonthPassedTime = getdifference(classDate, todayDate) / 30;
        classDayPassedTime = getdifference(classDate, todayDate) % 30;
        classPassedTime += "ماه: " + classMonthPassedTime + "، روز: " + classDayPassedTime;

        double percentOfFilledFormsByStudents = ((double) numberOfFilledFormsByStudents / (double) index) * 100;

        Map<String, Object> febresult = getFEBGrade(studentsMeanGrade, supervisorsMeanGrade, percentOfFilledFormsByStudents);
        FEBGrade = (double) febresult.get("grade");
        FEBPass = (boolean) febresult.get("pass");

        Map<String, Object> fecbResult = getFECBGrade(FEBGrade, classId, teacherId, classStudents, tclass.getScoringMethod());
        FECBGrade = (double) fecbResult.get("grade");
        FECBPass = (boolean) fecbResult.get("pass");

        evaluationResult.setClassPassedTime(classPassedTime);
        evaluationResult.setNumberOfFilledFormsByStudents(numberOfFilledFormsByStudents);
        evaluationResult.setNumberOfFilledFormsBySuperviosers(index);
        evaluationResult.setSupervisorsMeanGrade(supervisorsMeanGrade);
        evaluationResult.setStudentsMeanGrade(studentsMeanGrade);
        evaluationResult.setFEBGrade(FEBGrade);
        evaluationResult.setFEBPass(FEBPass);
        evaluationResult.setFECBGrade(FECBGrade);
        evaluationResult.setFECBPass(FECBPass);
        evaluationResult.setStudentsGrade(studentsGrade);
        evaluationResult.setSupervisorsGrade(supervisorsGrade);
        evaluationResult.setClassStudentsName(classStudentsName);

        return evaluationResult;
    }

    public static int[] j_days_in_month = {31, 31, 31, 31, 31, 31, 30, 30, 30,
            30, 30, 29};

    public static int[] g_days_in_month = {31, 28, 31, 30, 31, 30, 31, 31, 30,
            31, 30, 31};

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
        if (g_day_no >= 36525) /* 36525 = 365*100 + 100/4 */ {
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

        GregorianCalendar gregorian = new GregorianCalendar(gy, gm - 1, gd);
        return gregorian;
    }

    Double getEvaluationGrade(Evaluation evaluation) {
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
                    if (question.isPresent())
                        questionnaireQuestion = question.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    if (answer.getQuestionSource().getCode().equals("2") && questionnaireQuestion != null) {
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

    public Map<String, Object> getFEBGrade(double studentsMeanGrade, double supervisorsMeanGrade, double percentOfFilledFormsByStudents) {
        double grade = 0.0;
        boolean pass = false;
        Map<String, Object> result = new HashMap<>();

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

        result.put("grade", grade);
        result.put("pass", pass);
        return result;
    }

    public Map<String, Object> getFECBGrade(double FEBGrade_l, Long classId, Long teacherId, Set<ClassStudent> classStudents, String scoringMethod) {
        double grade = 0.0;
        boolean pass = false;
        Map<String, Object> result = new HashMap<>();
        double FEBGrade = FEBGrade_l;
        double FERGrade = 0.0;
        double FELGrade = 0.0;

        calculateStudentsReactionEvaluationResult(classStudents);
        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        double studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        double studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        double studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        double percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        double teacherGradeToClass = getTeacherGradeToClass(classId, teacherId);
        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        FERGrade = (double) FERGradeResult.get("FERGrade");

        FELGrade = evaluationAnalysistLearningService.getStudents(classId, scoringMethod)[3];

        TotalResponse<ParameterValueDTO.Info> parameters1 = parameterService.getByCode("FEC_B");
        List<ParameterValueDTO.Info> parameterValues1 = parameters1.getResponse().getData();
        double FECBZ1 = 0.0;
        double FECBZ2 = 0.0;
        double FECBZ3 = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues1) {
            if (parameterValue.getCode().equalsIgnoreCase("FECBZ1"))
                FECBZ1 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("FECBZ2"))
                FECBZ2 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("FECBZ3"))
                FECBZ3 = Double.parseDouble(parameterValue.getValue());
        }

        TotalResponse<ParameterValueDTO.Info> parameters2 = parameterService.getByCode("FEC_R");
        List<ParameterValueDTO.Info> parameterValues2 = parameters2.getResponse().getData();
        double minScoreFECR = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues2) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                minScoreFECR = Double.parseDouble(parameterValue.getValue());
        }
        grade = FECBZ1 * FERGrade + FECBZ2 * FELGrade + FECBZ3 * FEBGrade;
        grade /= 100;
        if (grade >= minScoreFECR)
            pass = true;

        result.put("grade", grade);
        result.put("pass", pass);
        return result;
    }

    //----------------------------------------------- Behavioral Evaluation Old ----------------------------------------
    @Transactional(readOnly = true)
    @Override
    public List<TclassDTO.PersonnelClassInfo> findAllPersonnelClass(String national_code, String personnel_no) {

        List<TclassDTO.PersonnelClassInfo> personnelClassInfo = null;

        List<?> personnelClassInfoList = tclassDAO.findAllPersonnelClass(national_code, personnel_no);

        if (personnelClassInfoList != null) {

            personnelClassInfo = new ArrayList<>(personnelClassInfoList.size());

            for (int i = 0; i < personnelClassInfoList.size(); i++) {
                Object[] classInfo = (Object[]) personnelClassInfoList.get(i);
                personnelClassInfo.add(new TclassDTO.PersonnelClassInfo(
                        (classInfo[0] != null ? Long.parseLong(classInfo[0].toString()) : null),
                        (classInfo[1] != null ? classInfo[1].toString() : null),
                        (classInfo[2] != null ? classInfo[2].toString() : null),
                        (classInfo[3] != null ? Long.parseLong(classInfo[3].toString()) : null),
                        (classInfo[4] != null ? classInfo[4].toString() : null),
                        (classInfo[5] != null ? classInfo[5].toString() : null),
                        (classInfo[6] != null ? Long.parseLong(classInfo[6].toString()) : null),
                        (classInfo[7] != null ? classInfo[7].toString() : null),
                        (classInfo[8] != null ? Long.parseLong(classInfo[8].toString()) : null),
                        (classInfo[9] != null ? classInfo[9].toString() : null),
                        (classInfo[10] != null ? classInfo[10].toString() : null),
                        (classInfo[11] != null ? Long.parseLong(classInfo[11].toString()) : null),
                        (classInfo[12] != null ? classInfo[12].toString() : null),
                        (classInfo[13] != null ? Long.parseLong(classInfo[13].toString()) : null),
                        (classInfo[14] != null ? classInfo[14].toString() : null)));
            }
        }

        return (personnelClassInfo != null ? modelMapper.map(personnelClassInfo, new TypeToken<List<TclassDTO.PersonnelClassInfo>>() {
        }.getType()) : null);

    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.TeachingHistory> searchByTeachingHistory(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else
                request.getCriteria().setCriteria(list);
        } else
            request.setCriteria(criteriaRq);

        SearchDTO.SearchRs<TclassDTO.TeachingHistory> response = SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.TeachingHistory.class));
        for (TclassDTO.TeachingHistory aClass : response.getList()) {
            Tclass tclass = getTClass(aClass.getId());
            Set<ClassStudent> classStudents = tclass.getClassStudents();
            Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
            double studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
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
    public List<TclassDTO.Info> PersonnelClass(Long id) {

        List<Tclass> tclass = tclassDAO.findTclassesByCourseId(id);
        return modelMapper.map(tclass, new TypeToken<List<TclassDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.TClassReport> reportSearch(SearchDTO.SearchRq request) {
        request.setStartIndex(null);
        request.setCount(100000);
        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.TClassReport.class));

    }

    private boolean checkDuration(Tclass tclass) {
        final float theoryDuration = courseDAO.getCourseTheoryDurationById(tclass.getCourseId());
        return theoryDuration >= tclass.getHDuration() ? true : false;

    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.InfoTuple> searchInfoTuple(SearchDTO.SearchRq request) {

        Page<Tclass> all = tclassDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
        List<Tclass> list = all.getContent();

        Long totalCount = all.getTotalElements();
        SearchDTO.SearchRs<TclassDTO.InfoTuple> searchRs = null;

        if (totalCount == 0) {

            searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<TclassDTO.InfoTuple>());

        } else {
            List<Long> ids = new ArrayList<>();
            int len = list.size();

            for (int i = 0; i < len; i++) {
                ids.add(list.get(i).getId());
            }

            request.setCriteria(makeNewCriteria("", null, EOperator.or, null));
            List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
            SearchDTO.CriteriaRq tmpcriteria = null;
            int page = 0;

            while (page * 1000 < ids.size()) {
                page++;
                criteriaRqList.add(makeNewCriteria("id", ids.subList((page - 1) * 1000, Math.min((page * 1000), ids.size())), EOperator.inSet, null));

            }

            request.setCriteria(makeNewCriteria("", null, EOperator.or, criteriaRqList));
            request.setStartIndex(null);


            searchRs = SearchUtil.search(tclassDAO, request, tclassDAO -> modelMapper.map(tclassDAO,
                    TclassDTO.InfoTuple.class));
        }

        searchRs.setTotalCount(totalCount);

        return searchRs;
    }

    @Transactional(readOnly = true)
    public Boolean hasSessions(Long id){
        return classSessionDAO.existsByClassId(id);
    }
}
