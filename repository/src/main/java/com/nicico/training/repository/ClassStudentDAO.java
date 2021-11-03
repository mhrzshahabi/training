package com.nicico.training.repository;


import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.ClassStudentUser;
import com.nicico.training.model.QuestionBank;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.*;

import org.springframework.data.repository.query.Param;

import java.util.List;

import java.util.List;

public interface ClassStudentDAO extends JpaRepository<ClassStudent, Long>, JpaSpecificationExecutor<ClassStudent> {


    @Query(value = "select tbl_course.C_Evaluation from tbl_class_student join tbl_class on tbl_class_student.class_id = tbl_class.Id join tbl_course on tbl_class.F_COURSE = tbl_course.Id where (tbl_class_student.student_id=:studentId and tbl_class_student.class_id=:classId )", nativeQuery = true)
    List<Long> findEvaluationStudentInClass(@Param("studentId") Long studentId, @Param("classId") Long classId);


//    @Query(value = "select Tbl_Student.First_Name , Tbl_Student.Last_Name , Tbl_Student.Emp_No , Tbl_Student.National_Code ,Tbl_Student.Ccp_Affairs , Tbl_Student.Ccp_Unit, Tbl_Course.C_Code as CourseCode, Tbl_Course.C_Title_Fa , Tbl_Class.C_Code as ClassCode, Tbl_Class.C_Start_Date , Tbl_Class.C_End_Date from tbl_class_student  join    tbl_student   on tbl_class_student.student_id = tbl_student.id   join tbl_class  on tbl_class_student.class_id = tbl_class.Id  join  tbl_course on tbl_class.F_COURSE = tbl_course.Id where (tbl_class_student.student_id=:studentId and tbl_class_student.class_id=:classId )", nativeQuery = true)
//    List<Long> findStudentInClass(@Param("studentId") Long studentId, @Param("classId") Long classId);


    @Query(value = "select STUDENT_ID from  tbl_class_student  where CLASS_ID=:classId and SCORES_STATE_ID in (448,405,449,406,404,400,401,403,450)",nativeQuery = true)
     List<Long> getScoreState(@Param("classId") Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "EVALUATION_STATUS_REACTION = :reaction, " +
            "EVALUATION_STATUS_LEARNING = :learning, " +
            "EVALUATION_STATUS_BEHAVIOR = :behavior, " +
            "EVALUATION_STATUS_RESULTS = :results " +
            "where id = :idClassStudent", nativeQuery = true)
    public int setStudentFormIssuance(Long idClassStudent, Integer reaction, Integer learning, Integer behavior, Integer results);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "evaluation_audience_type_id = :AudienceType " +
            "where id = :idClassStudent", nativeQuery = true)
    public int setStudentFormIssuanceAudienceType(Long idClassStudent, Long AudienceType);

    List<ClassStudent> findByStudentId(Long studentId);


    @Modifying
    @Query(value = "update  TBL_CLASS_STUDENT set scores_state_id = 401 ,  failure_reason_id = null where CLASS_ID =:id ", nativeQuery = true)
    void setTotalStudentWithOutScore(@Param("id") Long id);

    Optional<ClassStudent> findByTclassIdAndStudentId(Long tclassId, Long studentId);

//    Optional<ClassStudent> findByTclassIdAndStudentId(Long tclassId, Long studentId);

    List<ClassStudent> findByTclassId(Long classId);
    List<ClassStudent> findByTclassIdAndPreTestScoreIsNull(Long id);

    ClassStudent getClassStudentById(Long classStudentId);

    Integer countClassStudentsByTclassId(Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set TBL_CLASS_STUDENT.PRESENCE_TYPE_ID =:presenceTypeId where id =:id", nativeQuery = true)
    public void setPeresenceTypeId(Long presenceTypeId, Long id);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "evaluation_audience_id = :AudienceId " +
            "where id = :idClassStudent", nativeQuery = true)
    public int setStudentFormIssuanceAudienceId(Long idClassStudent, Long AudienceId);

    @Query(value = "select mc.c_object_mobile,count(*) as cnt from tbl_message_contact mc inner join tbl_message m on m.id=mc.f_message_id where mc.n_count_sent>0 and m.f_message_class=:classId and m.f_message_user_type=679 group by mc.c_object_mobile", nativeQuery = true)
    List<Object> getStatusSendMessageStudents(Long classId);

    List<ClassStudent> findAllByTclassId(long classId);


    @Query(value = "SELECT tbl_class.c_start_date,VIEW_CONTACT_INFO.MOBILE_FOR_SMS AS MOBILE,tbl_class_student.id,tbl_class_student.class_id FROM tbl_class_student INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id " +
            " INNER JOIN VIEW_CONTACT_INFO ON VIEW_CONTACT_INFO.ID = TBL_STUDENT.F_CONTACT_INFO WHERE tbl_class.c_start_date > :s1 AND  tbl_class.c_start_date < :s2", nativeQuery = true)
    List<Object> findAllUserMobiles(String s1, String s2);


    @Query(value = "SELECT\n" +

            "     tbl_class_student.id\n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "WHERE\n" +
            "    tbl_class_student.class_id = :classId \n" +
            "    AND national_code = :nationalCode ", nativeQuery = true)
    List<Long> getClassStudentIdByClassCodeAndNationalCode(@Param("classId") Long classId, @Param("nationalCode") String nationalCode);


    @Query(value = "\n" +
            "\n" +
            " \n" +
            "\n" +
            "SELECT * FROM\n" +
            "(\n" +
            "    SELECT a.*, rownum r__\n" +
            "    FROM\n" +
            "    (\n" +
            "\n" +
            "SELECT DISTINCT\n" +
            "    tbl_teacher.c_teacher_code,\n" +
            "    tbl_class.id                      AS classid,\n" +
            "    tbl_teacher.id                    AS teacherid,\n" +
            "    tbl_class.c_code                  AS code,\n" +
            "    tbl_class.c_title_class           AS title,\n" +
            "    tbl_course.c_title_fa             AS name,\n" +
            "    tbl_class.n_max_capacity          AS capacity,\n" +
            "    tbl_class.n_h_duration            AS duration,\n" +
            "    view_complex.c_title AS location,\n" +
            "    CASE\n" +
            "        WHEN tbl_class.c_status = 1 THEN\n" +
            "            4\n" +
            "        WHEN tbl_class.c_status = 2 THEN\n" +
            "            1\n" +
            "        WHEN tbl_class.c_status = 3 THEN\n" +
            "            2\n" +
            "        WHEN tbl_class.c_status = 4 THEN\n" +
            "            3\n" +
            "        WHEN tbl_class.c_status = 5 THEN\n" +
            "            2\n" +
            "    END                               AS coursestatus,\n" +
            "    CASE\n" +
            "        WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "            1\n" +
            "        ELSE\n" +
            "            2\n" +
            "    END                               AS classtype,\n" +
            "    tbl_class.c_start_date            AS startdate,\n" +
            "    tbl_class.c_end_date              AS finishdate,\n" +
            "    concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor \n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "    INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "    LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "    INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            " \n" +
            "WHERE\n" +
            "    tbl_teacher.c_teacher_code = :nationalCode \n" +
            "        ORDER BY  classid Desc) a\n" +
            "    WHERE rownum < ((:page * :sizee) + 1 )\n" +
            ")\n" +
            "WHERE r__ >= (((:page-1) * :sizee) + 1)\n",nativeQuery = true)
    List<Object> findAllClassByTeacher(String nationalCode, int page,int sizee);



    @Query(value = "\n" +
            "SELECT DISTINCT\n" +
            "    tbl_teacher.c_teacher_code,\n" +
            "    tbl_class.id                      AS classid,\n" +
            "    tbl_teacher.id                    AS teacherid,\n" +
            "    tbl_class.c_code                  AS code,\n" +
            "    tbl_class.c_title_class           AS title,\n" +
            "    tbl_course.c_title_fa             AS name,\n" +
            "    tbl_class.n_max_capacity          AS capacity,\n" +
            "    tbl_class.n_h_duration            AS duration,\n" +
            "    view_complex.c_title AS location,\n" +
            "    CASE\n" +
            "        WHEN tbl_class.c_status = 1 THEN\n" +
            "            4\n" +
            "        WHEN tbl_class.c_status = 2 THEN\n" +
            "            1\n" +
            "        WHEN tbl_class.c_status = 3 THEN\n" +
            "            2\n" +
            "        WHEN tbl_class.c_status = 4 THEN\n" +
            "            3\n" +
            "        WHEN tbl_class.c_status = 5 THEN\n" +
            "            2\n" +
            "    END                               AS coursestatus,\n" +
            "    CASE\n" +
            "        WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "            1\n" +
            "        ELSE\n" +
            "            2\n" +
            "    END                               AS classtype,\n" +
            "    tbl_class.c_start_date            AS startdate,\n" +
            "    tbl_class.c_end_date              AS finishdate,\n" +
            "    concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor \n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "    INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "    LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "    INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            " \n" +
            "WHERE\n" +
            "    tbl_teacher.c_teacher_code = :nationalCode \n" +
            "        ORDER BY  classid Desc",nativeQuery = true)
    List<Object> findAllCountClassByTeacher(String nationalCode);

}
