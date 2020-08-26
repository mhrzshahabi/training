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
}
