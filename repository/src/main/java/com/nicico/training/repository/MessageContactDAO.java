package com.nicico.training.repository;

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
            "    (\n" +
            "        CASE\n" +
            "            WHEN tbl_message_contact.c_object_type = 'ClassStudent' THEN\n" +
            "                'فراگیر'\n" +
            "            ELSE\n" +
            "                'استاد'\n" +
            "        END\n" +
            "    )                                                                                 user_type,\n" +
            "    (\n" +
            "        CASE\n" +
            "            WHEN tbl_message_contact.c_object_type = 'ClassStudent' THEN\n" +
            "                tbl_student.first_name\n" +
            "            ELSE\n" +
            "                tbl_personal_info.c_first_name_fa\n" +
            "        END\n" +
            "    )                                                                                 user_name,\n" +
            "    (\n" +
            "        CASE\n" +
            "            WHEN tbl_message_contact.c_object_type = 'ClassStudent' THEN\n" +
            "                tbl_student.last_name\n" +
            "            ELSE\n" +
            "                tbl_personal_info.c_last_name_fa\n" +
            "        END\n" +
            "    )                                                                                 user_family,\n" +
            "    (\n" +
            "        CASE\n" +
            "            WHEN tbl_message_contact.c_object_type = 'ClassStudent' THEN\n" +
            "                tbl_student.national_code\n" +
            "            ELSE\n" +
            "                tbl_personal_info.c_national_code\n" +
            "        END\n" +
            "    )                                                                                 national_code,\n" +
            "    tbl_message_contact.tracking_number,\n" +
            "    tbl_message_contact.id,\n" +
            "    tbl_message_contact.c_created_by,\n" +
            "    tbl_message_contact.c_object_mobile,\n" +
            "    to_char(tbl_message_contact.d_created_date, 'yyyy/mm/dd', 'nls_calendar=persian') AS create_date,\n" +
            "    tbl_parameter_value.c_title\n" +
            "FROM\n" +
            "         tbl_message_contact\n" +
            "    INNER JOIN tbl_message message ON tbl_message_contact.f_message_id = message.id\n" +
            "    LEFT JOIN tbl_class_student ON tbl_message_contact.f_object = tbl_class_student.id\n" +
            "    LEFT JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    LEFT JOIN tbl_teacher ON tbl_message_contact.f_object = tbl_teacher.id\n" +
            "    LEFT JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "    LEFT JOIN tbl_parameter_value ON message.c_pid = tbl_parameter_value.c_value\n" +
            "WHERE\n" +
            "    tbl_message_contact.tracking_number IS NOT NULL\n" +
            "    AND message.f_message_class = :id", nativeQuery = true)
    List<?> getClassSmsHistory(Long id);
}
