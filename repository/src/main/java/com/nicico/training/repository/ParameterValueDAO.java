package com.nicico.training.repository;

import com.nicico.training.model.ParameterValue;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ParameterValueDAO extends BaseDAO<ParameterValue, Long> {
    ParameterValue findByCode(String code);
    ParameterValue findFirstById(Long id);
    }
