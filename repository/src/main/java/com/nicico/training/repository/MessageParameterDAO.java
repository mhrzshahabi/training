/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/19
 * Last Modified: 2020/09/14
 */

package com.nicico.training.repository;

import com.nicico.training.model.Message;
import com.nicico.training.model.MessageParameter;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageParameterDAO extends BaseDAO<MessageParameter, Long> {

    @Query(value = "SELECT * FROM tbl_message_parameter WHERE F_MESSAGE_CONTACT_ID = :messageContactId", nativeQuery = true)
    List<MessageParameter> findByMessageContactId(Long messageContactId);

    @Modifying
    @Query(value = "delete from tbl_message_parameter where f_message_contact_id = :id", nativeQuery = true)
    void deleteByMCId(Long id);
}
