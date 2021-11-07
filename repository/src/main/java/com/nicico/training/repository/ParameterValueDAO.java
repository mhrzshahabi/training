package com.nicico.training.repository;

import com.nicico.training.model.ParameterValue;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ParameterValueDAO extends BaseDAO<ParameterValue, Long> {

    ParameterValue findByCode(String code);
    ParameterValue findFirstById(Long id);
    List<ParameterValue> findAllByParameterId(long id);
    ParameterValue findByTitle(String title);

    @Query(value = "SELECT\n" +
            "    * FROM tbl_parameter_value\n" +
            "     where f_parameter_id = 481",nativeQuery = true)
    List<ParameterValue> findMessagesByCode();
}
