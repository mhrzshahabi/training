package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public interface StudentDAO extends JpaRepository<Student, Long>, JpaSpecificationExecutor<Student> {

    @Query(value = "select Tbl_Class_Student.F_Class from tbl_student join Tbl_Class_Student  on tbl_student.id = Tbl_Class_Student.F_Student   where (tbl_student.nationalcode=:nationalCode and Tbl_Class_Student.f.class=:classId )", nativeQuery = true)
    List<Long> findOneByNationalCodeInClass(@Param("nationalCode") String nationalCode, @Param("classId") Long classId);

    Optional<Student> findByPersonnelNo(@Param("personnelNo") String personnelNo);

    List<Student> findByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName);

    List<Student> findByNationalCode(String nationalCode);

    @Query(value = "SELECT\n" +
            "    tbl_evaluation.f_evaluator_id,\n" +
            "    tbl_student.national_code,\n" +
            "    tbl_class_student.class_id\n" +
            "FROM\n" +
            "         tbl_evaluation\n" +
            "    INNER JOIN tbl_class_student ON tbl_evaluation.f_evaluator_id = tbl_class_student.id\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    where tbl_student.national_code =:nationalCode and tbl_class_student.class_id =:classId and tbl_evaluation.id =:sourceId", nativeQuery = true)
    Long findOneByNationalCode(@Param("nationalCode") String nationalCode, @Param("classId") Long classId,@Param("sourceId") Long sourceId);


    /**
     * @param sessionId
     * @return a map which contains list of students of a sesssion with their attendance info
     */
    @Query(value = "select " +
            "       CONCAT(CONCAT(student.FIRST_NAME, ' '), student.LAST_NAME) as fullName, " +
            "       student.NATIONAL_CODE                                      as nationalCode, " +
            "       student.ID                                                 as studentId, " +
            "       attendance.C_STATE                                         as attendanceStateId " +
            "from TBL_STUDENT student " +
            "         inner join TBL_ATTENDANCE attendance on student.ID = attendance.F_STUDENT " +
            "where attendance.F_SESSION =:sessionId", nativeQuery = true)
    List<Map<String, Object>> sessionStudentsBySessionId(@Param("sessionId") Long sessionId);

    /**
     * returns list of student of a class by session Id
     *
     * @param sessionId
     * @return list of students List<Student>
     */
    @Query(value = "select student.* " +
            "from TBL_STUDENT student " +
            "         inner join TBL_CLASS_STUDENT cs on student.ID = cs.STUDENT_ID " +
            "         inner join TBL_CLASS class on cs.CLASS_ID = class.ID " +
            "         inner join TBL_SESSION session1 on class.ID = session1.F_CLASS_ID " +
            "where session1.ID = :sessionId ", nativeQuery = true)
    List<Student> getSessionStudents(@Param("sessionId") Long sessionId);

    @Query(value = "select * from TBL_STUDENT where f_contact_info = :id  and id = :parentId", nativeQuery = true)
    Optional<Student> findByContactInfoId(Long id, Long parentId);

    @Query(value = "select * from TBL_STUDENT where f_contact_info IN(:ids)", nativeQuery = true)
    List<Student> findAllByContactInfoIds(List<Long> ids);

    /**
     * it returns a student's attendance list in a class for an Api for Els
     *
     * @param classCode
     * @param nationalCode
     * @return
     */
    @Query(value = "select tempSession.C_SESSION_DATE       as SESSION_DATE, " +
            "       tempSession.C_DAY_NAME           as DAY_NAME, " +
            "       tempSession.C_SESSION_START_HOUR as SESSION_START_HOUR, " +
            "       tempSession.C_SESSION_END_HOUR   as SESSION_END_HOUR, " +
            "       nvl(attendance.C_STATE, 0)       as ATTENDANCE_STATE " +
            "from TBL_SESSION tempSession " +
            "         inner join TBL_CLASS tClass on tClass.ID = tempSession.F_CLASS_ID " +
            "         left join TBL_ATTENDANCE attendance on tempSession.ID = attendance.F_SESSION " +
            "         inner join TBL_CLASS_STUDENT classStudent on tClass.ID = classStudent.CLASS_ID " +
            "         inner join TBL_STUDENT student on classStudent.STUDENT_ID = student.ID " +
            "where tClass.C_CODE = :classCode " +
            "  and student.NATIONAL_CODE = :nationalCode " +
            "order by tempSession.C_SESSION_DATE, tempSession.C_SESSION_START_HOUR ", nativeQuery = true)
    List<Map<String, Object>> getStudentAttendanceList(@Param("classCode") String classCode, @Param("nationalCode") String nationalCode);


    @Query(value = "SELECT\n" +
            "    tc.c_code                     AS " +"\"examCode\""+
            " ,   tc.c_title_class              AS "+ "\"examName\""+
            " ,   ttq.c_date                    AS " +"\"startDate\""+
            " ,   ttq.c_time                    AS " +"\"startTime\""+
            " ,   ttq.c_end_date                AS " +"\"endDate\""+
            " ,   ttq.c_end_time                AS " +"\"endTime\""+
            " ,   ttq.n_duration                AS " +"\"duration\""+
            " ,   ttq.b_is_pre_test_question    AS " +"\"isPreTest\""+
            " ,   ttq.id    AS " +"\"examId\""+
            "FROM\n" +
            "         tbl_student ts\n" +
            "    INNER JOIN tbl_class_student  tcs ON ts.id = tcs.student_id\n" +
            "    INNER JOIN tbl_class          tc ON tc.id = tcs.class_id\n" +
            "    INNER JOIN tbl_test_question  ttq ON ttq.f_class = tc.id\n" +
            "    INNER JOIN tbl_course         tc2 ON tc.f_course = tc2.id\n" +
            "WHERE\n" +
            "    ts.national_code = :nationalCode AND (ttq.c_end_date < :endDate OR (ttq.c_end_date = :endDate AND ttq.c_end_time < :endTime)) AND ttq.b_is_pre_test_question = 0 ", nativeQuery = true)
    List<Map<String, Object>> findAllExpiredExamsByNationalCode(@Param("nationalCode") String nationalCode, @Param("endDate") String endDate, @Param("endTime") String endTime);


    @Query(value = "SELECT\n" +
            "    tc.c_code                     AS " +"\"examCode\""+
            " ,   tc.c_title_class              AS "+ "\"examName\""+
            " ,   ttq.c_date                    AS " +"\"startDate\""+
            " ,   ttq.c_time                    AS " +"\"startTime\""+
            " ,   ttq.c_end_date                AS " +"\"endDate\""+
            " ,   ttq.c_end_time                AS " +"\"endTime\""+
            " ,   ttq.n_duration                AS " +"\"duration\""+
            " ,   ttq.b_is_pre_test_question    AS " +"\"isPreTest\""+
            " ,   ttq.id    AS " +"\"examId\""+
            "FROM\n" +
            "         tbl_student ts\n" +
            "    INNER JOIN tbl_class_student  tcs ON ts.id = tcs.student_id\n" +
            "    INNER JOIN tbl_class          tc ON tc.id = tcs.class_id\n" +
            "    INNER JOIN tbl_test_question  ttq ON ttq.f_class = tc.id\n" +
            "    INNER JOIN tbl_course         tc2 ON tc.f_course = tc2.id\n" +
            "WHERE\n" +
            "    ts.national_code = :nationalCode AND (ttq.c_end_date > :endDate OR ttq.b_is_pre_test_question = 1)", nativeQuery = true)
    List<Map<String, Object>> findAllNextExamsByNationalCode(@Param("nationalCode") String nationalCode, @Param("endDate") String endDate);


    @Query(value = "SELECT\n" +
            "    tc.c_code                     AS " +"\"examCode\""+
            " ,   tc.c_title_class              AS "+ "\"examName\""+
            " ,   ttq.c_date                    AS " +"\"startDate\""+
            " ,   ttq.c_time                    AS " +"\"startTime\""+
            " ,   ttq.c_end_date                AS " +"\"endDate\""+
            " ,   ttq.c_end_time                AS " +"\"endTime\""+
            " ,   ttq.n_duration                AS " +"\"duration\""+
            " ,   ttq.b_is_pre_test_question    AS " +"\"isPreTest\""+
            " ,   ttq.id    AS " +"\"examId\""+
            "FROM\n" +
            "         tbl_student ts\n" +
            "    INNER JOIN tbl_class_student  tcs ON ts.id = tcs.student_id\n" +
            "    INNER JOIN tbl_class          tc ON tc.id = tcs.class_id\n" +
            "    INNER JOIN tbl_test_question  ttq ON ttq.f_class = tc.id\n" +
            "    INNER JOIN tbl_course         tc2 ON tc.f_course = tc2.id\n" +
            "WHERE\n" +
            "    ts.national_code = :nationalCode AND (ttq.c_date = :startDate OR ttq.b_is_pre_test_question = 1)", nativeQuery = true)
    List<Map<String, Object>> findAllThisDateExamsByNationalCode(@Param("nationalCode") String nationalCode, @Param("startDate") String startDate);


    @Query(value = "SELECT\n" +
            "    *\n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT\n" +
            "          \n" +
            "            DISTINCT *\n" +
            "        FROM\n" +
            "            tbl_student\n" +
            "            WHERE deleted is null\n" +
            "            AND\n" +
            "            tbl_student.company_name is not NULL\n" +
            "        ORDER BY\n" +
            "            id DESC\n" +
            "            \n" +
            "    )\n" +
            "WHERE\n" +
            "    ROWNUM <= 1000", nativeQuery = true)
    List<Student> getTestStudentList();

    @Query(value = "SELECT * FROM TBL_STUDENT st WHERE st.ACTIVE = 1 and st.DELETED is null ", nativeQuery = true)
    Page<Student> findAllByDeletedIsNull(Pageable pageable);

    @Query(value = "SELECT ST.* " +
            "FROM TBL_STUDENT ST " +
            "         INNER JOIN TBL_CLASS_STUDENT TCS ON ST.ID = TCS.STUDENT_ID " +
            "         INNER JOIN TBL_CLASS TC ON TCS.CLASS_ID = TC.ID " +
            "WHERE TC.C_CODE = :classCode ", nativeQuery = true)
    List<Student> getAllStudentsOfClassByClassCode(@Param("classCode") String classCode);

}
