package com.nicico.training.mapper.evaluationAnswer;

import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.model.*;
import com.nicico.training.service.DynamicQuestionService;
import com.nicico.training.service.EvaluationQuestionService;
import com.nicico.training.service.ParameterValueService;
import com.nicico.training.service.QuestionnaireQuestionService;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class EvaluationAnswerAuditMapper {

    @Autowired
    private QuestionnaireQuestionService questionnaireQuestionService;
    @Autowired
    private ParameterValueService parameterValueService;
    @Autowired
    private DynamicQuestionService dynamicQuestionService;
    @Autowired
    private EvaluationQuestionService evaluationQuestionService;

    @Mapping(source = "evaluationAnswerAudit", target = "question", qualifiedByName = "getQuestionByEvaluationAnswerAudit")
    @Mapping(source = "answerId", target = "answerTitle", qualifiedByName = "getAnswerByAnswerId")
    public abstract EvaluationAnswerDTO.EvaluationAnswerForAudit toEvaluationAnswerForAudit(EvaluationAnswerAudit evaluationAnswerAudit);

    public abstract List<EvaluationAnswerDTO.EvaluationAnswerForAudit> toEvaluationAnswerForAuditList(List<EvaluationAnswerAudit> evaluationAnswerAudit);


    @Named("getQuestionByEvaluationAnswerAudit")
    protected String getQuestionByEvaluationAnswerAudit(EvaluationAnswerAudit evaluationAnswerAudit) {
        Long qSourceId = evaluationAnswerAudit.getQuestionSourceId();
        if (qSourceId == 199L) {
            QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionService.get(evaluationAnswerAudit.getEvaluationQuestionId());
            EvaluationQuestion evaluationQuestion = evaluationQuestionService.get(questionnaireQuestion.getEvaluationQuestionId());
            return evaluationQuestion.getQuestion();
        } else {
            DynamicQuestion dynamicQuestion = dynamicQuestionService.get(evaluationAnswerAudit.getEvaluationQuestionId());
            return dynamicQuestion.getQuestion();
        }
    }

    @Named("getAnswerByAnswerId")
    protected String getAnswerByAnswerId(Long answerId) {
        ParameterValue parameterValue = parameterValueService.get(answerId);
        return parameterValue.getTitle();
    }

}
