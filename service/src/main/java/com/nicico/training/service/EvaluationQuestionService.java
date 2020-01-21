package com.nicico.training.service;

import com.nicico.training.dto.EvaluationQuestionDTO;
import com.nicico.training.model.EvaluationIndex;
import com.nicico.training.model.EvaluationQuestion;
import com.nicico.training.repository.EvaluationQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
public class EvaluationQuestionService extends BaseService<EvaluationQuestion, Long, EvaluationQuestionDTO.Info, EvaluationQuestionDTO.Create, EvaluationQuestionDTO.Update, EvaluationQuestionDTO.Delete, EvaluationQuestionDAO> {

    private EvaluationIndexService evaluationIndexService;

    @Autowired
    EvaluationQuestionService(EvaluationQuestionDAO evaluationQuestionDAO, EvaluationIndexService evaluationIndexService) {
        super(new EvaluationQuestion(), evaluationQuestionDAO);
        this.evaluationIndexService = evaluationIndexService;
    }

    @Transactional
    public EvaluationQuestionDTO.Info create(EvaluationQuestionDTO.Create rq, List<Long> indexIds) {
        final EvaluationQuestion entity = modelMapper.map(rq, EvaluationQuestion.class);
        entity.setEvaluationIndices(getIndices(indexIds));
        return modelMapper.map(dao.save(entity), EvaluationQuestionDTO.Info.class);
    }

    @Transactional
    public EvaluationQuestionDTO.Info update(Long id, EvaluationQuestionDTO.Update rq, List<Long> indexIds) {
        final EvaluationQuestion currentEntity = get(id);
        modelMapper.map(currentEntity, entity);
        modelMapper.map(rq, entity);
        entity.setEvaluationIndices(getIndices(indexIds));
        return modelMapper.map(dao.save(entity), EvaluationQuestionDTO.Info.class);
    }

    private List<EvaluationIndex> getIndices(List<Long> indexIds) {
        if (indexIds == null || indexIds.size() == 0)
            return null;
        return evaluationIndexService.getListByIds(indexIds);
    }


}
