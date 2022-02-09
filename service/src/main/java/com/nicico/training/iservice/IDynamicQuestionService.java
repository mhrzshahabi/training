package com.nicico.training.iservice;

import com.nicico.training.model.DynamicQuestion;

public interface IDynamicQuestionService {
    DynamicQuestion getById(Long dynamicQuestionId);
}
