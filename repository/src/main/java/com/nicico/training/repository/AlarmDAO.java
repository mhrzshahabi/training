package com.nicico.training.repository;

import com.nicico.training.model.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AlarmDAO extends JpaRepository<Alarm, Long>, JpaSpecificationExecutor<Alarm> {

    void deleteAlarmsByAlarmTypeTitleEnAndClassIdAndSessionIdAndTeacherIdAndStudentIdAndInstituteIdAndTrainingPlaceIdAndReservationIdAndClassIdConflictAndSessionIdConflictAndInstituteIdConflictAndTrainingPlaceIdConflictAndReservationIdConflict(String alarmTypeTitleFa, Long classId, Long sessionId, Long teacherId, Long studentId, Long instituteId, Long trainingPlaceId, Long reservationId, Long classIdConflict, Long sessionIdConflict, Long instituteIdConflict, Long trainingPlaceIdConflict, Long reservationIdConflict);

    void deleteAlarmsByAlarmTypeTitleEnAndClassId(String alarmTypeTitleFa, Long classId);

    void deleteAlarmsByClassId(Long classId);

}