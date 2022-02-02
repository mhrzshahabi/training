package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.iservice.IQuestionnaireService;
import com.nicico.training.model.Questionnaire;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.repository.QuestionnaireDAO;
import com.nicico.training.repository.QuestionnaireQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class QuestionnaireService extends BaseService<Questionnaire, Long, QuestionnaireDTO.Info, QuestionnaireDTO.Create, QuestionnaireDTO.Update, QuestionnaireDTO.Delete, QuestionnaireDAO> implements IQuestionnaireService {

    @Autowired
    QuestionnaireService(QuestionnaireDAO QuestionnaireDAO) {
        super(new Questionnaire(), QuestionnaireDAO);
    }

    @Autowired
    private QuestionnaireQuestionDAO questionnaireQuestionDAO;

    @Transactional
    public Boolean isLocked(Long id) {
        Integer result = dao.isLocked(id);
        return result == null ? false : (result == 1 ? true : false);
    }

    @Transactional
    public QuestionnaireDTO.Info updateEnable(Long id) {
        Questionnaire oQuestionnaire = dao.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        oQuestionnaire.setEnabled(new Long(74L).equals(oQuestionnaire.getEnabled()) ? null : 74L);
        dao.save(oQuestionnaire);
        return modelMapper.map(oQuestionnaire, QuestionnaireDTO.Info.class);
    }

    @Transactional
    public QuestionnaireDTO.Info deleteWithChildren(Long id) {
        final Optional<Questionnaire> optional = dao.findById(id);
        final Questionnaire entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        try {
            Questionnaire model = dao.findById(id).orElse(null);

            if (model == null) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            } else {
                List<QuestionnaireQuestion> questionnaireQuestionList = model.getQuestionnaireQuestionList();

                questionnaireQuestionDAO.deleteAll(questionnaireQuestionList);

                dao.deleteById(id);
                return modelMapper.map(entity, QuestionnaireDTO.Info.class);
            }

        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

}
