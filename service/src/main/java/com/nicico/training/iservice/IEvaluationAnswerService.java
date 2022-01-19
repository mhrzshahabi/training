package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.EvaluationAnswerAudit;

import java.util.List;

public interface IEvaluationAnswerService {

    EvaluationAnswerDTO.Info get(Long id);

    List<EvaluationAnswerDTO.Info> list();

    EvaluationAnswerDTO.Info create(EvaluationAnswerDTO.Create request);

    EvaluationAnswerDTO.Info update(Long id, EvaluationAnswerDTO.Update request);

    void delete(Long id);

    void delete(EvaluationAnswerDTO.Delete request);

    SearchDTO.SearchRs<EvaluationAnswerDTO.Info> search(SearchDTO.SearchRq request);

    List<EvaluationAnswer> getAllByEvaluationId(long id);

    List<EvaluationAnswerAudit> getAuditData(Long evaluationId);
}
