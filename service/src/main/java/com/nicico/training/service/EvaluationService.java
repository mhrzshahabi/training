package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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
    private final EvaluationAnswerService evaluationAnswerSer;


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

        for (EvaluationAnswer evaluationAnswer : updating.getEvaluationAnswerList()) {
            evaluationAnswer.setEvaluationId(id);
        }
        updateClassStudentInfo(updating,false);

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
        if(evaluation.getQuestionnaireTypeId() != null && evaluation.getQuestionnaireTypeId().equals(139L)) {
            Long evaluationId = saved.getId();
            updateClassStudentInfo(saved, true);
            updateQuestionnarieInfo(true, evaluation.getQuestionnaireId());
            List<EvaluationAnswer> list = createEvaluationAnswers(saved);
            saved.setEvaluationAnswerList(list);
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

    public EvaluationDTO.Info getEvaluationByData(Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId, Long evaluatedTypeId, Long evaluationLevelId) {
        final Evaluation evaluation = evaluationDAO.findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(questionnaireTypeId, classId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);
        return modelMapper.map(evaluation, EvaluationDTO.Info.class);
    }

    //----------------------------------------------- evaluation updating ----------------------------------------------
    public void updateTclassInfo(){

    }

    public void updateClassStudentInfo(Evaluation evaluation,Boolean create){
        if(create){
            if(evaluation.getQuestionnaireTypeId().equals(139L)){
                Optional<ClassStudent> byId = classStudentDAO.findById(evaluation.getEvaluatorId());
                ClassStudent classStudent = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
                classStudent.setEvaluationStatusReaction(1);
            }
        }
    }

    public void updateQuestionnarieInfo(Boolean lockStatus,Long questionnarieId){
        Optional<Questionnaire> byId = questionnaireDAO.findById(questionnarieId);
        Questionnaire questionnaire = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        questionnaire.setLockStatus(lockStatus);
    }

    public List<EvaluationAnswer> createEvaluationAnswers(Evaluation evaluation){
        List<EvaluationAnswer> evaluationAnswers = new ArrayList<>();
        if(evaluation.getQuestionnaireTypeId().equals(139L)){
            Optional<Tclass> byId = tclassDAO.findById(evaluation.getClassId());
            Tclass tclass = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));

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
                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswer,EvaluationAnswer.class));
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
                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswer,EvaluationAnswer.class));
            }

            Optional<Questionnaire> qId = questionnaireDAO.findById(evaluation.getQuestionnaireId());
            Questionnaire questionnaire = qId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            for (QuestionnaireQuestion questionnaireQuestion : questionnaire.getQuestionnaireQuestionList()) {
                EvaluationAnswerDTO.Create evaluationAnswerCreate = new EvaluationAnswerDTO.Create();
                evaluationAnswerCreate.setEvaluationId(evaluation.getId());
                evaluationAnswerCreate.setQuestionSourceId(199L);
                evaluationAnswerCreate.setEvaluationQuestionId(questionnaireQuestion.getId());
                EvaluationAnswerDTO.Info evaluationAnswer = evaluationAnswerSer.create(evaluationAnswerCreate);
                evaluationAnswers.add(modelMapper.map(evaluationAnswer,EvaluationAnswer.class));
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
