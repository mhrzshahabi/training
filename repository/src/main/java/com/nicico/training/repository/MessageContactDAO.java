package com.nicico.training.repository;

import com.nicico.training.model.MessageContact;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

public interface MessageContactDAO extends BaseDAO<MessageContact, Long> {


    @Query(value = "select m.N_COUNT_SEND,mc.N_COUNT_SENT,mc.C_OBJECT_MOBILE,mc.id,m.f_message_class,mc.c_object_type,mc.F_OBJECT from tbl_message m inner join tbl_message_contact mc on m.id=mc.F_MESSAGE_ID where mc.E_DELETED is null and TO_CHAR((mc.C_LAST_SENT_DATE)+m.N_INTERVAL, 'yyyy-mm-dd') = :date_now and m.N_COUNT_SEND > mc.N_COUNT_SENT", nativeQuery = true)
    @Transactional
    List<Object> findAllMessagesForSend(String date_now);

    @Modifying
    @Query(value = "update tbl_message_contact set E_DELETED = 75 where id = :id", nativeQuery = true)
    void deleteById(Long id);

    @Modifying
    @Query(value = "update tbl_message_contact set n_message_id = :returnMessageId, n_count_sent = :countSent, c_last_sent_date = :lastSentDate WHERE id = :id", nativeQuery = true)
    void updateAfterSendMessage(Long returnMessageId, Long countSent, Date lastSentDate, Long id);
}
