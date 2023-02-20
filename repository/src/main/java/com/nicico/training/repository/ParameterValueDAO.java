package com.nicico.training.repository;

import com.nicico.training.model.ParameterValue;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ParameterValueDAO extends BaseDAO<ParameterValue, Long> {

    ParameterValue findByCode(String code);

    ParameterValue findFirstById(Long id);

    List<ParameterValue> findAllByParameterId(long id);

    ParameterValue findByTitle(String title);

    Optional<ParameterValue> findFirstByValue(String title);

    List< ParameterValue> findAllByTitle(String title);

    @Query(value = "SELECT * FROM tbl_parameter_value  where f_parameter_id = 481  And c_code like :type AND c_code like :target",nativeQuery = true)
    List<ParameterValue> findMessagesByCode(String type, String target);

    ParameterValue findFirstByDescription(String des);

    @Query(value = """
            SELECT
                *
            FROM
                tbl_parameter_value
                INNER JOIN tbl_parameter ON tbl_parameter_value.f_parameter_id = tbl_parameter.id
            WHERE
                tbl_parameter.c_code IN (:codes)
            """, nativeQuery = true)
    List<ParameterValue> findAllByParameterCodes(@Param("codes") List<String> parameterCodes);
}
