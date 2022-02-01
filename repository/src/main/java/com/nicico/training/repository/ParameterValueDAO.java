package com.nicico.training.repository;

import com.nicico.training.model.ParameterValue;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ParameterValueDAO extends BaseDAO<ParameterValue, Long> {

    ParameterValue findByCode(String code);

    ParameterValue findFirstById(Long id);

    List<ParameterValue> findAllByParameterId(long id);

    ParameterValue findByTitle(String title);

    List< ParameterValue> findAllByTitle(String title);

    @Query(value = "SELECT * FROM tbl_parameter_value  where f_parameter_id = 481  And c_code like :type AND c_code like :target",nativeQuery = true)
    List<ParameterValue> findMessagesByCode(String type, String target);

    ParameterValue findFirstByDescription(String des);
}
