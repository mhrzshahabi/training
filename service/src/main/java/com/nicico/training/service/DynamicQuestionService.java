package com.nicico.training.service;

import com.nicico.training.dto.DynamicQuestionDTO;
import com.nicico.training.iservice.IDynamicQuestionService;
import com.nicico.training.model.DynamicQuestion;
import com.nicico.training.repository.DynamicQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class DynamicQuestionService  extends BaseService<DynamicQuestion, Long, DynamicQuestionDTO.Info, DynamicQuestionDTO.Info, DynamicQuestionDTO.Info, DynamicQuestionDTO.Info, DynamicQuestionDAO> implements IDynamicQuestionService {

    @Autowired
    DynamicQuestionService(DynamicQuestionDAO dynamicQuestionDAO) {
        super(new DynamicQuestion(), dynamicQuestionDAO);
    }

    @Override
    public DynamicQuestion getById(Long dynamicQuestionId) {
        return dao.getById(dynamicQuestionId);
    }
}
