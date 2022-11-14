package com.nicico.training.repository;

import com.nicico.training.model.Message;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageDAO extends BaseDAO<Message, Long> {

    @Modifying
    @Query(value = "delete from tbl_message where id = :id", nativeQuery = true)
    void deleteById(Long id);

    @Modifying
    @Query(value = "SELECT\n" +
            "    * FROM tbl_message WHERE f_message_class =:id\n" +
            "    and\n" +
            "    tracking_number is NOT NULL", nativeQuery = true)
    List<Message> getClassSmsHistory(Long id);
}
