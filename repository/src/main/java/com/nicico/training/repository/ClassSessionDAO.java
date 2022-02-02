package com.nicico.training.repository;

import com.nicico.training.model.ClassSession;
import com.nicico.training.model.IClassSessionDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClassSessionDAO extends JpaRepository<ClassSession, Long>, JpaSpecificationExecutor<ClassSession> {

    List<ClassSession> findByClassId(Long classId);

    List<IClassSessionDTO> findSessionDateDistinctByClassId(Long classId);

    List<ClassSession> findByClassIdAndSessionDate(Long classId, String sessionDate);

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

    @Query(value = "SELECT * FROM ( SELECT tbl_student.national_code AS student, tbl_class_student.class_id FROM tbl_class_student INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id ) tb1 INNER JOIN (SELECT tbl_session.f_class_id        AS id, tbl_session.c_session_date    AS startt,tbl_session.c_session_end_hour,tbl_session.c_session_start_hour,tbl_training_place.c_title_fa,tbl_class.c_title_class FROM tbl_session INNER JOIN tbl_training_place ON tbl_session.f_training_place_id = tbl_training_place.id INNER JOIN tbl_class ON tbl_session.f_class_id = tbl_class.id ) tb2 ON tb1.class_id = tb2.id WHERE tb1.student=:nationalCode AND startt >=:startDate AND  startt <=:endDate", nativeQuery = true)
    List<Object> getStudentEvent(String nationalCode, String startDate, String endDate);

    @Query(value = "SELECT tbl_session.c_session_date  ,  tbl_session.c_session_start_hour, tbl_session.c_session_end_hour, tbl_training_place.c_title_fa,  tbl_class.c_title_class,  tbl_personal_info.c_national_code   FROM   tbl_session INNER JOIN tbl_training_place ON tbl_session.f_training_place_id = tbl_training_place.id  INNER JOIN tbl_class ON tbl_session.f_class_id = tbl_class.id  INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id WHERE tbl_personal_info.c_national_code=:nationalCode AND tbl_session.c_session_date >=:startDate AND  tbl_session.c_session_date <=:endDate", nativeQuery = true)
    List<Object> getTeacherEvent(String nationalCode, String startDate, String endDate);
}
