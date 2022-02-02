package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import dto.evaluuation.EvalElsData;
import dto.evaluuation.EvalQuestionDto;
import dto.evaluuation.EvalQuestionOptional;
import dto.evaluuation.EvalQuestionType;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluationService {

    private final ModelMapper modelMapper;
    private final EvaluationDAO evaluationDAO;
    private final ClassStudentDAO classStudentDAO;
    private final ParameterService parameterService;
    private final QuestionnaireDAO questionnaireDAO;
    private final TclassDAO tclassDAO;
    private final TeacherDAO teacherDAO;
    private final DynamicQuestionService dynamicQuestionService;
    private final DynamicQuestionDAO dynamicQuestionDAO;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final ParameterValueDAO parameterValueDAO;
    private final ClassEvaluationGoalsDAO classEvaluationGoalsDAO;
    private final EvaluationAnswerDAO evaluationAnswerDAO;
    private final EvaluationQuestionDAO evaluationQuestionDAO;


    @Transactional(readOnly = true)
    @Override
    public EvaluationDTO.Info get(Long id) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));
        return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EvaluationDTO.Info> list() {
        final List<Evaluation> sAll = evaluationDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<EvaluationDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EvaluationDTO.Info create(EvaluationDTO.Create request) {
        return save(modelMapper.map(request, Evaluation.class));
    }



    @Transactional
    @Override
    public EvaluationDTO.Info update(Long id, EvaluationDTO.Update request) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));

        evaluation.setDescription(request.getDescription());
        evaluation.setStatus(request.getStatus());
        evaluation.setEvaluationFull(request.getEvaluationFull());

        for (EvaluationAnswerDTO.Update evaluationAnswer : request.getEvaluationAnswerList()) {
            final Optional<EvaluationAnswer> aById = evaluationAnswerDAO.findById(evaluationAnswer.getId());
            EvaluationAnswer evaluationAnswerDAO = aById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            evaluationAnswerDAO.setAnswerId(evaluationAnswer.getAnswerId());
        }

        if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(139L)) {
            if (evaluation.getEvaluationFull())
                updateClassStudentInfo(evaluation, 2);
            else if (!evaluation.getEvaluationFull())
                updateClassStudentInfo(evaluation, 3);
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(141L)) {
            if (evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(), 2, -1);
            else if (!evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(), 3, -1);
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(140L)) {
            if (evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(), -1, 2);
            else if (!evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(), -1, 3);
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(230L)) {
            updateClassStudentInfo(evaluation, 2);
        }

        return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        evaluationDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(EvaluationDTO.Delete request) {
        final List<Evaluation> sAllById = evaluationDAO.findAllById(request.getIds());

        evaluationDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EvaluationDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(evaluationDAO, request, evaluation -> modelMapper.map(evaluation, EvaluationDTO.Info.class));
    }

    @Transactional
    public EvaluationDTO.Info save(Evaluation evaluation) {
        final Evaluation saved = evaluationDAO.saveAndFlush(evaluation);
        if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(139L)) {
            updateClassStudentInfo(saved, 1);
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(141L)) {
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
            updateTclassInfo(evaluation.getClassId(), 1, -1);
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(140L)) {
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
            updateTclassInfo(evaluation.getClassId(), -1, 1);
        } else if (evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(230L)) {
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateClassStudentInfo(saved, 1);
        }
        return modelMapper.map(saved, EvaluationDTO.Info.class);
    }

    @Override
    public Evaluation getStudentEvaluationForClass(Long classId, Long studentId) {
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("32"))
                evaluatorTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId, studentId, evaluatorTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getTeacherEvaluationForClass(Long teacherId, Long classId) {
        Long evaluatorTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("11"))
                evaluatorTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(
                classId, teacherId, evaluatorTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getTrainingEvaluationForTeacher(Long teacherId, Long classId, Long trainingId) {
        Long evaluatorTypeId = null;
        Long evaluatedTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("4"))
                evaluatorTypeId = parameterValue.getId();
            if (parameterValue.getCode().equalsIgnoreCase("11"))
                evaluatedTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(
                classId, trainingId, evaluatorTypeId, teacherId, evaluatedTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getTrainingEvaluationForTeacherCustomized(Long teacherId, Long classId) {
        Long evaluatorTypeId = null;
        Long evaluatedTypeId = null;
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("EvaluatorType");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("4"))
                evaluatorTypeId = parameterValue.getId();
            if (parameterValue.getCode().equalsIgnoreCase("11"))
                evaluatedTypeId = parameterValue.getId();
        }
        List<Evaluation> evaluations = evaluationDAO.findEvaluationByClassIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(
                classId, evaluatorTypeId, teacherId, evaluatedTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Override
    public Evaluation getBehavioralEvaluationByStudent(Long studentId, Long classId) {
        Long evaluationLevelId = Long.parseLong(156 + "");
        Long questionnaireTypeId = Long.parseLong(139 + "");
        Long evaluatorTypeId = Long.parseLong(188 + "");
        Long evaluatorId = studentId;
        List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluatorTypeIdAndEvaluatorIdAndEvaluationLevelIdAndQuestionnaireTypeId
                (classId,
                        evaluatorTypeId,
                        evaluatorId,
                        evaluationLevelId,
                        questionnaireTypeId);
        if (evaluations.size() != 0)
            return evaluations.get(0);
        else
            return null;
    }

    @Transactional
    @Override
    public EvaluationDTO.Info getEvaluationByData(Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId, Long evaluatedTypeId, Long evaluationLevelId) {
        final Evaluation evaluation = evaluationDAO.findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(questionnaireTypeId, classId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);
        if (evaluation == null)
            return null;
        else
            return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    @Transactional
    @Override
    public List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationForm(@RequestBody HashMap req) {

        EvaluationDTO.Info evaluation = getEvaluationByData(Long.parseLong(req.get("questionnaireTypeId").toString()),
                Long.parseLong(req.get("classId").toString()),
                Long.parseLong(req.get("evaluatorId").toString()),
                Long.parseLong(req.get("evaluatorTypeId").toString()),
                Long.parseLong(req.get("evaluatedId").toString()),
                Long.parseLong(req.get("evaluatedTypeId").toString()),
                Long.parseLong(req.get("evaluationLevelId").toString()));

        if (evaluation != null) {
            List<EvaluationAnswerDTO.EvaluationAnswerFullData> result = new ArrayList<>();

            for (EvaluationAnswerDTO.Info evaluationAnswerDTO : evaluation.getEvaluationAnswerList()) {
                EvaluationAnswerDTO.EvaluationAnswerFullData evaluationAnswerFullData = new EvaluationAnswerDTO.EvaluationAnswerFullData();
                evaluationAnswerFullData.setId(evaluationAnswerDTO.getId());
                evaluationAnswerFullData.setEvaluationId(evaluationAnswerDTO.getEvaluationId());
                evaluationAnswerFullData.setEvaluationQuestionId(evaluationAnswerDTO.getEvaluationQuestionId());
                evaluationAnswerFullData.setQuestionSourceId(evaluationAnswerDTO.getQuestionSourceId());
                evaluationAnswerFullData.setAnswerId(evaluationAnswerDTO.getAnswerId());
                evaluationAnswerFullData.setDescription(evaluation.getDescription());

                if (evaluationAnswerFullData.getQuestionSourceId().equals(199L)) {
                    QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getById(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setOrder(questionnaireQuestion.getOrder());
                    evaluationAnswerFullData.setWeight(questionnaireQuestion.getWeight());
                    evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                    evaluationAnswerFullData.setDomainId(questionnaireQuestion.getEvaluationQuestion().getDomainId());
                } else if (evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)) {
                    DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getById(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setOrder(dynamicQuestion.getOrder());
                    evaluationAnswerFullData.setWeight(dynamicQuestion.getWeight());
                    evaluationAnswerFullData.setQuestion(dynamicQuestion.getQuestion());
                }

                result.add(evaluationAnswerFullData);
            }
            Comparator<EvaluationAnswerDTO.EvaluationAnswerFullData> compareByOrder = (EvaluationAnswerDTO.EvaluationAnswerFullData o1, EvaluationAnswerDTO.EvaluationAnswerFullData o2) ->
                    o1.getOrder().compareTo(o2.getOrder());
            Collections.sort(result, compareByOrder);
            return result;
        } else
            return null;

    }

    @Override
    public List<Evaluation> getEvaluationsByEvaluatorNationalCode(String evaluatorNationalCode, Long EvaluatorTypeId, String evaluatorType) {
        if (evaluatorType.equals("teacher")) {
            List<Evaluation> list= evaluationDAO.getTeacherEvaluationsWithEvaluatorNationalCodeAndEvaluatorList(evaluatorNationalCode, EvaluatorTypeId);
            List<Evaluation> notAnsweredEvaluations=new ArrayList<>();
            for (Evaluation evaluation:list){
                List<EvaluationAnswer> answers=evaluationAnswerDAO.findByEvaluationIdAndAnswerId(evaluation.getId());
                if (answers.isEmpty())
                    notAnsweredEvaluations.add(evaluation);
            }
            return notAnsweredEvaluations;
        } else if (evaluatorType.equals("student")) {
            return evaluationDAO.getStudentEvaluationsWithEvaluatorNationalCodeAndEvaluatorList(evaluatorNationalCode, EvaluatorTypeId);
        } else {
            return null;
        }
    }

    @Transactional
    @Override
    public Boolean deleteEvaluation(HashMap req) {
        EvaluationDTO.Info evaluation = getEvaluationByReq(req);
        if (evaluation != null) {
            evaluationDAO.deleteById(evaluation.getId());

            if (req.get("questionnaireTypeId").toString().equals("139"))
                updateClassStudentInfo(modelMapper.map(evaluation, Evaluation.class), 0);
            else if (req.get("questionnaireTypeId").toString().equals("141"))
                updateTclassInfo(Long.parseLong(req.get("classId").toString()), 0, -1);
            else if (req.get("questionnaireTypeId").toString().equals("140"))
                updateTclassInfo(Long.parseLong(req.get("classId").toString()), -1, 0);
            else if (req.get("questionnaireTypeId").toString().equals("230"))
                updateClassStudentInfo(modelMapper.map(evaluation, Evaluation.class), 0);
            if (evaluation.getQuestionnaireId() != null)
                updateQuestionnarieInfo(evaluation.getQuestionnaireId());
            return true;
        } else
            return false;
    }

    @Transactional
    @Override
    public void deleteAllReactionEvaluationForms(Long classId) {
        List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(classId, 154L, 139L);
        for (Evaluation evaluation : evaluations) {
            updateClassStudentInfo(modelMapper.map(evaluation, Evaluation.class), 0);
        }
        evaluationDAO.deleteAll(evaluations);
    }

    @Transactional
    @Override
    public List<Long> getAllReactionEvaluationForms(Long classId) {
        List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(classId, 154L, 139L);

        return evaluations.parallelStream()
                .map(Evaluation::getId).collect(Collectors.toList());
    }

    public List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long ClassId, Long EvaluationLevelId, Long QuestionnaireTypeId){
        return evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId( ClassId, EvaluationLevelId, QuestionnaireTypeId);
    }

    //----------------------------------------------- evaluation updating ----------------------------------------------
    public void updateTclassInfo(Long classID, Integer reactionTrainingStatus, Integer reactionTeacherStatus) {
        Optional<Tclass> byId = tclassDAO.findById(classID);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if (reactionTeacherStatus.equals(-1))
            tclass.setEvaluationStatusReactionTraining(reactionTrainingStatus);
        else if (reactionTrainingStatus.equals(-1))
            tclass.setEvaluationStatusReactionTeacher(reactionTeacherStatus);
    }

    @Transactional
    public void updateClassStudentInfo(Evaluation evaluation, Integer version) {
        if (evaluation.getQuestionnaireTypeId().equals(139L)) {
            Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatorId());
            if (byId.isPresent()) {
                ClassStudent classStudent = byId.get();
                classStudent.setEvaluationStatusReaction(version);
            }
        } else if (evaluation.getQuestionnaireTypeId().equals(230L)) {
            Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatedId());
            if (byId.isPresent()) {
                ClassStudent classStudent = byId.get();
                List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                        evaluation.getClassId(), evaluation.getEvaluatedId(), 188L, 156L, 230L);
                classStudent.setNumberOfSendedBehavioralForms(0);
                classStudent.setNumberOfRegisteredBehavioralForms(0);
                for (Evaluation evaluation1 : evaluations) {
                    if (!evaluation1.getStatus())
                        classStudent.setNumberOfSendedBehavioralForms(classStudent.getNumberOfSendedBehavioralForms() + 1);
                    else if (evaluation1.getStatus()) {
                        classStudent.setNumberOfSendedBehavioralForms(classStudent.getNumberOfSendedBehavioralForms() + 1);
                        classStudent.setNumberOfRegisteredBehavioralForms(classStudent.getNumberOfRegisteredBehavioralForms() + 1);
                    }
                }

            }
        }
    }

    public void updateQuestionnarieInfo(Long questionnarieId) {
        Evaluation evaluation = evaluationDAO.findFirstByQuestionnaireId(questionnarieId);
        Questionnaire questionnaire = questionnaireDAO.findFirstById(questionnarieId);
        if (questionnaire==null)
      throw  new TrainingException(TrainingException.ErrorType.NotFound);
        questionnaire.setLockStatus(evaluation != null);
    }

    public List<EvaluationAnswer> createEvaluationAnswers(Evaluation evaluation) {
        List<EvaluationAnswer> evaluationAnswers = new ArrayList<>();
        if (evaluation.getQuestionnaireTypeId().equals(139L)) {
            Optional<Tclass> byId = tclassDAO.findById(evaluation.getClassId());
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            List<ClassEvaluationGoals> editedGoalList = classEvaluationGoalsDAO.findByClassId(tclass.getId());
            if (editedGoalList != null && editedGoalList.size() != 0) {
                for (ClassEvaluationGoals classEvaluationGoals : editedGoalList) {
                    Long type = null;
                    String Question = null;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    if (classEvaluationGoals.getGoalId() != null)
                        type = 201L;
                    if (classEvaluationGoals.getSkillId() != null)
                        type = 200L;
                    Question = classEvaluationGoals.getQuestion();
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, classEvaluationGoals.getGoalId(), classEvaluationGoals.getSkillId());
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(0);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setGoalId(classEvaluationGoals.getGoalId());
                        dynamicQuestionCreate.setSkillId(classEvaluationGoals.getSkillId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }
            } else {
                for (Goal goal : tclass.getCourse().getGoalSet()) {
                    String Question = null;
                    Question = goal.getTitleFa();
                    Long type = 201L;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, goal.getId(), null);
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(0);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setGoalId(goal.getId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }

                for (Skill skill : tclass.getCourse().getSkillSet()) {
                    String Question = null;
                    Question = skill.getTitleFa();
                    Long type = 200L;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, null, skill.getId());
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(-1);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setSkillId(skill.getId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }
            }

            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
            }
        } else if (evaluation.getQuestionnaireTypeId().equals(141L)) {
            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
            }
        } else if (evaluation.getQuestionnaireTypeId().equals(140L)) {
            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
            }
        } else if (evaluation.getQuestionnaireTypeId().equals(230L)) {
            Optional<Tclass> byId = tclassDAO.findById(evaluation.getClassId());
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            List<ClassEvaluationGoals> editedGoalList = classEvaluationGoalsDAO.findByClassId(tclass.getId());
            if (editedGoalList != null && editedGoalList.size() != 0) {
                for (ClassEvaluationGoals classEvaluationGoals : editedGoalList) {
                    Long type = null;
                    String Question = null;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    if (classEvaluationGoals.getGoalId() != null)
                        type = 201L;
                    if (classEvaluationGoals.getSkillId() != null)
                        type = 200L;
                    Question = classEvaluationGoals.getQuestion();
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, classEvaluationGoals.getGoalId(), classEvaluationGoals.getSkillId());
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(0);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setGoalId(classEvaluationGoals.getGoalId());
                        dynamicQuestionCreate.setSkillId(classEvaluationGoals.getSkillId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }
            } else {
                for (Goal goal : tclass.getCourse().getGoalSet()) {
                    String Question = null;
                    Question = goal.getTitleFa();
                    Long type = 201L;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, goal.getId(), null);
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(0);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setGoalId(goal.getId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }

                for (Skill skill : tclass.getCourse().getSkillSet()) {
                    String Question = null;
                    Question = skill.getTitleFa();
                    Long type = 200L;
                    DynamicQuestionDTO.Info dynamicQuestion;
                    List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeIdAndGoalIdAndSkillId(Question, type, null, skill.getId());
                    if (list != null && list.size() > 0) {
                        dynamicQuestion = modelMapper.map(list.get(0), DynamicQuestionDTO.Info.class);
                    } else {
                        DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                        dynamicQuestionCreate.setOrder(-1);
                        dynamicQuestionCreate.setQuestion(Question);
                        dynamicQuestionCreate.setTypeId(type);
                        dynamicQuestionCreate.setWeight(1);
                        dynamicQuestionCreate.setSkillId(skill.getId());
                        dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                    }
                    EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                    evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                    evaluationAnswerCreate.setQuestionSourceId(type);
                    evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                    evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
                }
            }

            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate, EvaluationAnswer.class));
            }
        }
        return evaluationAnswers;
    }

    @Override
    public Double getEvaluationFormGrade(Evaluation evaluation) {
        Double result = null;
        int index = 0;

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> res = getEvaluationFormAnswerDetail(evaluation);

        for (EvaluationAnswerDTO.EvaluationAnswerFullData re : res) {
            if (re.getAnswerId() != null) {
                if (re.getWeight() != null)
                    index += re.getWeight();
                else
                    index++;
                if (result == null)
                    result = 0.0;
                result += (Double.parseDouble(parameterValueDAO.findFirstById(re.getAnswerId()).getValue())) * re.getWeight();
            }
        }
        if (index != 0)
            result = result / index;

        return result;
    }

    @Override
    public List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationFormAnswerDetail(Evaluation evaluation) {
        double result = 0.0;
        int index = 0;

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> res = new ArrayList<>();

        for (EvaluationAnswer evaluationAnswerDTO : evaluation.getEvaluationAnswerList()) {
            EvaluationAnswerDTO.EvaluationAnswerFullData evaluationAnswerFullData = new EvaluationAnswerDTO.EvaluationAnswerFullData();
            evaluationAnswerFullData.setId(evaluationAnswerDTO.getId());
            evaluationAnswerFullData.setEvaluationId(evaluationAnswerDTO.getEvaluationId());
            evaluationAnswerFullData.setEvaluationQuestionId(evaluationAnswerDTO.getEvaluationQuestionId());
            evaluationAnswerFullData.setQuestionSourceId(evaluationAnswerDTO.getQuestionSourceId());
            evaluationAnswerFullData.setAnswerId(evaluationAnswerDTO.getAnswerId());
            evaluationAnswerFullData.setDescription(evaluation.getDescription());

            if (evaluationAnswerFullData.getQuestionSourceId().equals(199L)) {
                Optional<QuestionnaireQuestion> optionalQuestionnaireQuestion = questionnaireQuestionDAO.findById(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(optionalQuestionnaireQuestion.map(QuestionnaireQuestion::getOrder).orElse(null));
                evaluationAnswerFullData.setWeight(optionalQuestionnaireQuestion.map(QuestionnaireQuestion::getWeight).orElse(null));
                if (optionalQuestionnaireQuestion.isPresent() && optionalQuestionnaireQuestion.get().getEvaluationQuestionId()!=null){
                    Optional<EvaluationQuestion> optionalEvaluationQuestion=evaluationQuestionDAO.findById(optionalQuestionnaireQuestion.get().getEvaluationQuestionId());
                    evaluationAnswerFullData.setQuestion(optionalEvaluationQuestion.map(EvaluationQuestion::getQuestion).orElse(null));
                    evaluationAnswerFullData.setDomainId(optionalEvaluationQuestion.map(EvaluationQuestion::getDomainId).orElse(null));
                }else {
                    evaluationAnswerFullData.setQuestion(null);
                    evaluationAnswerFullData.setDomainId(null);

                }
            } else if (evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)) {
                Optional<DynamicQuestion> optionalDynamicQuestion = dynamicQuestionDAO.findById(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(optionalDynamicQuestion.map(DynamicQuestion::getOrder).orElse(null));
                evaluationAnswerFullData.setWeight(optionalDynamicQuestion.map(DynamicQuestion::getWeight).orElse(null));
                evaluationAnswerFullData.setQuestion(optionalDynamicQuestion.map(DynamicQuestion::getQuestion).orElse(null));
                evaluationAnswerFullData.setDomainId(183L);
            }

            res.add(evaluationAnswerFullData);
        }

        return res;
    }

    @Override
    @Transactional
    public EvaluationDTO.BehavioralResult getBehavioralEvaluationResult(Long classId) {
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        EvaluationDTO.BehavioralResult evaluationResult = new EvaluationDTO.BehavioralResult();

        Double[] studentGrade = new Double[tclass.getClassStudents().size()];
        Double[] supervisorGrade = new Double[tclass.getClassStudents().size()];
        Double[] trainingGrade = new Double[tclass.getClassStudents().size()];
        Double[] coWorkersGrade = new Double[tclass.getClassStudents().size()];
        Double[] behavioralGrades = new Double[tclass.getClassStudents().size()];
        String[] classStudentsName = new String[tclass.getClassStudents().size()];

        Double studentGradeMean = 0.0;
        Double supervisorGradeMean = 0.0;
        Double trainingGradeMean = 0.0;
        Double coWorkersGradeMean = 0.0;
        Double behavioralGrade = 0.0;
        Boolean behavioralPass = false;

        Integer studentGradeMeanNum = 0;
        Integer supervisorGradeMeanNum = 0;
        Integer trainingGradeMeanNum = 0;
        Integer coWorkersGradeMeanNum = 0;

        Map<String, Integer> indicesTotalWeight = new HashMap<>();
        Map<String, Double> indicesGrade = new HashMap<>();

        List<ClassEvaluationGoals> editedGoalList = classEvaluationGoalsDAO.findByClassId(tclass.getId());
        if (editedGoalList != null && editedGoalList.size() != 0) {
            for (ClassEvaluationGoals classEvaluationGoals : editedGoalList) {
                if (classEvaluationGoals.getSkillId() != null) {
                    indicesGrade.put("s" + classEvaluationGoals.getSkillId(), 0.0);
                    indicesTotalWeight.put("s" + classEvaluationGoals.getSkillId(), 0);
                }
                if (classEvaluationGoals.getGoalId() != null) {
                    indicesGrade.put("g" + classEvaluationGoals.getGoalId(), 0.0);
                    indicesTotalWeight.put("g" + classEvaluationGoals.getGoalId(), 0);
                }
            }
        } else {
            for (Skill skill : tclass.getCourse().getSkillSet()) {
                indicesGrade.put("s" + skill.getId(), 0.0);
                indicesTotalWeight.put("s" + skill.getId(), 0);
            }
            for (Goal goal : tclass.getCourse().getGoalSet()) {
                indicesGrade.put("g" + goal.getId(), 0.0);
                indicesTotalWeight.put("g" + goal.getId(), 0);
            }

        }

        int index = 0;
        for (ClassStudent classStudent : tclass.getClassStudents()) {
            List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndStatus(
                    classId,
                    156L,
                    230L,
                    classStudent.getId(),
                    188L,
                    true);
            studentGrade[index] = 0.0;
            supervisorGrade[index] = 0.0;
            trainingGrade[index] = 0.0;
            coWorkersGrade[index] = 0.0;

            int studentGradeNum = 0;
            int supervisorGradeNum = 0;
            int trainingGradeNum = 0;
            int coWorkersGradeNum = 0;

            for (Evaluation evaluation : evaluations) {
                int index1 = 0;
                double res = 0.0;
                List<EvaluationAnswerDTO.EvaluationAnswerFullData> res1 = getEvaluationFormAnswerDetail(evaluation);

                for (EvaluationAnswerDTO.EvaluationAnswerFullData re : res1) {
                    if (re.getAnswerId() != null) {
                        Optional<DynamicQuestion> dById = dynamicQuestionDAO.findById(re.getEvaluationQuestionId());
                        if (dById.isPresent()) {
                            DynamicQuestion dynamicQuestion = dById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                            if (dynamicQuestion.getGoalId() != null) {
                                double oldVal = indicesGrade.get("g" + dynamicQuestion.getGoalId());
                                indicesGrade.replace("g" + dynamicQuestion.getGoalId(), oldVal + (Double.parseDouble(parameterValueDAO.findFirstById(re.getAnswerId()).getValue())) * re.getWeight());
                                int indexOldVal = indicesTotalWeight.get("g" + dynamicQuestion.getGoalId());
                                indicesTotalWeight.replace("g" + dynamicQuestion.getGoalId(), indexOldVal + 1);
                            }
                            if (dynamicQuestion.getSkillId() != null) {
                                double oldVal = indicesGrade.get("s" + dynamicQuestion.getSkillId());
                                indicesGrade.replace("s" + dynamicQuestion.getSkillId(), oldVal + (Double.parseDouble(parameterValueDAO.findFirstById(re.getAnswerId()).getValue())) * re.getWeight());
                                int indexOldVal = indicesTotalWeight.get("s" + dynamicQuestion.getSkillId());
                                indicesTotalWeight.replace("s" + dynamicQuestion.getSkillId(), indexOldVal + 1);
                            }
                        }
                        if (re.getAnswerId() != null) {
                            if (re.getWeight() != null)
                                index1 += re.getWeight();
                            else
                                index1++;
                            res += (Double.parseDouble(parameterValueDAO.findFirstById(re.getAnswerId()).getValue())) * re.getWeight();
                        }
                    }
                }
                if (index1 != 0)
                    res = res / index1;
                if (evaluation.getEvaluatorTypeId().equals(189L)) {
                    coWorkersGradeNum++;
                    coWorkersGradeMeanNum++;
                    coWorkersGradeMean += res;
                    coWorkersGrade[index] += res;
                } else if (evaluation.getEvaluatorTypeId().equals(190L)) {
                    supervisorGradeNum++;
                    supervisorGradeMeanNum++;
                    supervisorGradeMean += res;
                    supervisorGrade[index] += res;
                } else if (evaluation.getEvaluatorTypeId().equals(188L)) {
                    studentGradeNum++;
                    studentGradeMeanNum++;
                    studentGradeMean += res;
                    studentGrade[index] += res;
                } else if (evaluation.getEvaluatorTypeId().equals(454L)) {
                    trainingGradeNum++;
                    trainingGradeMeanNum++;
                    trainingGradeMean += res;
                    trainingGrade[index] += res;
                }
            }
            if (studentGradeNum != 0)
                studentGrade[index] = studentGrade[index] / studentGradeNum;
            if (supervisorGradeNum != 0)
                supervisorGrade[index] = supervisorGrade[index] / supervisorGradeNum;
            if (trainingGradeNum != 0)
                trainingGrade[index] = trainingGrade[index] / trainingGradeNum;
            if (coWorkersGradeNum != 0)
                coWorkersGrade[index] = coWorkersGrade[index] / coWorkersGradeNum;
            classStudentsName[index] = classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName();
            index++;
        }

        for (String s : indicesGrade.keySet()) {
            double newVal = indicesGrade.get(s);
            if (indicesTotalWeight.get(s) != 0)
                indicesGrade.replace(s, newVal / indicesTotalWeight.get(s));
        }

        if (!studentGradeMeanNum.equals(0))
            studentGradeMean = studentGradeMean / studentGradeMeanNum;
        if (!supervisorGradeMeanNum.equals(0))
            supervisorGradeMean = supervisorGradeMean / supervisorGradeMeanNum;
        if (!trainingGradeMeanNum.equals(0))
            trainingGradeMean = trainingGradeMean / trainingGradeMeanNum;
        if (!coWorkersGradeMeanNum.equals(0))
            coWorkersGradeMean = coWorkersGradeMean / coWorkersGradeMeanNum;

        Double minScoreEB = 0.0;
        Double z7 = 0.0;
        Double z8 = 0.0;
        Double scoreEvaluationRTEB = 0.0;
        Double scoreEvaluationPartnersEB = 0.0;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEB");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("z7"))
                z7 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("z8"))
                z8 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("scoreEvaluationRTEB"))
                scoreEvaluationRTEB = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("scoreEvaluationPartnersEB"))
                scoreEvaluationPartnersEB = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minScoreEB"))
                minScoreEB = Double.parseDouble(parameterValue.getValue());
        }

        behavioralGrade = (coWorkersGradeMean * scoreEvaluationPartnersEB + trainingGradeMean * scoreEvaluationRTEB + supervisorGradeMean * z7 + studentGradeMean * z8) / 100;
        behavioralPass = behavioralGrade >= minScoreEB;

        for (int i = 0; i < tclass.getClassStudents().size(); i++) {
            behavioralGrades[i] = (coWorkersGrade[i] * scoreEvaluationPartnersEB + studentGrade[i] * z8 + supervisorGrade[i] * z7 + trainingGrade[i] * scoreEvaluationRTEB) / 100;
        }

        evaluationResult.setClassStudentsName(classStudentsName);
        evaluationResult.setCoWorkersGrade(coWorkersGrade);
        evaluationResult.setStudentGrade(studentGrade);
        evaluationResult.setSupervisorGrade(supervisorGrade);
        evaluationResult.setTrainingGrade(trainingGrade);
        evaluationResult.setBehavioralGrades(behavioralGrades);

        evaluationResult.setCoWorkersGradeMean(coWorkersGradeMean);
        evaluationResult.setTrainingGradeMean(trainingGradeMean);
        evaluationResult.setStudentGradeMean(studentGradeMean);
        evaluationResult.setSupervisorGradeMean(supervisorGradeMean);
        evaluationResult.setBehavioralGrade(behavioralGrade);
        evaluationResult.setBehavioralPass(behavioralPass);

        evaluationResult.setIndicesGrade(indicesGrade);

        return evaluationResult;
    }

    @Override
    public Evaluation getById(long id) {
        return evaluationDAO.findById(id).get();
    }

    @Override
    public List<EvalQuestionDto> getEvaluationQuestions(List<EvaluationAnswer> answers) {

        return answers.stream().map(evaluationAnswer -> {
            EvalQuestionDto questionDto = new EvalQuestionDto();
            EvalQuestionOptional questionOptional = new EvalQuestionOptional();
            if (evaluationAnswer.getQuestionSourceId() == 200 ||
                    evaluationAnswer.getQuestionSourceId() == 201) {
                DynamicQuestion dynamicQuestion = dynamicQuestionDAO.findById(evaluationAnswer.getEvaluationQuestionId()).get();
                questionDto.setTitle(dynamicQuestion.getQuestion());
            } else {
                EvaluationQuestion evaluationQuestion = evaluationQuestionDAO.findById(questionnaireQuestionDAO.findById(evaluationAnswer.getEvaluationQuestionId()).get()
                        .getEvaluationQuestionId()).get();
                questionDto.setTitle(evaluationQuestion.getQuestion());
            }
            Comparator<ParameterValue> comparator = Comparator.comparing(ParameterValue::getId);

            questionOptional.setOptions(parameterValueDAO.findAllByParameterId(192L).stream().sorted(comparator).map(ParameterValue::getTitle).collect(Collectors.toList()));
            questionDto.setType(EvalQuestionType.OPTIONAL);
            questionDto.setOption(questionOptional);
            return questionDto;
        }).collect(Collectors.toList());
    }

    @Transactional
    @Override
    public Boolean classHasEvaluationForm(Long classId) {
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Boolean result = false;
        for (ClassStudent std : tclass.getClassStudents()) {
            if (std.getEvaluationStatusReaction() != null && std.getEvaluationStatusReaction() != 0)
                result = true;
            if (std.getNumberOfSendedBehavioralForms() != null && std.getNumberOfSendedBehavioralForms() > 0)
                result = true;
        }
        return result;
    }


    public Long getTclass(Long id) {
        final Optional<Evaluation> sById = evaluationDAO.findById(id);
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));
        return evaluation.getTclass().getId();
    }


    @Transactional
    @Override
    public EvalElsData GetTeacherElsData(HashMap req) {
        EvalElsData data = new EvalElsData();
        EvaluationDTO.Info evaluation = getEvaluationByReq(req);
        if (evaluation != null) {
            data.setSourceId(evaluation.getId());
            data.setMobile(teacherDAO.getTeacherNationalCode(Long.parseLong(req.get("evaluatorId").toString())));
        }
        return data;

    }

    @Override
    @Transactional
    public EvalElsData GetStudentElsData(HashMap req) {
        EvalElsData data = new EvalElsData();
        EvaluationDTO.Info evaluation = getEvaluationByReq(req);
        if (evaluation != null) {
            data.setSourceId(evaluation.getId());
            data.setMobile(req.get("nationalCode").toString());
        }
        return data;
    }

    @Transactional
    public EvaluationDTO.Info getEvaluationByReq(HashMap req) {
        return getEvaluationByData(
                Long.parseLong(req.get("questionnaireTypeId").toString()),
                Long.parseLong(req.get("classId").toString()),
                Long.parseLong(req.get("evaluatorId").toString()),
                Long.parseLong(req.get("evaluatorTypeId").toString()),
                Long.parseLong(req.get("evaluatedId").toString()),
                Long.parseLong(req.get("evaluatedTypeId").toString()),
                Long.parseLong(req.get("evaluationLevelId").toString()));
    }

}
