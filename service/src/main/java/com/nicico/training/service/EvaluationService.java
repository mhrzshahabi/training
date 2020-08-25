package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import javax.transaction.TransactionScoped;
import java.util.*;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluationService {

    private final ModelMapper modelMapper;
    private final EvaluationDAO evaluationDAO;
    private final ClassStudentDAO classStudentDAO;
    private final ParameterService parameterService;
    private final QuestionnaireDAO questionnaireDAO;
    private final TclassDAO tclassDAO;
    private final GoalDAO goalDAO;
    private final SkillDAO skillDAO;
    private final DynamicQuestionService dynamicQuestionService;
    private final DynamicQuestionDAO dynamicQuestionDAO;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final ParameterValueDAO parameterValueDAO;
    private final ClassEvaluationGoalsDAO classEvaluationGoalsDAO;


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
        final Evaluation evaluation = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EvaluationNotFound));

        Evaluation updating = new Evaluation();
        modelMapper.map(evaluation, updating);
        modelMapper.map(request, updating);

        updating.setVersion(evaluation.getVersion());

        Evaluation evaluation1 = evaluationDAO.save(updating);

        if(updating.getQuestionnaireTypeId() != null && updating.getQuestionnaireTypeId().equals(139L)) {
            if(updating.getEvaluationFull())
                updateClassStudentInfo(updating, 2);
            else if(!updating.getEvaluationFull())
                updateClassStudentInfo(updating, 3);
        }

        else  if(updating.getQuestionnaireTypeId() != null && updating.getQuestionnaireTypeId().equals(141L)) {
            if(updating.getEvaluationFull())
                updateTclassInfo(updating.getClassId(),2, -1);
            else if(!updating.getEvaluationFull())
                updateTclassInfo(updating.getClassId(),3, -1);
        }

        else  if(updating.getQuestionnaireTypeId() != null && updating.getQuestionnaireTypeId().equals(140L)) {
            if(updating.getEvaluationFull())
                updateTclassInfo(updating.getClassId(),-1, 2);
            else if(!updating.getEvaluationFull())
                updateTclassInfo(updating.getClassId(),-1, 3);
        }

        else  if(updating.getQuestionnaireTypeId() != null && updating.getQuestionnaireTypeId().equals(230L)) {
            updateClassStudentInfo(updating, 2);
        }

        return modelMapper.map(evaluation1, EvaluationDTO.Info.class);
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

    private EvaluationDTO.Info save(Evaluation evaluation) {
//        if(evaluation.getReturnDate() == null){
//            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//            Date date = new Date();
//            Calendar calendar = Calendar.getInstance();
//            calendar.setTime(date);
//            calendar.add(Calendar.MONTH, 1);
//            evaluation.setReturnDate(DateUtil.convertMiToKh(formatter.format(calendar.getTime())));
//        }
        final Evaluation saved = evaluationDAO.saveAndFlush(evaluation);
        Long evaluationId = saved.getId();
        if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(139L)) {
            updateClassStudentInfo(saved, 1);
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
        }
        else if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(141L)) {
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
            updateTclassInfo(evaluation.getClassId(),1, -1);
        }
        else if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(140L)) {
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
            updateQuestionnarieInfo(evaluation.getQuestionnaireId());
            updateTclassInfo(evaluation.getClassId(),-1, 1);
        }
        else if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(230L)) {
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
        if(evaluation == null)
            return null;
        else
            return modelMapper.map(evaluation,EvaluationDTO.Info.class);
    }

    @Transactional
    public List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationForm(@RequestBody HashMap req){

        EvaluationDTO.Info evaluation = getEvaluationByData(Long.parseLong(req.get("questionnaireTypeId").toString()),
                Long.parseLong(req.get("classId").toString()),
                Long.parseLong(req.get("evaluatorId").toString()),
                Long.parseLong(req.get("evaluatorTypeId").toString()),
                Long.parseLong(req.get("evaluatedId").toString()),
                Long.parseLong(req.get("evaluatedTypeId").toString()),
                Long.parseLong(req.get("evaluationLevelId").toString()));

        if(evaluation != null) {
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
                    QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setOrder(questionnaireQuestion.getOrder());
                    evaluationAnswerFullData.setWeight(questionnaireQuestion.getWeight());
                    evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                    evaluationAnswerFullData.setDomainId(questionnaireQuestion.getEvaluationQuestion().getDomainId());
                } else if (evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)) {
                    DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setOrder(dynamicQuestion.getOrder());
                    evaluationAnswerFullData.setWeight(dynamicQuestion.getWeight());
                    evaluationAnswerFullData.setQuestion(dynamicQuestion.getQuestion());
                }

                result.add(evaluationAnswerFullData);
            }
            Comparator<EvaluationAnswerDTO.EvaluationAnswerFullData> compareByOrder = (EvaluationAnswerDTO.EvaluationAnswerFullData o1, EvaluationAnswerDTO.EvaluationAnswerFullData o2) ->
                    o1.getOrder().compareTo( o2.getOrder() );
            Collections.sort(result, compareByOrder);
            return result;
        }
        else
            return null;

    }

    @Transactional
    @Override
    public Boolean deleteEvaluation(@RequestBody HashMap req) {

        EvaluationDTO.Info evaluation = getEvaluationByData(
                Long.parseLong(req.get("questionnaireTypeId").toString()),
                Long.parseLong(req.get("classId").toString()),
                Long.parseLong(req.get("evaluatorId").toString()),
                Long.parseLong(req.get("evaluatorTypeId").toString()),
                Long.parseLong(req.get("evaluatedId").toString()),
                Long.parseLong(req.get("evaluatedTypeId").toString()),
                Long.parseLong(req.get("evaluationLevelId").toString()));
        if(evaluation != null) {
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
        }
        else
            return false;
    }

    //----------------------------------------------- evaluation updating ----------------------------------------------
    public void updateTclassInfo(Long classID,Integer reactionTrainingStatus, Integer reactionTeacherStatus){
        Optional<Tclass> byId = tclassDAO.findById(classID);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if(reactionTeacherStatus.equals(-1))
            tclass.setEvaluationStatusReactionTraining(reactionTrainingStatus);
        else if(reactionTrainingStatus.equals(-1))
            tclass.setEvaluationStatusReactionTeacher(reactionTeacherStatus);
    }

    public void updateClassStudentInfo(Evaluation evaluation,Integer version){
            if(evaluation.getQuestionnaireTypeId().equals(139L)){
                Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatorId());
                ClassStudent classStudent = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                classStudent.setEvaluationStatusReaction(version);
            }
            else  if(evaluation.getQuestionnaireTypeId().equals(230L)){
                Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatedId());
                ClassStudent classStudent = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                       evaluation.getClassId(),evaluation.getEvaluatedId(), 188L,156L, 230L);
                classStudent.setNumberOfSendedBehavioralForms(0);
                classStudent.setNumberOfRegisteredBehavioralForms(0);
                for (Evaluation evaluation1 : evaluations) {
                    if(!evaluation1.getStatus())
                        classStudent.setNumberOfSendedBehavioralForms(classStudent.getNumberOfSendedBehavioralForms()+1);
                    else if(evaluation1.getStatus()) {
                        classStudent.setNumberOfSendedBehavioralForms(classStudent.getNumberOfSendedBehavioralForms() + 1);
                        classStudent.setNumberOfRegisteredBehavioralForms(classStudent.getNumberOfRegisteredBehavioralForms() + 1);
                    }
                }

            }
    }

    public void updateQuestionnarieInfo(Long questionnarieId){
        List<Evaluation> list = evaluationDAO.findByQuestionnaireId(questionnarieId);
        Optional<Questionnaire> byId = questionnaireDAO.findById(questionnarieId);
        Questionnaire questionnaire = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if(list!= null && list.size() != 0)
            questionnaire.setLockStatus(true);
        else
            questionnaire.setLockStatus(false);
    }

    public List<EvaluationAnswer> createEvaluationAnswers(Evaluation evaluation){
        List<EvaluationAnswer> evaluationAnswers = new ArrayList<>();
        if(evaluation.getQuestionnaireTypeId().equals(139L)){
            Optional<Tclass> byId = tclassDAO.findById(evaluation.getClassId());
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            for (Goal goal : tclass.getCourse().getGoalSet()) {
                ClassEvaluationGoals classEvaluationGoals = classEvaluationGoalsDAO.findByClassIdAndSkillIdAndGoalId(tclass.getId(),null,goal.getId());
                String Question = null;
                if(classEvaluationGoals != null)
                    Question = classEvaluationGoals.getQuestion();
                else
                    Question = goal.getTitleFa();
                Long type = 201L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(0);
                    dynamicQuestionCreate.setQuestion(Question);
                    dynamicQuestionCreate.setTypeId(type);
                    dynamicQuestionCreate.setWeight(1);
                    dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                }
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(type);
                evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
//                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }

            for(Skill skill : tclass.getCourse().getSkillSet()){
                ClassEvaluationGoals classEvaluationGoals = classEvaluationGoalsDAO.findByClassIdAndSkillIdAndGoalId(tclass.getId(),skill.getId(),null);
                String Question = null;
                if(classEvaluationGoals != null)
                    Question = classEvaluationGoals.getQuestion();
                else
                    Question = skill.getTitleFa();

                Long type = 200L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(-1);
                    dynamicQuestionCreate.setQuestion(Question);
                    dynamicQuestionCreate.setTypeId(type);
                    dynamicQuestionCreate.setWeight(1);
                    dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                }
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(type);
                evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
//                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }

            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
//                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }
        }
        else if(evaluation.getQuestionnaireTypeId().equals(141L)){
            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }
        }
        else if(evaluation.getQuestionnaireTypeId().equals(140L)){
            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }
        }
        else if(evaluation.getQuestionnaireTypeId().equals(230L)){
            Optional<Tclass> byId = tclassDAO.findById(evaluation.getClassId());
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            for (Goal goal : tclass.getCourse().getGoalSet()) {
                ClassEvaluationGoals classEvaluationGoals = classEvaluationGoalsDAO.findByClassIdAndSkillIdAndGoalId(tclass.getId(),null,goal.getId());
                String Question = null;
                if(classEvaluationGoals != null)
                    Question = classEvaluationGoals.getQuestion();
                else
                    Question = goal.getTitleFa();
                Long type = 201L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(0);
                    dynamicQuestionCreate.setQuestion(Question);
                    dynamicQuestionCreate.setTypeId(type);
                    dynamicQuestionCreate.setWeight(1);
                    dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                }
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(type);
                evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }

            for(Skill skill : tclass.getCourse().getSkillSet()){
                ClassEvaluationGoals classEvaluationGoals = classEvaluationGoalsDAO.findByClassIdAndSkillIdAndGoalId(tclass.getId(),skill.getId(),null);
                String Question = null;
                if(classEvaluationGoals != null)
                    Question = classEvaluationGoals.getQuestion();
                else
                    Question = skill.getTitleFa();
                Long type = 200L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(-1);
                    dynamicQuestionCreate.setQuestion(Question);
                    dynamicQuestionCreate.setTypeId(type);
                    dynamicQuestionCreate.setWeight(1);
                    dynamicQuestion = dynamicQuestionService.create(dynamicQuestionCreate);
                }
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(type);
                evaluationAnswerCreate.setEvaluationQuestionId(dynamicQuestion.getId());
                evaluationAnswers.add(modelMapper.map(evaluationAnswerCreate,EvaluationAnswer.class));
            }
        }
        return evaluationAnswers;
    }

    public String getGoalQuestion(Long id) {
        final Optional<Goal> gById = goalDAO.findById(id);
        final Goal goal = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));

        String question = "";

        if (goal.getTitleFa().trim().indexOf("همایش")>-1||goal.getTitleFa().trim().indexOf("کنگره")>-1||goal.getTitleFa().trim().indexOf("هم اندیشی")>-1||goal.getTitleFa().trim().indexOf("کارگاه")>-1||goal.getTitleFa().trim().indexOf("سمینار")>-1) {
            question = "میزان تسلط بر مفاهیم " + goal.getTitleFa();
        } else if (goal.getTitleFa().trim().indexOf("مناقصات")>-1) {
            question = "میزان آشنایی با " +  goal.getTitleFa();
        }else{
            question = "میزان آشنایی با " + goal.getTitleFa();
        }

        return question;

    }

    public String getSkillQuestion(Long id) {
        final Optional<Skill> gById = skillDAO.findById(id);
        final Skill skill = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String skillLevel = skill.getSkillLevel().getTitleFa();
        String question = "";


        switch(skillLevel){
            case "آشنایی":
                skillLevel+=" با";
                break;
            case "توانایی":
                //skillLevel+=" بر";
                break;
            case "تسلط":
                skillLevel+=" بر";
                break;
        }
        question=skill.getTitleFa().trim();
        question=question.replace("آشنائی","آشنایی");

        if (!question.startsWith(skillLevel)) {
            question = "میزان " + skillLevel + " " + question;
        } else {
            question = "میزان " + question;
        }

        return question;

    }

    @Override
    public double getEvaluationFormGrade(Evaluation evaluation){
        double result = 0.0;
        int index = 0;

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> res =  getEvaluationFormAnswerDetail(evaluation);

        for (EvaluationAnswerDTO.EvaluationAnswerFullData re : res) {
            if(re.getAnswerId() != null) {
                if(re.getWeight() != null)
                    index += re.getWeight();
                else
                    index ++;
                result += (Double.parseDouble(parameterValueDAO.findFirstById(re.getAnswerId()).getValue()))*re.getWeight();
            }
        }
        if(index!=0)
            result = result/index;

        return result;
    }

    @Override
    public List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationFormAnswerDetail(Evaluation evaluation){
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
                QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(questionnaireQuestion.getOrder());
                evaluationAnswerFullData.setWeight(questionnaireQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                evaluationAnswerFullData.setDomainId(questionnaireQuestion.getEvaluationQuestion().getDomainId());
            } else if (evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)) {
                DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(dynamicQuestion.getOrder());
                evaluationAnswerFullData.setWeight(dynamicQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(dynamicQuestion.getQuestion());
                evaluationAnswerFullData.setDomainId(183L);
            }

            res.add(evaluationAnswerFullData);
        }

        return res;
    }

    @Override
    @Transactional
    public EvaluationDTO.BehavioralResult getBehavioralEvaluationResult(Long classId){
        Optional<Tclass> byId = tclassDAO.findById(classId);
        Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        EvaluationDTO.BehavioralResult evaluationResult = new EvaluationDTO.BehavioralResult();

        Double[] studentGrade = new Double[tclass.getClassStudents().size()];
        Double[] supervisorGrade = new Double[tclass.getClassStudents().size()];
        Double[] trainingGrade = new Double[tclass.getClassStudents().size()];
        Double[] coWorkersGrade = new Double[tclass.getClassStudents().size()];
        String[] classStudentsName = new String[tclass.getClassStudents().size()];

        Double studentGradeMean = 0.0;
        Double supervisorGradeMean = 0.0;
        Double trainingGradeMean = 0.0;
        Double coWorkersGradeMean = 0.0;

        Integer studentGradeMeanNum = 0;
        Integer supervisorGradeMeanNum = 0;
        Integer trainingGradeMeanNum = 0;
        Integer coWorkersGradeMeanNum = 0;

        int index = 0;
        for (ClassStudent classStudent : tclass.getClassStudents()) {
            List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndStatus(
                    classId,
                    156L,
                    230L,
                    classStudent.getId(),
                    188L,
                    true);
            studentGrade[index] = 0.0 ;
            supervisorGrade[index] = 0.0;
            trainingGrade[index] = 0.0;
            coWorkersGrade[index] = 0.0;

            Integer studentGradeNum = 0 ;
            Integer supervisorGradeNum = 0;
            Integer trainingGradeNum = 0;
            Integer coWorkersGradeNum = 0;

            for (Evaluation evaluation : evaluations) {
                double res = getEvaluationFormGrade(evaluation);
                if(evaluation.getEvaluatorTypeId().equals(189L)) {
                    coWorkersGradeNum++;
                    coWorkersGradeMeanNum++;
                    coWorkersGradeMean += res;
                    coWorkersGrade[index] += res;
                }
                else if(evaluation.getEvaluatorTypeId().equals(190L)) {
                    supervisorGradeNum++;
                    supervisorGradeMeanNum++;
                    supervisorGradeMean += res;
                    supervisorGrade[index] += res;
                }
                else if(evaluation.getEvaluatorTypeId().equals(188L)) {
                    studentGradeNum++;
                    studentGradeMeanNum++;
                    studentGradeMean += res;
                    studentGrade[index] += res;
                }
                else if(evaluation.getEvaluatorTypeId().equals(454L)) {
                    trainingGradeNum++;
                    trainingGradeMeanNum++;
                    trainingGradeMean += res;
                    trainingGrade[index] += res;
                }
            }
            if(!studentGradeNum.equals(new Integer(0)))
                studentGrade[index] = studentGrade[index]/studentGradeNum;
            if(!supervisorGradeNum.equals(new Integer(0)))
                supervisorGrade[index] = supervisorGrade[index]/supervisorGradeNum;
            if(!trainingGradeNum.equals(new Integer(0)))
                trainingGrade[index] = trainingGrade[index]/trainingGradeNum;
            if(!coWorkersGradeNum.equals(new Integer(0)))
                coWorkersGrade[index] = coWorkersGrade[index]/coWorkersGradeNum;
            classStudentsName[index] = classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName();
            index++;
        }

        if(!studentGradeMeanNum.equals(0))
            studentGradeMean = studentGradeMean/studentGradeMeanNum;
        if(!supervisorGradeMeanNum.equals(0))
            supervisorGradeMean = supervisorGradeMean/supervisorGradeMeanNum;
        if(!trainingGradeMeanNum.equals(0))
            trainingGradeMean = trainingGradeMean/trainingGradeMeanNum;
        if(!coWorkersGradeMeanNum.equals(0))
            coWorkersGradeMean = coWorkersGradeMean/coWorkersGradeMeanNum;


        evaluationResult.setClassStudentsName(classStudentsName);
        evaluationResult.setCoWorkersGrade(coWorkersGrade);
        evaluationResult.setStudentGrade(studentGrade);
        evaluationResult.setSupervisorGrade(supervisorGrade);
        evaluationResult.setTrainingGrade(trainingGrade);

        evaluationResult.setCoWorkersGradeMean(coWorkersGradeMean);
        evaluationResult.setTrainingGradeMean(trainingGradeMean);
        evaluationResult.setStudentGradeMean(studentGradeMean);
        evaluationResult.setSupervisorGradeMean(supervisorGradeMean);

        return evaluationResult;
    }

}
