package com.nicico.training.repository;

import com.nicico.training.model.Parameter;
import org.springframework.data.repository.query.Param;

import javax.transaction.Transactional;
import java.util.Optional;

public interface ParameterDAO extends BaseDAO<Parameter, Long> {

    @Transactional
    Optional<Parameter> findByCode(@Param("code") String code);
}
