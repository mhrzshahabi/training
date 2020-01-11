package com.nicico.training.service;

import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.model.Questionnaire;
import com.nicico.training.repository.QuestionnaireDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class QuestionnaireService extends BaseService<Questionnaire, Long, QuestionnaireDTO.Info, QuestionnaireDTO.Create, QuestionnaireDTO.Update, QuestionnaireDTO.Delete, QuestionnaireDAO> {

    @Autowired
    QuestionnaireService(QuestionnaireDAO QuestionnaireDAO) {
        super(new Questionnaire(), QuestionnaireDAO);
    }

}
