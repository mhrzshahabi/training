package com.nicico.training.repository;

import com.nicico.training.model.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlarmDAO extends JpaRepository<Alarm, Long>, JpaSpecificationExecutor<Alarm> {

    void deleteAlarmsByAlarmTypeTitleEnAndClassIdAndSessionIdAndTeacherIdAndStudentIdAndInstituteIdAndTrainingPlaceIdAndReservationIdAndClassIdConflictAndSessionIdConflictAndInstituteIdConflictAndTrainingPlaceIdConflictAndReservationIdConflict(String alarmTypeTitleEn, Long classId, Long sessionId, Long teacherId, Long studentId, Long instituteId, Long trainingPlaceId, Long reservationId, Long classIdConflict, Long sessionIdConflict, Long instituteIdConflict, Long trainingPlaceIdConflict, Long reservationIdConflict);

    void deleteAlarmsByAlarmTypeTitleEnAndClassId(String alarmTypeTitleEn, Long classId);

    void deleteAlarmsByAlarmTypeTitleEnAndClassIdConflict(String alarmTypeTitleEn, Long classIdConflict);

    void deleteAlarmsByClassId(Long classId);

    void deleteAlarmsByAlarmTypeTitleEn(String alarmTypeTitleEn);

    List<Alarm> getAlarmsByClassIdOrClassIdConflictOrderBySortField(Long classId, Long classIdConflict);

    boolean existsAlarmsByClassIdOrClassIdConflict(Long classId, Long classIdConflict);

}