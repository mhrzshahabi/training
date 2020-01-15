package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionnaireQuestionDTO;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.repository.QuestionnaireQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class QuestionnaireQuestionService extends BaseService<QuestionnaireQuestion, Long, QuestionnaireQuestionDTO.Info, QuestionnaireQuestionDTO.Create, QuestionnaireQuestionDTO.Update, QuestionnaireQuestionDTO.Delete, QuestionnaireQuestionDAO> {

    @Autowired
    private QuestionnaireService questionnaireService;

    @Autowired
    QuestionnaireQuestionService(QuestionnaireQuestionDAO QuestionnaireQuestionDAO) {
        super(new QuestionnaireQuestion(), QuestionnaireQuestionDAO);
    }

    @Transactional
    public QuestionnaireQuestionDTO.Info checkAndCreate(QuestionnaireQuestionDTO.Create rq) {
        Long questionnaireId = rq.getQuestionnaireId();
        if (questionnaireService.isExist(questionnaireId)) {
            return create(rq);
        } else {
            throw new TrainingException(TrainingException.ErrorType.QuestionnaireNotFound);
        }
    }
}
