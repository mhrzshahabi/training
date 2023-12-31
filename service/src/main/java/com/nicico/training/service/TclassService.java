package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.mapper.ClassSession.SessionBeanMapper;
import com.nicico.training.mapper.TrainingClassBeanMapper;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.ClassStatus;
import com.nicico.training.repository.*;
import com.nicico.training.utility.persianDate.MyUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerList;
import response.BaseResponse;
import response.evaluation.dto.AveragePerQuestion;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import response.evaluation.dto.TeacherEvaluationAnswer;
import response.tclass.ElsSessionResponse;
import response.tclass.dto.TclassDto;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class TclassService implements ITclassService {


    private final ModelMapper modelMapper;
    private final EvaluationQuestionDAO evaluationQuestionDAO;
    private final TclassDAO tclassDAO;
    private final TclassAuditDAO tclassAuditDAO;
    private final TeacherDAO teacherDAO;
    private final ClassSessionDAO classSessionDAO;
    private final LockClassDAO lockClassDAO;
    private final EvaluationDAO evaluationDAO;
    private final StudentDAO studentDAO;
    private final EvaluationAnswerService evaluationAnswerService;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final DynamicQuestionDAO dynamicQuestionDAO;
    private final ClassSessionService classSessionService;
    private final TermDAO termDAO;
    private final TrainingPlaceDAO trainingPlaceDAO;
    private final IEvaluationService evaluationService;
    private final IWorkGroupService workGroupService;
    private final ParameterService parameterService;
    private final ParameterValueService parameterValueService;
    private final CourseDAO courseDAO;
    private final MessageSource messageSource;
    private final TargetSocietyService targetSocietyService;
    private final AttendanceDAO attendanceDAO;
    private final EvaluationAnswerDAO evaluationAnswerDAO;
    private final ParameterValueDAO parameterValueDAO;
    private final TrainingClassBeanMapper trainingClassBeanMapper;
    private final EvaluationAnalysisDAO evaluationAnalysisDAO;
    private final ClassCheckListDAO classCheckListDAO;
    private final ClassDocumentDAO classDocumentDAO;
    private final AttachmentDAO attachmentDAO;
    private final TargetSocietyDAO targetSocietyDAO;
    private final TestQuestionDAO testQuestionDAO;
    private final QuestionBankDAO questionBankDAO;
    private final QuestionBankTestQuestionDAO questionBankTestQuestionDAO;
    private final TclassBeanMapper tclassBeanMapper;
    private final SessionBeanMapper sessionBeanMapper;
    private DecimalFormat numberFormat = new DecimalFormat("#.00");

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
        if (list != null) {
            List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
            Set<TrainingPlace> set = new HashSet<>(allById);
            tclass.setTrainingPlaceSet(set);
        }
        return save(tclass);
    }

    @Transactional
    public TclassDto safeCreate(TclassDTO.Create request, HttpServletResponse response) {
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        if (checkDuration(tclass)) {
            List<Long> list = request.getTrainingPlaceIds();
            if (list != null) {
                List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
                Set<TrainingPlace> set = new HashSet<>(allById);
                tclass.setTrainingPlaceSet(set);
            }
            Tclass save = tclassDAO.save(tclass);
            save.setTargetSocietyList(saveTargetSocieties(request.getTargetSocieties(), request.getTargetSocietyTypeId(), save.getId()));
            return tclassBeanMapper.toTclassResponse(save);
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
    public TclassDto update(Long id, TclassDTO.Update request, List<Long> cancelClassesIds) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Long classOldSupervisor = tclass.getSupervisorId();
        Long classOldTeacher = tclass.getTeacherId();
        if (tclass.getClassStatus().equals("4")){
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
        }
        else if (!tclass.getTargetPopulationTypeId().equals(request.getTargetPopulationTypeId())){
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
        } else {
            Tclass mappedClass = trainingClassBeanMapper.updateTClass(request, tclass);
            List<Long> trainingPlaceIds = request.getTrainingPlaceIds();
            Set<TrainingPlace> set = new HashSet<>();
            if (trainingPlaceIds != null) {
                List<TrainingPlace> allById = trainingPlaceDAO.findAllById(trainingPlaceIds);
                set.addAll(allById);
            }

            mappedClass.setTrainingPlaceSet(set);

            if (mappedClass.getClassStatus() != null && !mappedClass.getClassStatus().equals("4")) {
                mappedClass.setClassCancelReasonId(null);
                mappedClass.setAlternativeClassId(null);
                mappedClass.setPostponeStartDate(null);
            }
            if (cancelClassesIds != null) {
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
            if (classOldSupervisor != null && request.getSupervisorId() != null) {
                if (!classOldSupervisor.equals(request.getSupervisorId())) {
                    HashMap<String, Object> evaluation = new HashMap<>();
                    evaluation.put("questionnaireTypeId", 141L);
                    evaluation.put("classId", id);
                    evaluation.put("evaluatorId", classOldSupervisor);
                    evaluation.put("evaluatorTypeId", 454L);
                    evaluation.put("evaluatedId", classOldTeacher);
                    evaluation.put("evaluatedTypeId", 187L);
                    evaluation.put("evaluationLevelId", 154L);
                    evaluationService.deleteEvaluation(evaluation);
                }
            }
            if (classOldTeacher != null && request.getTeacherId() != null) {
                if (!classOldTeacher.equals(request.getTeacherId())) {
                    HashMap<String, Object> evaluation = new HashMap<>();
                    evaluation.put("questionnaireTypeId", 140L);
                    evaluation.put("classId", id);
                    evaluation.put("evaluatorId", classOldTeacher);
                    evaluation.put("evaluatorTypeId", 187L);
                    evaluation.put("evaluatedId", id);
                    evaluation.put("evaluatedTypeId", 504L);
                    evaluation.put("evaluationLevelId", 154L);
                    evaluationService.deleteEvaluation(evaluation);
                }
            }
            //-----------------------------------------------------

            return tclassBeanMapper.toTclassResponse(updatedClass);
        }
    }

    @Transactional
    public void delete(Long id, HttpServletResponse resp) throws IOException {
        Optional<Tclass> byId = tclassDAO.findById(id);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<Attendance> attendances = attendanceDAO.findBySessionIn(tclass.getClassSessions());
        if (!attendances.isEmpty()) {
            for (Attendance a : attendances) {
                if (!a.getState().equals("0")) {
                    resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن حضور و غیاب قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
                    return;
                }
            }
        }
        if (!tclass.getClassSessions().isEmpty()) {
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن جلسه قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }
        if (!tclass.getClassStudents().isEmpty()) {
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن فراگیر قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }
        List<ClassCheckList> classCheckLists= classCheckListDAO.findClassCheckListByTclassId(id);

        if (!classCheckLists.isEmpty()) {
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن چک لیست قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }

        List<ClassDocument> classDocuments = classDocumentDAO.findClassDocumentByTclassId(id);

        if (!classDocuments.isEmpty()) {
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن مستندات قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }

        List<Attachment> attachments = attachmentDAO.findAttachmentByObjectTypeAndObjectId("Tclass", id);

        if (!attachments.isEmpty()) {
            resp.sendError(409, messageSource.getMessage("کلاس فوق بدلیل داشتن ضمائم قابل حذف نیست. ", null, LocaleContextHolder.getLocale()));
            return;
        }


        List<Long> testQuestionIds = testQuestionDAO.findByTclassId(id).stream().map(TestQuestion::getId).collect(Collectors.toList());
        List<Long> questionBankIds = questionBankDAO.findByTclassId(id).stream().map(QuestionBank::getId).collect(Collectors.toList());
        List<QuestionBankTestQuestion> allQT = new ArrayList<>();
        testQuestionIds.forEach(tIds -> questionBankIds.forEach(qIds -> allQT.addAll(questionBankTestQuestionDAO.findByQuestionBankIdAndTestQuestionId(qIds, tIds))));

        allQT.stream().map(QuestionBankTestQuestion::getId).forEach(questionBankTestQuestionDAO::deleteById);
        testQuestionIds.forEach(testQuestionDAO::deleteById);
        questionBankIds.forEach(questionBankDAO::deleteById);


        List<TargetSociety> targetSocieties = targetSocietyDAO.findAllByTclassId(id);
        targetSocieties.forEach(item -> targetSocietyService.delete(item.getId()));

        targetSocietyDAO.deleteClassTrainingPlace(id);
        testQuestionDAO.deleteClassPreCourseTestQuestion(id);

        for (Evaluation eva : tclass.getEvaluations()) {
            List<EvaluationAnswer> evaluationAnswers = evaluationAnswerDAO.findByEvaluationId(eva.getId());
            evaluationAnswers.forEach(item -> evaluationAnswerService.delete(item.getId()));
            evaluationService.delete(eva.getId());
        }

        evaluationAnalysisDAO.deleteByTClassId(id);

        Teacher teacher = teacherDAO.findById(tclass.getTeacherId()).orElse(null);
        if (teacher != null)
            teacher.getTclasse().remove(tclass);

        tclassDAO.delete(tclass);
//        attendanceDAO.deleteAll(attendances);
//        List<AttachmentDTO.Info> attachmentInfoList = attachmentService.search(null, "Tclass", id).getList();
//        for (AttachmentDTO.Info attachment : attachmentInfoList) {
//            attachmentService.delete(attachment.getId());
//        }
    }

    @Transactional
    public SearchDTO.SearchRs<TclassDTO.Info> mainSearch(SearchDTO.SearchRq request) {
        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {

        return BaseService.<Tclass, TclassDTO.Info, TclassDAO>optimizedSearch(tclassDAO, p -> modelMapper.map(p, TclassDTO.Info.class), request);
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

    private List<TargetSociety> updateTargetSocieties(List<Object> societies, Long typeId, Tclass tclass) {
        List<TargetSociety> targets = tclass.getTargetSocietyList();
        String type = parameterValueService.get(typeId).getCode();
        Iterator<TargetSociety> societyIterator = targets.iterator();
        while (societyIterator.hasNext()) {

            TargetSociety society = societyIterator.next();
            if (tclass.getTargetSocietyTypeId() == null || !tclass.getTargetSocietyTypeId().equals(typeId)) {

            } else if (type.equals("single")) {
                Object id = societies.stream().filter(s -> ((Integer) s).longValue() == society.getSocietyId()).findFirst().orElse(null);
                if (id != null) {
                    societies.remove(id);
                    continue;
                }
            } else if (type.equals("etc")) {
                Object id = societies.stream().filter(s -> ((String) s).equals(society.getTitle())).findFirst().orElse(null);
                if (id != null) {
                    societies.remove(id);
                    continue;
                }
            }
            societyIterator.remove();
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

    public ParameterValue getTargetSocietyTypeById(Long id) {
        Tclass tclass = tclassDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return tclass != null ? tclass.getTargetSocietyType() : null;
    }

    @Transactional()
    public List<TargetSocietyDTO.Info> getTargetSocietiesListById(Long id) {
        Tclass tclass = tclassDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return tclass != null ? modelMapper.map(tclass.getTargetSocietyList(), new TypeToken<List<TargetSocietyDTO.Info>>() {
        }.getType()) : null;
    }

    private TclassDTO.Info save(Tclass tclass) {
        final Tclass saved = tclassDAO.saveAndFlush(tclass);
        return modelMapper.map(saved, TclassDTO.Info.class);
    }

    @Override
    public void changeOnlineEvalTeacherStatus(Long classId, boolean state) {
        tclassDAO.changeOnlineEvalTeacherStatus(classId, state);
    }

    @Override
    public void changeOnlineEvalStudentStatus(Long classId, boolean state) {
        tclassDAO.changeOnlineEvalStudentStatus(classId, state);
    }

    //state 3 = payan yafte
    //state 5 = ekhtemam
    @Transactional
    @Override
    public BaseResponse changeClassStatus(Long classId, String state,String reason){
        BaseResponse response=new BaseResponse();
        Tclass tclass=new Tclass();
        Optional<LockClass> lockClassOptional=lockClassDAO.findByClassId(classId);
        Optional<Tclass> optionalTClass = tclassDAO.findById(classId);
        if (optionalTClass.isPresent()){
            tclass =optionalTClass.get();
        }

        String classStatus = get(classId).getClassStatus();
        switch (state){
            case "lock":{
                if (classStatus.equals(ClassStatus.finish.getId().toString())) {
                    if (lockClassOptional.isPresent()) {
                        response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                        response.setMessage("کلاس مورد نظر قبلا در اختتام بوده است");
                    }
                    else{
                        LockClass lockClass=new LockClass();
                        lockClass.setClassId(classId);
                        lockClass.setReason(reason);
                        lockClass.setClassCode(get(classId).getCode());
                        lockClassDAO.save(lockClass);
                        tclass.setClassStatus(ClassStatus.lock.getId().toString());
                        tclassDAO.save(tclass);

//                        tclassDAO.changeClassStatus(classId, ClassStatus.lock.getId().toString());
                        response.setStatus(200);
                    }
                } else
                {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    response.setMessage("کلاس مورد نظر در وضعیت پایان یافته نیست");
                }
                return response;
            }
            case "unLock":{
                if (classStatus.equals(ClassStatus.lock.getId().toString())) {
                    if (lockClassOptional.isPresent()) {
                        lockClassDAO.deleteById(lockClassOptional.get().getId());
                        tclass.setClassStatus(ClassStatus.finish.getId().toString());
                        tclassDAO.save(tclass);
//                        tclassDAO.changeClassStatus(classId, ClassStatus.finish.getId().toString());
                        response.setStatus(200);
                    }
                    else{
                        response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                        response.setMessage("کلاس مورد نظر در لیست کلاس های اختتام نیست");
                    }
                } else
                {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    response.setMessage("کلاس مورد نظر در  وضعیت اختتام نیست");
                }
                return response;
            }
        }

//

//
        return null;
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
                log.error("Exception", e);
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

        return todayDate.compareTo(startingDate) >= 0 ? true : false;
    }

    //----------------------------------------------- Reaction Evaluation ----------------------------------------------
    @Override
    @Transactional
    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId_l) {
        Boolean FERPass = null;
        Boolean FETPass = null;
        Boolean FECRPass = null;
        Double FERGrade = null;
        Double FETGrade = null;
        Double FECRGrade = null;
        Double minQus_ER = null;
        Double minScore_ER = null;
        Double minScore_ET = null;
        Double minQus_ET = null;
        Double minScoreFECR = null;
        Set<ClassStudent> classStudents;
        Long teacherId = null;
        Long classId = classId_l;
        Long trainingId = null;
        Double studentsGradeToTeacher = null;
        Double studentsGradeToGoals = null;
        Double studentsGradeToFacility = null;
        Double trainingGradeToTeacher = null;
        Double teacherGradeToClass = null;
        Double percenetOfFilledReactionEvaluationForms = null;
        Integer studentCount = null;
        String FERGradeS = null;

        Tclass tclass = getTClass(classId);
        classStudents = tclass.getClassStudents();
        teacherId = tclass.getTeacherId();
        trainingId = tclass.getSupervisorId();
        TclassDTO.ReactionEvaluationResult evaluationResult = modelMapper.map(tclass, TclassDTO.ReactionEvaluationResult.class);

        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        if (reactionEvaluationResult.get("studentsGradeToTeacher") != null)
            studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        if (reactionEvaluationResult.get("studentsGradeToGoals") != null)
            studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        if (reactionEvaluationResult.get("studentsGradeToFacility") != null)
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


        if (FERGradeResult.get("FERGrade") != null)
            FERGrade = (Double) FERGradeResult.get("FERGrade");
        if (FERGradeResult.get("FERPass") != null)
            FERPass = (Boolean) FERGradeResult.get("FERPass");
        if (FERGradeResult.get("minQus_ER") != null)
            minQus_ER = (Double) FERGradeResult.get("minQus_ER");
        if (FERGradeResult.get("minQus_ER") != null)
            minScore_ER = (Double) FERGradeResult.get("minScore_ER");

        Map<String, Object> FETGradeResult = getFETGrade(studentsGradeToTeacher,
                trainingGradeToTeacher,
                percenetOfFilledReactionEvaluationForms);
        if (FETGradeResult.get("FETGrade") != null)
            FETGrade = (Double) FETGradeResult.get("FETGrade");
        if (FETGradeResult.get("FETPass") != null)
            FETPass = (Boolean) FETGradeResult.get("FETPass");
        if (FETGradeResult.get("minScore_ET") != null)
            minScore_ET = (Double) FETGradeResult.get("minScore_ET");
        if (FETGradeResult.get("minQus_ET") != null)
            minQus_ET = (Double) FETGradeResult.get("minQus_ET");

        Map<String, Object> FECRResult = null;
        if (FERGrade != null)
            FERGradeS = FERGrade.toString();
        List<EvaluationAnalysis> evaluationAnalyses = evaluationAnalysisDAO.findByTClassId(classId);
        if (evaluationAnalyses != null && evaluationAnalyses.size() != 0) {
            FECRResult = calculateEffectivenessEvaluation(FERGradeS, evaluationAnalyses.get(0).getLearningGrade(), evaluationAnalyses.get(0).getBehavioralGrade(), tclass.getEvaluation());
        } else {
            FECRResult = calculateEffectivenessEvaluation(FERGradeS, null, null, tclass.getEvaluation());
        }

        if (FECRResult.get("EffectivenessGrade") != null)
            FECRGrade = (Double) FECRResult.get("EffectivenessGrade");
        if (FECRResult.get("EffectivenessPass") != null)
            FECRPass = (Boolean) FECRResult.get("EffectivenessPass");
        if (FECRResult.get("minScoreFECR") != null)
            minScoreFECR = (Double) FECRResult.get("minScoreFECR");

        if (studentCount != null)
            evaluationResult.setStudentCount(studentCount);
        if (FERGrade != null)
            evaluationResult.setFERGrade(Double.parseDouble(numberFormat.format(FERGrade).toString()));
        if (FERPass != null)
            evaluationResult.setFERPass(FERPass);
        if (FETGrade != null)
            evaluationResult.setFETGrade(Double.parseDouble(numberFormat.format(FETGrade).toString()));
        if (FETPass != null)
            evaluationResult.setFETPass(FETPass);
        if (FECRGrade != null)
            evaluationResult.setFECRGrade(Double.parseDouble(numberFormat.format(FECRGrade).toString()));
        if (FECRPass != null)
            evaluationResult.setFECRPass(FECRPass);
        if (minScore_ER != null)
            evaluationResult.setMinScore_ER(minScore_ER);
        if (minScore_ET != null)
            evaluationResult.setMinScore_ET(minScore_ET);
        if (minScoreFECR != null)
            evaluationResult.setMinScoreFECR(minScoreFECR);

        if (getNumberOfEmptyReactionEvaluationForms(classStudents) != null)
            evaluationResult.setNumberOfEmptyReactionEvaluationForms(getNumberOfEmptyReactionEvaluationForms(classStudents));
        if (getNumberOfFilledReactionEvaluationForms(classStudents) != null)
            evaluationResult.setNumberOfFilledReactionEvaluationForms(getNumberOfFilledReactionEvaluationForms(classStudents));
        if (getNumberOfInCompletedReactionEvaluationForms(classStudents) != null)
            evaluationResult.setNumberOfInCompletedReactionEvaluationForms(getNumberOfInCompletedReactionEvaluationForms(classStudents));
        if (getPercenetOfFilledReactionEvaluationForms(classStudents) != null)
            evaluationResult.setPercenetOfFilledReactionEvaluationForms(Double.parseDouble(numberFormat.format(getPercenetOfFilledReactionEvaluationForms(classStudents)).toString()));
        if (getNumberOfExportedEvaluationForms(classStudents) != null)
            evaluationResult.setNumberOfExportedReactionEvaluationForms(getNumberOfExportedEvaluationForms(classStudents));

        if (studentsGradeToFacility != null)
            evaluationResult.setStudentsGradeToFacility(Double.parseDouble(numberFormat.format(studentsGradeToFacility).toString()));
        if (studentsGradeToGoals != null)
            evaluationResult.setStudentsGradeToGoals(Double.parseDouble(numberFormat.format(studentsGradeToGoals).toString()));
        if (studentsGradeToTeacher != null)
            evaluationResult.setStudentsGradeToTeacher(Double.parseDouble(numberFormat.format(studentsGradeToTeacher).toString()));
        if (trainingGradeToTeacher != null)
            evaluationResult.setTrainingGradeToTeacher(Double.parseDouble(numberFormat.format(trainingGradeToTeacher).toString()));
        if (teacherGradeToClass != null)
            evaluationResult.setTeacherGradeToClass(Double.parseDouble(numberFormat.format(teacherGradeToClass).toString()));

        if (FETGradeResult.get("z1") != null)
            evaluationResult.setZ1(Double.parseDouble(FETGradeResult.get("z1").toString()));
        if (FETGradeResult.get("z2") != null)
            evaluationResult.setZ2(Double.parseDouble(FETGradeResult.get("z2").toString()));
        return evaluationResult;
    }

    @Override
    @Transactional
    public Double getJustFERGrade(Long classId) {
        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        Double studentsGradeToTeacher = null;
        Double studentsGradeToGoals = null;
        Double studentsGradeToFacility = null;
        Double percenetOfFilledReactionEvaluationForms = null;
        Double teacherGradeToClass = null;

        if (reactionEvaluationResult.get("studentsGradeToTeacher") != null)
            studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        if (reactionEvaluationResult.get("studentsGradeToGoals") != null)
            studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        if (reactionEvaluationResult.get("studentsGradeToFacility") != null)
            studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        if (getPercenetOfFilledReactionEvaluationForms(classStudents) != null)
            percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);
        teacherGradeToClass = getTeacherGradeToClass(classId, tclass.getTeacherId());

        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        if (FERGradeResult.get("FERGrade") != null)
            return (Double) FERGradeResult.get("FERGrade");
        else
            return null;
    }

    @Override
    @Transactional
    public Map<String, Object> getFERAndFETGradeResult(Long classId) {
        Tclass tclass = getTClass(classId);
        Map<String, Object> result = new HashMap<>();
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);

        Double studentsGradeToTeacher = null;
        Double studentsGradeToGoals = null;
        Double studentsGradeToFacility = null;
        Double percenetOfFilledReactionEvaluationForms = null;
        Double teacherGradeToClass = getTeacherGradeToClass(classId, tclass.getTeacherId());

        if (reactionEvaluationResult.get("studentsGradeToTeacher") != null)
            studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        if (reactionEvaluationResult.get("studentsGradeToGoals") != null)
            studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        if (reactionEvaluationResult.get("studentsGradeToFacility") != null)
            studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        if (getPercenetOfFilledReactionEvaluationForms(classStudents) != null)
            percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);


        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        if (FERGradeResult.get("FERGrade") != null)
            result.put("FERGrade", FERGradeResult.get("FERGrade"));
        if (FERGradeResult.get("FERPass") != null)
            result.put("FERPass", FERGradeResult.get("FERPass"));

        Double trainingGradeToTeacher = getTrainingGradeToTeacher(classId, tclass.getSupervisorId(), tclass.getTeacherId());
        Map<String, Object> FETGradeResult = getFETGrade(studentsGradeToTeacher, trainingGradeToTeacher, percenetOfFilledReactionEvaluationForms);
        if (FETGradeResult.get("FETGrade") != null)
            result.put("FETGrade", FETGradeResult.get("FETGrade"));
        if (FETGradeResult.get("FETPass") != null)
            result.put("FETPass", FETGradeResult.get("FETPass"));

        return result;
    }

    @Transactional(readOnly = true)
    @Override
    public Double getClassReactionEvaluationGrade(Long classId, Long teacherId) {
        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        calculateStudentsReactionEvaluationResult(classStudents);

        Double studentsGradeToTeacher = null;
        Double studentsGradeToGoals = null;
        Double studentsGradeToFacility = null;
        Double percenetOfFilledReactionEvaluationForms = null;
        Double teacherGradeToClass = getTeacherGradeToClass(classId, teacherId);

        Map<String, Double> reactionEvaluationResult = calculateStudentsReactionEvaluationResult(classStudents);
        if (reactionEvaluationResult.get("studentsGradeToTeacher") != null)
            studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
        if (reactionEvaluationResult.get("studentsGradeToGoals") != null)
            studentsGradeToGoals = (Double) reactionEvaluationResult.get("studentsGradeToGoals");
        if (reactionEvaluationResult.get("studentsGradeToFacility") != null)
            studentsGradeToFacility = (Double) reactionEvaluationResult.get("studentsGradeToFacility");
        percenetOfFilledReactionEvaluationForms = getPercenetOfFilledReactionEvaluationForms(classStudents);

        Map<String, Object> FERGradeResult = getFERGrade(studentsGradeToTeacher,
                studentsGradeToGoals,
                studentsGradeToFacility,
                percenetOfFilledReactionEvaluationForms,
                teacherGradeToClass);
        if (FERGradeResult.get("FERGrade") != null)
            return (Double) FERGradeResult.get("FERGrade");
        else
            return null;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<String, Double> getClassReactionEvaluationFormula(Long classId) {

        Map<String, Double> reactionEvaluationFormulaResult = new HashMap<>();

        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        Double teacherGradeToClass = getTeacherGradeToClass(classId, tclass.getTeacherId());
        Double trainingGradeToTeacher = getTrainingGradeToTeacher(tclass.getId(), tclass.getSupervisorId(), tclass.getTeacherId());
        Map<String, Double> studentReactions = calculateStudentsReactionEvaluationResult(classStudents);

        if (studentReactions.get("studentsGradeToTeacher") != null)
            reactionEvaluationFormulaResult.put("studentsGradeToTeacher", studentReactions.get("studentsGradeToTeacher"));

        if (studentReactions.get("studentsGradeToGoals") != null)
            reactionEvaluationFormulaResult.put("studentsGradeToGoals", studentReactions.get("studentsGradeToGoals"));

        if (studentReactions.get("studentsGradeToFacility") != null)
            reactionEvaluationFormulaResult.put("studentsGradeToFacility", studentReactions.get("studentsGradeToFacility"));

        if (studentReactions.get("evaluatedPercent") != null)
            reactionEvaluationFormulaResult.put("evaluatedPercent", studentReactions.get("evaluatedPercent"));

        if (studentReactions.get("answeredStudentsNum") != null)
            reactionEvaluationFormulaResult.put("answeredStudentsNum", studentReactions.get("answeredStudentsNum"));

        if (studentReactions.get("allStudentsNum") != null)
            reactionEvaluationFormulaResult.put("allStudentsNum", studentReactions.get("allStudentsNum"));

        if (teacherGradeToClass != null)
            reactionEvaluationFormulaResult.put("teacherGradeToClass", teacherGradeToClass);

        if (trainingGradeToTeacher != null)
            reactionEvaluationFormulaResult.put("trainingGradeToTeacher", trainingGradeToTeacher);

        return reactionEvaluationFormulaResult;
    }

    public Double getStudentsGradeToTeacher(Set<ClassStudent> classStudentList) {
        Map<String, Double> result = calculateStudentsReactionEvaluationResult(classStudentList);
        if (result.get("studentsGradeToTeacher") != null)
            return result.get("studentsGradeToTeacher");
        else
            return null;
    }

    @Transactional
    public Map<String, Double> calculateStudentsReactionEvaluationResult(Set<ClassStudent> classStudents) {
        Double studentsGradeToTeacher_l = null;
        Double studentsGradeToFacility_l = null;
        Double studentsGradeToGoals_l = null;
        Integer studentsGradeToTeacher_count = null;
        Integer studentsGradeToFacility_count = null;
        Integer studentsGradeToGoals_count = null;
        Map<String, Double> result = new HashMap<>();
        Double completeNum = 0.0;

        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3) {
                EvaluationDTO.Info evaluationDTO = evaluationService.getEvaluationByData(139L, classStudent.getTclass().getId(), classStudent.getId(), 188L,
                        classStudent.getTclass().getId(), 504L, 154L);
                Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);
                if (evaluation != null) {
                    completeNum ++;
                    int studentsGradeToTeacher_cl = 0;
                    int studentsGradeToFacility_cl = 0;
                    int studentsGradeToGoals_cl = 0;
                    List<EvaluationAnswerDTO.EvaluationAnswerFullData> answers = evaluationService.getEvaluationFormAnswerDetail(evaluation);
                    double teacherTotalGrade = 0.0;
                    double facilityTotalGrade = 0.0;
                    double goalsTotalGrade = 0.0;
                    double teacherTotalWeight = 0.0;
                    double facilityTotalWeight = 0.0;
                    double goalsTotalWeight = 0.0;
                    for (EvaluationAnswerDTO.EvaluationAnswerFullData answer : answers) {
                        if (answer.getAnswerId() != null) {
                            if (answer.getDomainId().equals(54L)) { //studentsToFacilities
                                studentsGradeToFacility_cl = 1;
                                if (answer.getWeight() != null)
                                    facilityTotalWeight += answer.getWeight();
                                else
                                    facilityTotalWeight++;
                                facilityTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue())) * answer.getWeight();
                            } else if (answer.getDomainId().equals(183L)) { //studentsToContent
                                studentsGradeToGoals_cl = 1;
                                if (answer.getWeight() != null)
                                    goalsTotalWeight += answer.getWeight();
                                else
                                    goalsTotalWeight++;
                                goalsTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue())) * answer.getWeight();
                            } else if (answer.getDomainId().equals(53L)) { //studentsToTeacher
                                studentsGradeToTeacher_cl = 1;
                                if (answer.getWeight() != null)
                                    teacherTotalWeight += answer.getWeight();
                                else
                                    teacherTotalWeight++;
                                teacherTotalGrade += (Double.parseDouble(parameterValueDAO.findFirstById(answer.getAnswerId()).getValue())) * answer.getWeight();
                            }
                        }
                    }
                    if (teacherTotalWeight != 0) {
                        if (studentsGradeToTeacher_l == null) studentsGradeToTeacher_l = 0.0;
                        if (studentsGradeToTeacher_count == null) studentsGradeToTeacher_count = 0;
                        studentsGradeToTeacher_l += (teacherTotalGrade / teacherTotalWeight);
                        studentsGradeToTeacher_count += studentsGradeToTeacher_cl;
                    }
                    if (facilityTotalWeight != 0) {
                        if (studentsGradeToFacility_l == null) studentsGradeToFacility_l = 0.0;
                        if (studentsGradeToFacility_count == null) studentsGradeToFacility_count = 0;
                        studentsGradeToFacility_l += (facilityTotalGrade / facilityTotalWeight);
                        studentsGradeToFacility_count += studentsGradeToFacility_cl;
                    }
                    if (goalsTotalWeight != 0) {
                        if (studentsGradeToGoals_l == null) studentsGradeToGoals_l = 0.0;
                        if (studentsGradeToGoals_count == null) studentsGradeToGoals_count = 0;
                        studentsGradeToGoals_l += (goalsTotalGrade / goalsTotalWeight);
                        studentsGradeToGoals_count += studentsGradeToGoals_cl;
                    }

                }
            }
        }
        if (studentsGradeToTeacher_l != null && studentsGradeToTeacher_count != 0)
            studentsGradeToTeacher_l /= studentsGradeToTeacher_count;
        if (studentsGradeToFacility_l != null && studentsGradeToFacility_count != 0)
            studentsGradeToFacility_l /= studentsGradeToFacility_count;
        if (studentsGradeToGoals_l != null && studentsGradeToGoals_count != 0)
            studentsGradeToGoals_l /= studentsGradeToGoals_count;

        result.put("studentsGradeToTeacher", studentsGradeToTeacher_l);
        result.put("studentsGradeToFacility", studentsGradeToFacility_l);
        result.put("studentsGradeToGoals", studentsGradeToGoals_l);
        result.put("evaluatedPercent", (completeNum/Double.valueOf(classStudents.size())) * 100);
        result.put("answeredStudentsNum", Double.valueOf(completeNum));
        result.put("allStudentsNum", Double.valueOf(classStudents.size()));
        return result;
    }

    public Double getTeacherGradeToClass(Long classId, Long teacherId) {
        EvaluationDTO.Info evaluationDTO = evaluationService.getEvaluationByData(140L, classId, teacherId,
                187L, classId, 504L, 154L);
        if (evaluationDTO != null) {
            Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);
            return evaluationService.getEvaluationFormGrade(evaluation);
        } else
            return null;
    }

    public Double getTrainingGradeToTeacher(Long classId, Long trainingId, Long teacherId) {
        EvaluationDTO.Info evaluationDTO = evaluationService.getEvaluationByData(141L, classId, trainingId,
                454L, teacherId, 187L, 154L);
        if (evaluationDTO != null) {
            Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);
            return evaluationService.getEvaluationFormGrade(evaluation);
        } else
            return null;
    }

    private Map<String, Object> getFERGrade(Double studentsGradeToTeacher,
                                            Double studentsGradeToGoals,
                                            Double studentsGradeToFacility,
                                            Double percenetOfFilledReactionEvaluationForms,
                                            Double teacherGradeToClass) {
        Map<String, Object> result = new HashMap<>();
        Boolean FERPass = null;
        Double FERGrade = null;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FER");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        Double z3 = null;
        Double z4 = null;
        Double z5 = null;
        Double z6 = null;
        Double minQus_ER = null;
        Double minScore_ER = null;
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
        if (studentsGradeToTeacher == null && studentsGradeToGoals == null && studentsGradeToFacility == null && teacherGradeToClass == null)
            FERGrade = null;
        else {
            if (studentsGradeToTeacher == null)
                studentsGradeToTeacher = 0.0;
            if (studentsGradeToGoals == null)
                studentsGradeToGoals = 0.0;
            if (studentsGradeToFacility == null)
                studentsGradeToFacility = 0.0;
            if (teacherGradeToClass == null)
                teacherGradeToClass = 0.0;
            FERGrade = z4 * studentsGradeToTeacher + z3 * studentsGradeToGoals +
                    z6 * studentsGradeToFacility + z5 * teacherGradeToClass;
            FERGrade /= 100;
            if (FERGrade >= minScore_ER && percenetOfFilledReactionEvaluationForms >= minQus_ER)
                FERPass = true;
            else
                FERPass = false;
        }

        result.put("FERGrade", FERGrade);
        result.put("FERPass", FERPass);
        result.put("minQus_ER", minQus_ER);
        result.put("minScore_ER", minScore_ER);

        return result;
    }

    private Map<String, Object> getFETGrade(Double studentsGradeToTeacher,
                                            Double trainingGradeToTeacher,
                                            Double percenetOfFilledReactionEvaluationForms) {
        Map<String, Object> result = new HashMap<>();
        Boolean FETPass = null;
        Double FETGrade = null;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FET");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        Double z1 = 0.0;
        Double z2 = 0.0;
        Double minScore_ET = 0.0;
        Double minQus_ET = 0.0;
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z1"))
                z1 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z2"))
                z2 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreET"))
                minScore_ET = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minQusET"))
                minQus_ET = Double.parseDouble(parameterValue.getValue());
        }

        if (studentsGradeToTeacher == null && trainingGradeToTeacher == null)
            FETGrade = null;
        else {
            if (studentsGradeToTeacher == null)
                studentsGradeToTeacher = 0.0;
            if (trainingGradeToTeacher == null)
                trainingGradeToTeacher = 0.0;
            FETGrade = z2 * studentsGradeToTeacher + z1 * trainingGradeToTeacher;
            FETGrade /= 100;
            if (FETGrade >= minScore_ET && percenetOfFilledReactionEvaluationForms >= minQus_ET)
                FETPass = true;
            else
                FETPass = false;
        }

        result.put("FETGrade", FETGrade);
        result.put("FETPass", FETPass);
        result.put("minScore_ET", minScore_ET);
        result.put("minQus_ET", minQus_ET);
        result.put("z1", z1);
        result.put("z2", z2);

        return result;
    }

    private Integer getStudentCount(Set<ClassStudent> classStudents) {
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

    private Integer getNumberOfFilledReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3)
                result++;
        }
        return result;
    }

    private Integer getNumberOfInCompletedReactionEvaluationForms(Set<ClassStudent> classStudents) {
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

    private Integer getNumberOfEmptyReactionEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1 ||
                    Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 0)
                result++;
        }
        return result;
    }

    private Integer getNumberOfExportedEvaluationForms(Set<ClassStudent> classStudents) {
        int result = 0;
        for (ClassStudent classStudent : classStudents) {
            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1)
                result++;
        }
        return result;
    }

    private Double getPercenetOfFilledReactionEvaluationForms(Set<ClassStudent> classStudents) {
        double r1 = getNumberOfFilledReactionEvaluationForms(classStudents);
        double r2 = getNumberOfFilledReactionEvaluationForms(classStudents) + (double) getNumberOfEmptyReactionEvaluationForms(classStudents);
    if (r2!=0.0)
        return (r1 / r2) * 100;
    else
        return null;
    }

    ///---------------------------------------------- Reaction Evaluation ----------------------------------------------

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
                        (classInfo[14] != null ? classInfo[14].toString() : null),
                        (classInfo[15] != null ? classInfo[15].toString() : null)));
            }
        }

        return (personnelClassInfo != null ? modelMapper.map(personnelClassInfo, new TypeToken<List<TclassDTO.PersonnelClassInfo>>() {
        }.getType()) : null);

    }

    @Transactional(readOnly = true)
    @Override
    public List<TclassDTO.PersonnelClassInfo> findPersonnelClassByCourseId(String national_code, String personnel_no, Long courseId) {

        List<TclassDTO.PersonnelClassInfo> personnelClassInfo = null;

        List<?> personnelClassInfoList = tclassDAO.findPersonnelClassByCourseId(national_code, personnel_no, courseId);

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
                        null,
                        (classInfo[7] != null ? Long.parseLong(classInfo[7].toString()) : null),
                        (classInfo[8] != null ? classInfo[8].toString() : null),
                        null,
                        null,
                        null,
                        (classInfo[9] != null ? Long.parseLong(classInfo[9].toString()) : null),
                        (classInfo[10] != null ? classInfo[10].toString() : null),
                        null
                        ));
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
            Double studentsGradeToTeacher = null;
            if (reactionEvaluationResult.get("studentsGradeToTeacher") != null)
                studentsGradeToTeacher = (Double) reactionEvaluationResult.get("studentsGradeToTeacher");
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
    public Boolean hasSessions(Long id) {
        return classSessionDAO.existsByClassId(id);
    }


    @Transactional
    @Override
    public void updateCostInfo(Long id, TclassDTO.Update request) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        tclass.setStudentCost(request.getStudentCost());
        tclass.setStudentCostCurrency(request.getStudentCostCurrency());

        Tclass updatedClass = tclassDAO.save(tclass);
    }

    @Transactional
    @Override
    public Map<String, Object> calculateEffectivenessEvaluation(String reactionGrade_s, String learningGrade_s, String behavioralGrade_s, String classEvaluation) {
        Double effectivenessGrade = 0.0;
        Boolean effectivenessPass = false;
        Map<String, Object> finalResult = new HashMap<>();

        double reactionGrade = 0.0;
        double learningGrade = 0.0;
        double behavioralGrade = 0.0;

        if (reactionGrade_s != null)
            reactionGrade = Double.parseDouble(reactionGrade_s);
        if (learningGrade_s != null)
            learningGrade = Double.parseDouble(learningGrade_s);
        if (behavioralGrade_s != null)
            behavioralGrade = Double.parseDouble(behavioralGrade_s);

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEC_R");
        double minScoreFECR = 0.0;
        double FECRZ = 0.0;
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("FECRZ"))
                FECRZ = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                minScoreFECR = Double.parseDouble(parameterValue.getValue());
        }

        if (classEvaluation != null && classEvaluation.equalsIgnoreCase("1")) {
            effectivenessGrade = (reactionGrade * FECRZ) / 100;
        } else if (classEvaluation != null && classEvaluation.equalsIgnoreCase("2")) {
            double FECLZ1 = 0.0;
            double FECLZ2 = 0.0;
            TotalResponse<ParameterValueDTO.Info> parameters1 = parameterService.getByCode("FEC_L");
            List<ParameterValueDTO.Info> parameterValues1 = parameters1.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues1) {
                if (parameterValue.getCode().equalsIgnoreCase("FECLZ1"))
                    FECLZ1 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECLZ2"))
                    FECLZ2 = Double.parseDouble(parameterValue.getValue());
            }
            effectivenessGrade = (reactionGrade * FECLZ1 + learningGrade * FECLZ2) / 100;
        } else if (classEvaluation != null && (classEvaluation.equalsIgnoreCase("3") || classEvaluation.equalsIgnoreCase("4"))) {
            Double FECBZ1 = 0.0;
            Double FECBZ2 = 0.0;
            Double FECBZ3 = 0.0;
            TotalResponse<ParameterValueDTO.Info> parameters2 = parameterService.getByCode("FEC_B");
            List<ParameterValueDTO.Info> parameterValues2 = parameters2.getResponse().getData();
            for (ParameterValueDTO.Info parameterValue : parameterValues2) {
                if (parameterValue.getCode().equalsIgnoreCase("FECBZ1"))
                    FECBZ1 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECBZ2"))
                    FECBZ2 = Double.parseDouble(parameterValue.getValue());
                else if (parameterValue.getCode().equalsIgnoreCase("FECBZ3"))
                    FECBZ3 = Double.parseDouble(parameterValue.getValue());
            }

            effectivenessGrade = (reactionGrade * FECBZ1 + learningGrade * FECBZ2 + behavioralGrade * FECBZ3) / 100;
        }

        if (effectivenessGrade >= minScoreFECR)
            effectivenessPass = true;
        else
            effectivenessPass = false;

        if (effectivenessGrade != 0 && effectivenessGrade != 0.0) {
            finalResult.put("EffectivenessGrade", effectivenessGrade);
            finalResult.put("EffectivenessPass", effectivenessPass);
            finalResult.put("minScoreFECR", minScoreFECR);
        }
        return finalResult;
    }

    @Override
    public Map<Long, Integer> checkClassesForSendMessage(List<Long> classIds) {
        List<Object> list = tclassDAO.checkClassesForSendMessage(classIds);

        Map<Long, Integer> result = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            Object[] arr = (Object[]) list.get(i);
            result.put(arr[0] == null ? null : Long.parseLong(arr[0].toString()), Integer.parseInt(arr[1].toString()));
        }

        return result;
    }

    @Transactional
    @Override
    public EvaluationAnswerObject classTeacherEvaluations(TeacherEvaluationAnswerDto dto) {
        final Optional<Tclass> optionalTclass = tclassDAO.findById(dto.getClassId());
        final Tclass tclass = optionalTclass.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        final Optional<Evaluation> optionalEvaluation = evaluationDAO.findTopByClassIdAndQuestionnaireTypeId(tclass.getId(), 140L);
        final Evaluation evaluation = optionalEvaluation.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        EvaluationAnswerObject evaluationAnswerObject = new EvaluationAnswerObject();
        evaluationAnswerObject.setClassId(dto.getClassId());
        evaluationAnswerObject.setId(evaluation.getId());
        evaluationAnswerObject.setEvaluatedId(evaluation.getEvaluatedId());
        evaluationAnswerObject.setEvaluatedTypeId(evaluation.getEvaluatedTypeId());
        evaluationAnswerObject.setEvaluationLevelId(evaluation.getEvaluationLevelId());
        evaluationAnswerObject.setQuestionnaireTypeId(evaluation.getQuestionnaireTypeId());
        evaluationAnswerObject.setQuestionnaireId(evaluation.getQuestionnaireId());
        evaluationAnswerObject.setEvaluatorId(evaluation.getEvaluatorId());
        evaluationAnswerObject.setEvaluatorTypeId(evaluation.getEvaluatorTypeId());

        List<EvaluationAnswer> evaluationAnswers;
        List<TeacherEvaluationAnswer> EvaluationAnswerList = new ArrayList<>();
        evaluationAnswers = evaluationAnswerService.getAllByEvaluationId(evaluation.getId());
        for (EvaluationAnswer evaluationAnswer : evaluationAnswers) {
            TeacherEvaluationAnswer teacherEvaluationAnswer = new TeacherEvaluationAnswer();
            teacherEvaluationAnswer.setId(evaluationAnswer.getId().toString());
            Optional<QuestionnaireQuestion> questionnaireQuestionOptional = questionnaireQuestionDAO.findById(evaluationAnswer.getEvaluationQuestionId());
            final QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            Optional<EvaluationQuestion> evaluationQuestionOptional = evaluationQuestionDAO.findById(questionnaireQuestion.getEvaluationQuestionId());
            final EvaluationQuestion question = evaluationQuestionOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            if (dto.getEvaluationAnswerList() != null) {
                TeacherEvaluationAnswerList answer = dto.getEvaluationAnswerList().stream()
                        .filter(x -> x.getQuestion().trim().equals(question.getQuestion().trim()))
                        .findFirst()
                        .orElse(null);
                if (answer != null) {
                    switch (answer.getAnswer()) {
                        case "عالی":
                            teacherEvaluationAnswer.setAnswerID("205");
                            break;
                        case "خوب":
                            teacherEvaluationAnswer.setAnswerID("206");
                            break;
                        case "متوسط":
                            teacherEvaluationAnswer.setAnswerID("207");
                            break;
                        case "ضعیف":
                            teacherEvaluationAnswer.setAnswerID("208");
                            break;
                        case "خیلی ضعیف":
                            teacherEvaluationAnswer.setAnswerID("209");
                            break;
                    }

                    EvaluationAnswerList.add(teacherEvaluationAnswer);
                }
            }

        }
        if (dto.getEvaluationAnswerList() != null)
            evaluationAnswerObject.setEvaluationFull(evaluationAnswers.size() == dto.getEvaluationAnswerList().size());
        evaluationAnswerObject.setEvaluationAnswerList(EvaluationAnswerList);
        if (dto.getDescription() != null && !dto.getDescription().isEmpty() && dto.getDescription().trim().length() > 0)
            evaluationAnswerObject.setDescription(dto.getDescription());
        evaluationAnswerObject.setSendDate(DateUtil.todayDate());
        return evaluationAnswerObject;
    }

    @Transactional
    @Override
    public EvaluationAnswerObject classStudentEvaluations(StudentEvaluationAnswerDto dto) {
        final Optional<Tclass> optionalTclass = tclassDAO.findById(dto.getClassId());
        final Tclass tclass = optionalTclass.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<Evaluation> optionalEvaluation = evaluationDAO.findAllByClassIdAndQuestionnaireTypeId(tclass.getId(), 139L);
        Long userId = studentDAO.findOneByNationalCode(dto.getNationalCode(), dto.getClassId());

        Evaluation evaluation = optionalEvaluation.stream()
                .filter(x -> x.getEvaluatorId().equals(userId))
                .findFirst()
                .orElse(null);

        EvaluationAnswerObject evaluationAnswerObject = new EvaluationAnswerObject();
        evaluationAnswerObject.setClassId(dto.getClassId());
        evaluationAnswerObject.setId(evaluation.getId());
        evaluationAnswerObject.setEvaluatedId(evaluation.getEvaluatedId());
        evaluationAnswerObject.setEvaluatedTypeId(evaluation.getEvaluatedTypeId());
        evaluationAnswerObject.setEvaluationLevelId(evaluation.getEvaluationLevelId());
        evaluationAnswerObject.setQuestionnaireTypeId(evaluation.getQuestionnaireTypeId());
        evaluationAnswerObject.setQuestionnaireId(evaluation.getQuestionnaireId());
        evaluationAnswerObject.setEvaluatorId(userId);
        evaluationAnswerObject.setEvaluatorTypeId(188L);

        List<EvaluationAnswer> evaluationAnswers;
        List<TeacherEvaluationAnswer> EvaluationAnswerList = new ArrayList<>();
        evaluationAnswers = evaluationAnswerService.getAllByEvaluationId(evaluation.getId());
        for (EvaluationAnswer evaluationAnswer : evaluationAnswers) {
            TeacherEvaluationAnswer teacherEvaluationAnswer = new TeacherEvaluationAnswer();
            teacherEvaluationAnswer.setId(evaluationAnswer.getId().toString());
            Optional<QuestionnaireQuestion> questionnaireQuestionOptional = questionnaireQuestionDAO.findById(evaluationAnswer.getEvaluationQuestionId());
            final QuestionnaireQuestion questionnaireQuestion;
            if (questionnaireQuestionOptional.isPresent()) {
                questionnaireQuestion = questionnaireQuestionOptional.get();

                Optional<EvaluationQuestion> evaluationQuestionOptional = evaluationQuestionDAO.findById(questionnaireQuestion.getEvaluationQuestionId());
                final EvaluationQuestion question = evaluationQuestionOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));


                TeacherEvaluationAnswerList answer = dto.getEvaluationAnswerList().stream()
                        .filter(x -> x.getQuestion().trim().equals(question.getQuestion().trim()))
                        .findFirst()
                        .orElse(null);
                if (answer != null) {
                    switch (answer.getAnswer()) {
                        case "عالی":
                            teacherEvaluationAnswer.setAnswerID("205");
                            break;
                        case "خوب":
                            teacherEvaluationAnswer.setAnswerID("206");
                            break;
                        case "متوسط":
                            teacherEvaluationAnswer.setAnswerID("207");
                            break;
                        case "ضعیف":
                            teacherEvaluationAnswer.setAnswerID("208");
                            break;
                        case "خیلی ضعیف":
                            teacherEvaluationAnswer.setAnswerID("209");
                            break;
                    }

                    EvaluationAnswerList.add(teacherEvaluationAnswer);
                }
            } else {
                Optional<DynamicQuestion> dynamicQuestion = dynamicQuestionDAO.findById(evaluationAnswer.getEvaluationQuestionId());
                TeacherEvaluationAnswerList answer = dto.getEvaluationAnswerList().stream()
                        .filter(x -> x.getQuestion().trim().equals(dynamicQuestion.get().getQuestion().trim()))
                        .findFirst()
                        .orElse(null);
                if (answer != null) {
                    switch (answer.getAnswer()) {
                        case "عالی":
                            teacherEvaluationAnswer.setAnswerID("205");
                            break;
                        case "خوب":
                            teacherEvaluationAnswer.setAnswerID("206");
                            break;
                        case "متوسط":
                            teacherEvaluationAnswer.setAnswerID("207");
                            break;
                        case "ضعیف":
                            teacherEvaluationAnswer.setAnswerID("208");
                            break;
                        case "خیلی ضعیف":
                            teacherEvaluationAnswer.setAnswerID("209");
                            break;
                    }

                    EvaluationAnswerList.add(teacherEvaluationAnswer);
                }
            }

        }
        evaluationAnswerObject.setEvaluationFull(evaluationAnswers.size() == dto.getEvaluationAnswerList().size());
        evaluationAnswerObject.setEvaluationAnswerList(EvaluationAnswerList);
        evaluationAnswerObject.setStatus(true);
        if (dto.getDescription() != null && !dto.getDescription().isEmpty() && dto.getDescription().trim().length() > 0)
            evaluationAnswerObject.setDescription(dto.getDescription());
        evaluationAnswerObject.setSendDate(DateUtil.todayDate());
        return evaluationAnswerObject;
    }

    @Override
    public Boolean hasAccessToChangeClassStatus( String groupIds) {
        List<String> ids = Arrays.stream(groupIds.split( "," )).collect(Collectors.toList());;
        return workGroupService.hasAccess(SecurityUtil.getUserId(),ids);
    }
    @Override
    public Map<String,Boolean> hasAccessToGroups( String groupIds) {
        List<String> ids = Arrays.stream(groupIds.split( "," )).collect(Collectors.toList());;
        return workGroupService.hasAccessToGroups(SecurityUtil.getUserId(),ids);
    }

    @Override
    public String getClassDefaultYear() {

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        ParameterValueDTO.Info info = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("defaultYear")).findFirst().orElse(null);
        if (info != null) {
            List<Term> termByYear = termDAO.getTermByYear(info.getValue());
            if (termByYear.size() != 0) return info.getValue();
            else throw new TrainingException(TrainingException.ErrorType.NotFound);
        } else throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    public Long getClassDefaultTerm(String year) {
        year = MyUtils.convertToEnglishDigits(year);
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        ParameterValueDTO.Info termParameter = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("defaultTerm")).findFirst().orElse(null);
        if (termParameter != null) {
        String value = MyUtils.convertToEnglishDigits(termParameter.getValue());;
            Term termByCode = termDAO.getTermByCode(value);
            if (termByCode != null) {
                if (termByCode.getCode().startsWith(year)) return termByCode.getId();
                else throw new TrainingException(TrainingException.ErrorType.InvalidData);
            } else throw new TrainingException(TrainingException.ErrorType.NotFound);
        } else throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    public List<String> getClassDefaultTermScope() {

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");

        List<String> termScope = new ArrayList<>();
        ParameterValueDTO.Info from = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("from")).findFirst().orElse(null);
        ParameterValueDTO.Info to = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("to")).findFirst().orElse(null);

        if (from != null && to != null) {
            Term fromTerm = termDAO.getTermByCode(from.getValue());
            Term toTerm = termDAO.getTermByCode(to.getValue());
            if (fromTerm != null && toTerm != null) {

                termScope.add(fromTerm.getCode());
                termScope.add(toTerm.getCode());
                return termScope;
            }
            else throw new TrainingException(TrainingException.ErrorType.NotFound);
        } else throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    public boolean isValidForExam(long id) {
        final Optional<Tclass> optionalTclass = tclassDAO.findById(id);
        if (optionalTclass.isPresent())
        {
            Tclass tclass=optionalTclass.get();
            return tclass.getScoringMethod() != null &&
                    (tclass.getScoringMethod().equals("2") || tclass.getScoringMethod().equals("3")) ;
        }
        else
        return false;
    }

    @Override
    @Transactional
    public BaseResponse changeClassStatusToInProcess(Long classId) {

        BaseResponse response=new BaseResponse();
        Optional<Tclass> optionalTClass = tclassDAO.findById(classId);

        if (optionalTClass.isPresent()) {
            Tclass tclass=optionalTClass.get();
            tclass.setClassStatus(ClassStatus.inProcess.getId().toString());
            tclassDAO.save(tclass);
            response.setStatus(200);
            return response;
        } else {

            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            return response;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public EvalAverageResult getEvaluationAverageResultToTeacher(Long classId) {
        Tclass tclass = getTClass(classId);
        Set<ClassStudent> classStudents = tclass.getClassStudents();
        EvalAverageResult studentsAverageGradeToTeacher = getStudentsAverageGradeToTeacher(classStudents);
        return studentsAverageGradeToTeacher;
    }

    @Transactional
    public EvalAverageResult getStudentsAverageGradeToTeacher(Set<ClassStudent> classStudents) {

        Map<String, Double> answeredStudentsNo = new HashMap<>();
        Map<String, Double> questionsAverageGrade = new HashMap<>();
        Integer answered = 0;

        for (ClassStudent classStudent : classStudents) {

            if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 3) {
                EvaluationDTO.Info evaluationDTO = evaluationService.getEvaluationByData(139L, classStudent.getTclass().getId(), classStudent.getId(), 188L,
                        classStudent.getTclass().getId(), 504L, 154L);
                Evaluation evaluation = modelMapper.map(evaluationDTO, Evaluation.class);


                if (evaluation != null) {
                    answered ++;
                    List<EvaluationAnswerDTO.EvaluationAnswerFullData> answers = evaluationService.getEvaluationFormAnswerDetail(evaluation);

                    for (EvaluationAnswerDTO.EvaluationAnswerFullData answer : answers) {
                        if (!questionsAverageGrade.containsKey(answer.getQuestion()) && answer.getDomainId().equals(53L)) {
                            questionsAverageGrade.put(answer.getQuestion(), 0.0);
                        }
                    }

                    for (EvaluationAnswerDTO.EvaluationAnswerFullData answer : answers) {

                        //studentsGradeToTeacher
                        if (answer.getAnswerId() != null && answer.getDomainId().equals(53L)) {

                            if(!answeredStudentsNo.containsKey(answer.getQuestion()))
                                answeredStudentsNo.put(answer.getQuestion(), 1.0);
                            else {
                                Double aDouble = answeredStudentsNo.get(answer.getQuestion());
                                answeredStudentsNo.put(answer.getQuestion(), aDouble+1);
                            }

                            String answerValue = parameterValueDAO.findFirstById(answer.getAnswerId()).getValue();
                            Double ansGrade = questionsAverageGrade.get(answer.getQuestion());
                            ansGrade += (Double.parseDouble(answerValue)) * answer.getWeight();
                            questionsAverageGrade.put(answer.getQuestion(), ansGrade);
                        }
                    }
                }
            }
        }

        EvalAverageResult evalAverageResult = new EvalAverageResult();
        List<AveragePerQuestion> averagePerQuestions = new ArrayList<>();
        Double totalAverage = 0.0;

        for (Map.Entry<String, Double> entry : questionsAverageGrade.entrySet()) {
            for (Map.Entry<String, Double> entryAnswered : answeredStudentsNo.entrySet()) {

                if (entry.getKey().equals(entryAnswered.getKey())) {
                    averagePerQuestions.add(new AveragePerQuestion(entry.getKey(), entry.getValue()/entryAnswered.getValue()));
                    totalAverage += entry.getValue()/entryAnswered.getValue();
                }
            }
        }

        evalAverageResult.setLimitScore(100L);
        evalAverageResult.setAllStudentsNo(classStudents.size());
        evalAverageResult.setAnsweredStudentsNo(answered);
        evalAverageResult.setAveragePerQuestionList(averagePerQuestions);
        if (averagePerQuestions.size() != 0)
            evalAverageResult.setTotalAverage(totalAverage / averagePerQuestions.size());
        else
            evalAverageResult.setTotalAverage(0.0);
        return evalAverageResult;
    }

    @Override
    @Transactional
    public Tclass getClassByCode(String classCode) {

        return tclassDAO.findByCode(classCode);
    }

    @Override
    @Transactional
    public ElsSessionResponse getClassSessionsByCode(String classCode) {

        Tclass tclass = getClassByCode(classCode);
        if (tclass != null)
            return sessionBeanMapper.toGetElsSessionResponse(tclass);
        else
            throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    public List<TClassAudit> getAuditData(long i) {
        return tclassAuditDAO.getAuditData(i);
    }


    @Override
    @Transactional
    public void changeClassToOnlineStatus(Long classId, boolean state) {
        tclassDAO.changeClassToOnlineStatus(classId, state);
    }

    @Override
    @Transactional
    public TclassDTO.TClassScoreEval getTClassDataForScoresInEval(String classCode) {
        Tclass tclass = tclassDAO.findByCode(classCode);
        return modelMapper.map(tclass, TclassDTO.TClassScoreEval.class);
    }

    @Override
    public boolean getScoreDependency() {

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        ParameterValueDTO.Info info = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("scoreDependsOnEvaluation")).findFirst().orElse(null);
        if (info != null) {
            switch (info.getValue()) {
                case "بله":
                    return true;
                case "خیر":
                    return false;
                default:
                    return true;
            }
        } else throw new TrainingException(TrainingException.ErrorType.NotFound);
    }
}
