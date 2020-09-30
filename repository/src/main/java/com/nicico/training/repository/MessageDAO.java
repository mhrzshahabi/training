package com.nicico.training.repository;

import com.nicico.training.model.Message;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageDAO extends BaseDAO<Message, Long> {

    @Modifying
    @Query(value = "delete from tbl_message_parameter_value where f_message_id = :id", nativeQuery = true)
    void deleteSendWaysById(Long id);

    @Modifying
    @Query(value = "delete from tbl_message where id = :id", nativeQuery = true)
    void deleteById(Long id);

}
