package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.QuestionnaireDTO;

import java.util.List;

public interface IQuestionnaireService {
    Boolean isLocked(Long id);

    List<QuestionnaireDTO.Info> list();

    TotalResponse<QuestionnaireDTO.Info> search(NICICOCriteria nicicoCriteria);

    QuestionnaireDTO.Info create(QuestionnaireDTO.Create create);

    QuestionnaireDTO.Info update(Long id, QuestionnaireDTO.Update update);

    QuestionnaireDTO.Info updateEnable(Long id);

    QuestionnaireDTO.Info deleteWithChildren(Long id);
}
