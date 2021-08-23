package com.nicico.training.repository;

import com.nicico.training.model.ParameterValue;

import java.util.List;

public interface ParameterValueDAO extends BaseDAO<ParameterValue, Long> {

    ParameterValue findByCode(String code);
    ParameterValue findFirstById(Long id);
    List<ParameterValue> findAllByParameterId(long id);
    ParameterValue findByTitle(String title);
}
