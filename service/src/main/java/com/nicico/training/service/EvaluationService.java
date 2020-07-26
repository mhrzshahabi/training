package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

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
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;;


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

        if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(139L)) {
            if(evaluation.getEvaluationFull())
                updateClassStudentInfo(updating, 2);
            else if(!evaluation.getEvaluationFull())
                updateClassStudentInfo(updating, 3);
        }

        else  if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(141L)) {
            if(evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(),2, -1);
            else if(!evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(),3, -1);
        }

        else  if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(140L)) {
            if(evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(),-1, 2);
            else if(!evaluation.getEvaluationFull())
                updateTclassInfo(evaluation.getClassId(),-1, 3);
        }

        return modelMapper.map(evaluationDAO.save(updating), EvaluationDTO.Info.class);
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
    public EvaluationDTO.Info getEvaluationByData(Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId, Long evaluatedTypeId, Long evaluationLevelId) {
        final Evaluation evaluation = evaluationDAO.findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(questionnaireTypeId, classId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);
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

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> result = new ArrayList<>();


        for (EvaluationAnswerDTO.Info evaluationAnswerDTO : evaluation.getEvaluationAnswerList()) {
            EvaluationAnswerDTO.EvaluationAnswerFullData evaluationAnswerFullData = new EvaluationAnswerDTO.EvaluationAnswerFullData();
            evaluationAnswerFullData.setId(evaluationAnswerDTO.getId());
            evaluationAnswerFullData.setEvaluationId(evaluationAnswerDTO.getEvaluationId());
            evaluationAnswerFullData.setEvaluationQuestionId(evaluationAnswerDTO.getEvaluationQuestionId());
            evaluationAnswerFullData.setQuestionSourceId(evaluationAnswerDTO.getQuestionSourceId());
            evaluationAnswerFullData.setAnswerId(evaluationAnswerDTO.getAnswerId());
            evaluationAnswerFullData.setDescription(evaluation.getDescription());

            if(evaluationAnswerFullData.getQuestionSourceId().equals(199L)){
                QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(questionnaireQuestion.getOrder());
                evaluationAnswerFullData.setWeight(questionnaireQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                evaluationAnswerFullData.setDomainId(questionnaireQuestion.getEvaluationQuestion().getDomainId());
            }
            else  if(evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)){
                DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(dynamicQuestion.getOrder());
                evaluationAnswerFullData.setWeight(dynamicQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(dynamicQuestion.getQuestion());
            }

            result.add(evaluationAnswerFullData);
        }
        return result;
    }

    @Transactional
    public void deleteEvaluation(@RequestBody HashMap req) {

        EvaluationDTO.Info evaluation = getEvaluationByData(Long.parseLong(req.get("questionnaireTypeId").toString()),
                Long.parseLong(req.get("classId").toString()),
                Long.parseLong(req.get("evaluatorId").toString()),
                Long.parseLong(req.get("evaluatorTypeId").toString()),
                Long.parseLong(req.get("evaluatedId").toString()),
                Long.parseLong(req.get("evaluatedTypeId").toString()),
                Long.parseLong(req.get("evaluationLevelId").toString()));

        if(req.get("questionnaireTypeId").toString().equals("139"))
            updateClassStudentInfo(modelMapper.map(evaluation,Evaluation.class),0);
        else if(req.get("questionnaireTypeId").toString().equals("141"))
            updateTclassInfo(Long.parseLong(req.get("classId").toString()),0, -1);
        else if(req.get("questionnaireTypeId").toString().equals("140"))
            updateTclassInfo(Long.parseLong(req.get("classId").toString()),-1, 0);
        evaluationDAO.deleteById(evaluation.getId());
        updateQuestionnarieInfo(evaluation.getQuestionnaireId());
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
                String Question = getGoalQuestion(goal.getId());
                Long type = 201L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(1);
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
                String Question = getSkillQuestion(skill.getId());
                Long type = 200L;
                DynamicQuestionDTO.Info dynamicQuestion;
                List<DynamicQuestion> list = dynamicQuestionDAO.findByQuestionAndTypeId(Question,type);
                if(list != null && list.size() >0){
                    dynamicQuestion = modelMapper.map(list.get(0),DynamicQuestionDTO.Info.class);
                }
                else{
                    DynamicQuestionDTO.Info dynamicQuestionCreate = new DynamicQuestionDTO.Info();
                    dynamicQuestionCreate.setOrder(1);
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

}
