package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionnaireQuestionDTO;
import com.nicico.training.iservice.IQuestionnaireQuestionService;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.repository.QuestionnaireQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
public class QuestionnaireQuestionService extends BaseService<QuestionnaireQuestion, Long, QuestionnaireQuestionDTO.Info, QuestionnaireQuestionDTO.Create, QuestionnaireQuestionDTO.Update, QuestionnaireQuestionDTO.Delete, QuestionnaireQuestionDAO> implements IQuestionnaireQuestionService {

    @Autowired
    private QuestionnaireQuestionDAO questionnaireQuestionDAO;

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

//    @Override
//    @Transactional
//    public List<QuestionnaireQuestionDTO.Info> getByEvaluationTeacherQuestions(Long postId) {
//
//        List<QuestionnaireQuestion> questionnaireQuestions = null;
//        questionnaireQuestions = questionnaireQuestionDAO.findByEvaluationQuestionDomainAndEEnabled(53 , 1);
//
//        return modelMapper.map(questionnaireQuestions, new TypeToken<List<QuestionnaireQuestionDTO.Info>>() {
//        }.getType());
//
//    }

    public List<QuestionnaireQuestion> getEvaluationQuestion(Long domainId) {
        return questionnaireQuestionDAO.findActiveQuestionnaries(domainId);
    }

    @Override
    public QuestionnaireQuestion getById(Long QuestionnaireQuestionId) {
        return questionnaireQuestionDAO.getById(QuestionnaireQuestionId);
    }
}
