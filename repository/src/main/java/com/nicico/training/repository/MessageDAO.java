package com.nicico.training.repository;

import com.nicico.training.model.Message;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface MessageDAO extends BaseDAO<Message, Long> {

    @Modifying
    @Query(value = "delete from tbl_message where id = :id", nativeQuery = true)
    void deleteById(Long id);
}
