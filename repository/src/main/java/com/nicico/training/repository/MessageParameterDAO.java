package com.nicico.training.repository;

import com.nicico.training.model.MessageParameter;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageParameterDAO extends BaseDAO<MessageParameter, Long> {

    @Query(value = "SELECT * FROM tbl_message_parameter WHERE F_MESSAGE_CONTACT_ID = :messageContactId", nativeQuery = true)
    List<MessageParameter> findByMessageContactId(Long messageContactId);
}
