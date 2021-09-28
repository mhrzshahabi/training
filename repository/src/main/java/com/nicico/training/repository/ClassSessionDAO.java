package com.nicico.training.repository;

import com.nicico.training.model.ClassSession;
import com.nicico.training.model.IClassSessionDTO;
import com.nicico.training.model.ICourseSCRV;
import io.swagger.models.auth.In;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

////*****rastegari 9809*****

@Repository
public interface ClassSessionDAO extends JpaRepository<ClassSession, Long>, JpaSpecificationExecutor<ClassSession> {

    List<ClassSession> findByClassId(Long classId);

    List<IClassSessionDTO> findSessionDateDistinctByClassId(Long classId);

    List<ClassSession> findByClassIdAndSessionDate(Long classId, String sessionDate);

    @Query(value = "SELECT DISTINCT p.C_SESSION_DATE,p.C_DAY_NAME FROM TBL_SESSION p WHERE p.F_CLASS_ID = ?1", nativeQuery = true)
    List<IClassSessionDTO> findSessionDate(Long classId);

    boolean existsByClassIdAndSessionDateAndSessionStartHourAndSessionEndHour(Long classId, String sessionDate, String sessionStartHour, String sessionEndHour);

    boolean existsByClassIdAndSessionDateAndSessionStartHourAndSessionEndHourAndIdNot(Long classId, String sessionDate, String sessionStartHour, String sessionEndHour, Long id);

    @Query(value = "select count(*) from tbl_session where f_class_id=:classId and c_session_date=:sessionDate and ((c_session_start_hour<=:startHour and  c_session_end_hour>:startHour) or (c_session_start_hour<:endHour and  c_session_end_hour>=:endHour)) and id<>:id", nativeQuery = true)
    int checkHour(Long classId,String sessionDate,String startHour,String endHour,Long id);

    List<ClassSession> findBySessionDateBetween(String start, String end);

    ClassSession getClassSessionById(Long sessionId);

    List<ClassSession> findBySessionDateAndClassId(String sessionDate,Long classId);

    Boolean existsByClassId(Long classId);

    @Modifying
    @Query(value = "DELETE FROM TBL_SESSION WHERE ID IN (:ids)",nativeQuery = true)
    Integer deleteAllById(List<Long> ids);

    @Query(value = "SELECT\n" +
            "    *\n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT\n" +
            "            tbl_student.national_code AS student,\n" +
            "            tbl_class_student.class_id\n" +
            "        FROM\n" +
            "                 tbl_class_student\n" +
            "            INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    ) tb1\n" +
            "    INNER JOIN (\n" +
            "        SELECT\n" +
            "            tbl_session.f_class_id        AS id,\n" +
            "            tbl_session.c_session_date    AS startt,\n" +
            "            tbl_session.c_session_end_hour,\n" +
            "            tbl_session.c_session_start_hour,\n" +
            "            devtraining.tbl_training_place.c_title_fa,\n" +
            "            devtraining.tbl_class.c_title_class\n" +
            "        FROM\n" +
            "                 tbl_session\n" +
            "            INNER JOIN devtraining.tbl_training_place ON tbl_session.f_training_place_id = devtraining.tbl_training_place.id\n" +
            "            INNER JOIN devtraining.tbl_class ON tbl_session.f_class_id = devtraining.tbl_class.id\n" +
            "    ) tb2 ON tb1.class_id = tb2.id\n" +
            "WHERE tb1.student=:nationalCode AND startt >=:startDate AND  startt <=:endDate", nativeQuery = true)
    List<Object> getEvents(String nationalCode, String startDate, String endDate);
}
