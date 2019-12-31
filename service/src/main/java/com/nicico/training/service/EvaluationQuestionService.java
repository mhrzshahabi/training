package com.nicico.training.service;

import com.nicico.training.dto.EvaluationQuestionDTO;
import com.nicico.training.model.EvaluationQuestion;
import com.nicico.training.repository.EvaluationQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class EvaluationQuestionService extends BaseService<EvaluationQuestion, Long, EvaluationQuestionDTO.Info, EvaluationQuestionDTO.Create, EvaluationQuestionDTO.Update, EvaluationQuestionDTO.Delete, EvaluationQuestionDAO> {

    @Autowired
    EvaluationQuestionService(EvaluationQuestionDAO evaluationQuestionDAO) {
        super(new EvaluationQuestion(), evaluationQuestionDAO);
    }

//    @Transactional(readOnly = true)
//    public SearchDTO.SearchRs<ParameterDTO.Config> allConfig(SearchDTO.SearchRq rq) {
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.equals);
//        criteriaRq.setFieldName("description");
//        criteriaRq.setValue("config");
//        rq.setCriteria(criteriaRq);
//
//        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, ParameterDTO.Config.class));
//    }
}
