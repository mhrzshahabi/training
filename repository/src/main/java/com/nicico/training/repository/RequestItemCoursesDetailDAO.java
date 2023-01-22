package com.nicico.training.repository;

import com.nicico.training.model.RequestItemCoursesDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public interface RequestItemCoursesDetailDAO extends JpaRepository<RequestItemCoursesDetail, Long>, JpaSpecificationExecutor<RequestItemCoursesDetail> {

    List<RequestItemCoursesDetail> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId);

    @Query(value = "SELECT * FROM tbl_request_item_courses_detail WHERE f_request_item_process_detail_id IN (:requestItemProcessDetailIds)",nativeQuery = true)
    List<RequestItemCoursesDetail> findAllByRequestItemProcessDetailIds(List<Long> requestItemProcessDetailIds);

    @Query(value = """
        SELECT
            tbl_request_item_courses_detail.id,
            tbl_request_item_courses_detail.c_task_id_per_course,
            tbl_request_item.process_instance_id,
            tbl_request_item_courses_detail.c_course_code,
            tbl_request_item.national_code
        FROM
                 tbl_request_item_courses_detail
            INNER JOIN tbl_request_item_process_detail ON tbl_request_item_courses_detail.f_request_item_process_detail_id = tbl_request_item_process_detail.
            id
            INNER JOIN tbl_request_item ON tbl_request_item_process_detail.f_request_item_id = tbl_request_item.id
            INNER JOIN tbl_course ON tbl_request_item_courses_detail.c_course_code = tbl_course.c_code
            INNER JOIN tbl_class ON tbl_course.id = tbl_class.f_course
            INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id
            INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
        WHERE
                tbl_request_item.national_code = tbl_student.national_code
            AND tbl_class.c_status IN ( 3, 5 )
            AND tbl_class_student.scores_state_id IN ( 400, 401 )
            AND tbl_request_item_courses_detail.c_process_state = 'بررسی کارشناس اجرا'
            AND tbl_request_item_courses_detail.c_task_id_per_course IS NOT NULL 
        """,nativeQuery = true)
    List<?> getCompleteTasks();


    @Query(value = """
         SELECT
             tbl_class.id
             FROM
                  tbl_class_student
             INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
             INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
             INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
         WHERE
                 tbl_student.national_code = :userNationalCode
             AND tbl_class_student.scores_state_id IN ( 400, 401 )
             AND tbl_class.c_status IN ( 3, 5 )
             AND tbl_course.c_code = :courseCode

        """,nativeQuery = true)
    Set<Long> getClassIds(@Param("courseCode") String courseCode, @Param("userNationalCode") String userNationalCode);

    @Query(value = """
SELECT
    tbl_request_item_course_detail_class_ids.f_request_item_course_detail
FROM
         tbl_request_item_course_detail_class_ids
    INNER JOIN tbl_request_item_courses_detail ON tbl_request_item_course_detail_class_ids.f_request_item_course_detail =
    tbl_request_item_courses_detail.id
    INNER JOIN tbl_request_item_process_detail ON tbl_request_item_courses_detail.f_request_item_process_detail_id =
    tbl_request_item_process_detail.id
    INNER JOIN tbl_request_item ON tbl_request_item_process_detail.f_request_item_id =\s
    tbl_request_item.id
WHERE
    tbl_request_item_course_detail_class_ids.class_id = :classId
    and
    tbl_request_item.national_code = :userNationalCode
        """,nativeQuery = true)
    Set<Long> getByNationalCodeAndClassId(@Param("classId") Long classId, @Param("userNationalCode") String userNationalCode);
}
