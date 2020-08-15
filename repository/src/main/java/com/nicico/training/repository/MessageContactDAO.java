package com.nicico.training.repository;

import com.nicico.training.model.MessageContact;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

public interface MessageContactDAO extends BaseDAO<MessageContact, Long> {


    @Query(value = "select m.N_COUNT_SEND,mc.N_COUNT_SENT,mc.C_CONTEXT_TEXT,mc.C_CONTEXT_HTML,mc.C_OBJECT_MOBILE,mc.id from tbl_message m inner join tbl_message_contact mc on m.id=mc.F_MESSAGE_ID where TO_CHAR((mc.C_LAST_SENT_DATE)+m.N_INTERVAL, 'yyyy/mm/dd') = :date_now and m.N_COUNT_SEND > mc.N_COUNT_SENT", nativeQuery = true)
    @Transactional
    List<Object> findAllMessagesForSend(String date_now);
}
