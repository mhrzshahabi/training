package com.nicico.training.repository;

import com.nicico.training.model.Message;
import com.nicico.training.model.MessageContact;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface MessageContactDAO extends BaseDAO<MessageContact, Long> {

    @Query(value = "select m.N_COUNT_SEND,mc.N_COUNT_SENT,mc.C_OBJECT_MOBILE,mc.id,m.f_message_class,mc.c_object_type,mc.F_OBJECT,m.C_PID from tbl_message m inner join tbl_message_contact mc on m.id=mc.F_MESSAGE_ID where mc.E_DELETED is null and TO_CHAR((mc.C_LAST_SENT_DATE)+m.N_INTERVAL, 'yyyy-mm-dd') = :date_now and m.N_COUNT_SEND > mc.N_COUNT_SENT", nativeQuery = true)
    @Transactional
    List<Object> findAllMessagesForSend(String date_now);

    @Modifying
    @Query(value = "update tbl_message_contact set E_DELETED = 75 where id = :id", nativeQuery = true)
    void deleteById(Long id);

    @Modifying
    @Query(value = "update tbl_message_contact set n_count_sent = :countSent, c_last_sent_date = :lastSentDate WHERE id = :id", nativeQuery = true)
    void updateAfterSendMessage(Long countSent, Date lastSentDate, Long id);

    @Modifying
    @Query(value = "delete from tbl_message_contact where id = :id", nativeQuery = true)
    void deleteByOneId(Long id);

    List<MessageContact> findAllByMessageId(Long id);

    Optional<MessageContact> findFirstById(Long messageId);

     @Modifying
    @Query(value = "SELECT\n" +
            "    *\n" +
            "FROM\n" +
            "         tbl_message_contact\n" +
            "    INNER JOIN tbl_message message ON tbl_message_contact.f_message_id = message.id\n" +
            "     WHERE\n" +
            "     message.f_message_class = :id \n" +
            "  and   tracking_number is NOT NULL", nativeQuery = true)
    List<MessageContact> getClassSmsHistory(Long id);
}
