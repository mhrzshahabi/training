package com.nicico.training.repository;

import com.nicico.training.model.RequestItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RequestItemDAO extends JpaRepository<RequestItem, Long>, JpaSpecificationExecutor<RequestItem> {

    List<RequestItem> findAllByCompetenceReqId(Long id);

    @Query(value = "select ri.id from tbl_request_item ri where ri.f_competence_id=:competenceId", nativeQuery = true)
    List<Long> findAllRequestItemIdsWithCompetenceId(Long competenceId);

    Optional<RequestItem> findByProcessInstanceId(String processInstanceId);

    Optional<RequestItem> findFirstByProcessInstanceId(String processInstanceId);

    @Query(value = "SELECT count(*) FROM tbl_request_item WHERE process_instance_id IS NOT NULL", nativeQuery = true)
    Integer getTotalStartedProcessCount();

    @Query(value = """
            SELECT DISTINCT
                *
            FROM
                (
                    SELECT
                        ri.*,
                        COUNT(
                            CASE
                            WHEN(ricd.c_priority = 'ضروری انتصاب سمت') THEN
                            1
                            END
                        )
                        OVER(PARTITION BY ri.id) app_courses_count,
                        COUNT(
                            CASE
                            WHEN((ricd.c_priority = 'ضروری انتصاب سمت')
                                 AND(ricd.c_process_state = 'تایید اتوماتیک کارشناس اجرا'
                                     OR ricd.c_process_state = 'تایید دستی کارشناس اجرا')) THEN
                            1
                            END
                        )
                        OVER(PARTITION BY ri.id) AS confirmed_count
                    FROM
                        tbl_request_item ri
                        INNER JOIN tbl_request_item_process_detail ripd ON ri.id = ripd.f_request_item_id
                        INNER JOIN tbl_request_item_courses_detail ricd ON ripd.id = ricd.f_request_item_process_detail_id
                    WHERE
                        ri.process_instance_id IS NOT NULL
                        AND ri.c_letter_number_sent IS NULL
                        AND ripd.c_role_name = 'planningChief'
                        AND ricd.c_priority = 'ضروری انتصاب سمت'
                )
            WHERE
                app_courses_count = confirmed_count
            """, nativeQuery = true)
    List<RequestItem> getRequestItemsWithPassedAppointmentCourses();

    @Query(value = """
            SELECT DISTINCT
                ricd.c_course_code,
                ricd.c_course_title,
                ricd.c_priority,
                c.c_code,
                c.c_title_class,
                cs.score,
                cs.scores_state_id
            FROM
                tbl_request_item ri
                INNER JOIN tbl_request_item_process_detail          ripd ON ri.id = ripd.f_request_item_id
                INNER JOIN tbl_request_item_courses_detail          ricd ON ripd.id = ricd.f_request_item_process_detail_id
                INNER JOIN tbl_request_item_course_detail_class_ids ricdci ON ricdci.f_request_item_course_detail = ricd.id
                INNER JOIN tbl_class                                c ON c.id = ricdci.class_id
                INNER JOIN tbl_class_student                        cs ON cs.class_id = c.id
                INNER JOIN tbl_student                              st ON st.id = cs.student_id
            WHERE
                ri.id =:requestItemId
                AND ripd.c_role_name = 'planningChief'
                AND ricd.c_priority = 'ضروری انتصاب سمت'
                AND ri.national_code = st.national_code
            """, nativeQuery = true)
    List<Object> getPassedAppointmentCoursesByRequestItemId(Long requestItemId);

    @Modifying
    @Query(value = "update tbl_request_item SET c_letter_number_sent =:letterNumberSent, c_date_sent =:dateSent WHERE id IN (:requestItemIds)", nativeQuery = true)
    Integer updateLetterNumberAndDateByIds(String letterNumberSent, String dateSent, List<Long> requestItemIds);

}
