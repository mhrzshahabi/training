package com.nicico.training.repository;

import com.nicico.training.model.Alarm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AlarmDAO extends JpaRepository<Alarm, Long>, JpaSpecificationExecutor<Alarm> {

    @Modifying
    @Query(value = "DELETE tbl_alarm WHERE ((:alarmTypeTitleEn = '' AND c_alarm_type_title_en IS NULL) OR c_alarm_type_title_en= :alarmTypeTitleEn) AND ((:classId =-1 AND f_class_id IS NULL) OR f_class_id = :classId) AND ((:sessionId =-1 AND f_session_id IS NULL) OR f_session_id = :sessionId) AND ((:teacherId =-1 AND f_teacher_id IS NULL) OR f_teacher_id = :teacherId) AND ((:studentId =-1 AND f_student_id IS NULL) OR f_student_id = :studentId) AND ((:instituteId =-1 AND f_institute_id IS NULL) OR f_institute_id = :instituteId) AND ((:trainingPlaceId =-1 AND f_training_place_id IS NULL) OR f_training_place_id = :trainingPlaceId) AND ((:reservationId =-1 AND n_reservation_id IS NULL) OR n_reservation_id = :reservationId) AND ((:classIdConflict =-1 AND f_class_id_conflict IS NULL) OR f_class_id_conflict = :classIdConflict) AND ((:sessionIdConflict =-1 AND f_session_id_conflict IS NULL) OR f_session_id_conflict = :sessionIdConflict) AND ((:instituteIdConflict=-1 AND f_institute_id_conflict IS NULL) OR f_institute_id_conflict = :instituteIdConflict) AND ((:trainingPlaceIdConflict=-1 AND f_training_place_id_conflict IS NULL) OR f_training_place_id_conflict = :trainingPlaceIdConflict) AND ((:reservationIdConflict=-1 AND n_reservation_id_conflict IS NULL) OR n_reservation_id_conflict = :reservationIdConflict)",nativeQuery = true)
    void deleteAlarmsByAlarmTypeTitleEnAndClassIdAndSessionIdAndTeacherIdAndStudentIdAndInstituteIdAndTrainingPlaceIdAndReservationIdAndClassIdConflictAndSessionIdConflictAndInstituteIdConflictAndTrainingPlaceIdConflictAndReservationIdConflict(String alarmTypeTitleEn, Long classId, Long sessionId, Long teacherId, Long studentId, Long instituteId, Long trainingPlaceId, Long reservationId, Long classIdConflict, Long sessionIdConflict, Long instituteIdConflict, Long trainingPlaceIdConflict, Long reservationIdConflict);

    @Modifying
    @Query(value = "DELETE tbl_alarm WHERE c_alarm_type_title_en = :alarmTypeTitleEn AND f_class_id = :classId",nativeQuery = true)
    void deleteAlarmsByAlarmTypeTitleEnAndClassId(String alarmTypeTitleEn, Long classId);

    @Modifying
    @Query(value = "DELETE tbl_alarm WHERE c_alarm_type_title_en = :alarmTypeTitleEn AND f_class_id_conflict = :classIdConflict",nativeQuery = true)
    void deleteAlarmsByAlarmTypeTitleEnAndClassIdConflict(String alarmTypeTitleEn, Long classIdConflict);

    void deleteAlarmsByClassId(Long classId);

    void deleteAlarmsByAlarmTypeTitleEn(String alarmTypeTitleEn);

    List<Alarm> getAlarmsByClassIdOrClassIdConflictOrderBySortField(Long classId, Long classIdConflict);

    boolean existsAlarmsByClassIdOrClassIdConflict(Long classId, Long classIdConflict);

}