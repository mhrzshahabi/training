package com.nicico.training.service;

import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.model.Questionnaire;
import com.nicico.training.repository.QuestionnaireDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class QuestionnaireService extends BaseService<Questionnaire, Long, QuestionnaireDTO.Info, QuestionnaireDTO.Create, QuestionnaireDTO.Update, QuestionnaireDTO.Delete, QuestionnaireDAO> {

    @Autowired
    QuestionnaireService(QuestionnaireDAO QuestionnaireDAO) {
        super(new Questionnaire(), QuestionnaireDAO);
    }

    @Transactional
    public Boolean isLocked(Long id) {
        Integer result = dao.isLocked(id);
        return result == null ? false : (result == 1 ? true : false);
    }

    @Transactional
    public QuestionnaireDTO.Info updateEnable(Long id) {
        Optional<Questionnaire> model=dao.findById(id);

        Questionnaire oQuestionnaire=model.orElse(null);

        if(oQuestionnaire==null)
            return null;
        else
        {
            Long enable=oQuestionnaire.getEEnabled();

            if(enable==null||enable==74){
                enable=494L;
            }else{
                enable=74L;
            }

            oQuestionnaire.setEEnabled(enable);

            dao.save(oQuestionnaire);

            return modelMapper.map(oQuestionnaire,QuestionnaireDTO.Info.class);
        }
    }

}
