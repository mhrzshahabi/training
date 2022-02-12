package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.EvaluationQuestionDTO;

import java.util.List;

public interface IEvaluationQuestionService {
    Integer usedCount(Long id);

    List<EvaluationQuestionDTO.Info> list();

    TotalResponse<EvaluationQuestionDTO.InfoWithDomain> searchForPickList(NICICOCriteria nicicoCriteria);

    TotalResponse<EvaluationQuestionDTO.Info> search(NICICOCriteria nicicoCriteria);

    EvaluationQuestionDTO.Info create(EvaluationQuestionDTO.Create create, List<Long> indexIds);

    EvaluationQuestionDTO.Info update(Long id, EvaluationQuestionDTO.Update update, List<Long> indexIds);

    EvaluationQuestionDTO.Info delete(Long id);
}
