////*****rastegari 9809*****
package com.nicico.training.service;

import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.ClassAlarmDTO;
import com.nicico.training.iservice.IClassAlarm;
import com.nicico.training.model.Alarm;
import com.nicico.training.model.ViewClassConflict;
import com.nicico.training.repository.AlarmDAO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.ViewClassConflictDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ClassAlarmService implements IClassAlarm {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;
    private final AlarmDAO alarmDAO;
    private final TclassDAO tclassDAO;
    private final ClassStudentDAO classStudentDAO;
    private final ViewClassConflictDAO classConflictDAO;
    private final MessageSource messageSource;
    private final List<ClassAlarmDTO> alarmQueue;
    private final List<ClassAlarmDTO> alarmQueueType;
    private Long classIdQueue;
    private final Map<String, Long> alarmQueueDelete;
    private final Map<String, Long> alarmConflictQueueDelete;

//////  '' AS alarmTypeTitleFa, '' AS alarmTypeTitleEn, tb1.f_class_id AS classId, tb1.id AS sessionId, null AS teacherId, tb1.classStudentId AS studentId
//////  null AS instituteId, null AS trainingPlaceId, null AS reservationId, tb1.f_class_id AS targetRecordId,'' AS tabName, '' AS pageAddress,
//////  '' AS alarm,  null AS detailRecordId, '' AS sortField,  tb2.f_class_id AS classIdConflict, tb2.id AS  sessionIdConflict,
//////  null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict

    //****************class sum sessions times alarm*****************
    @Transactional
    public void alarmSumSessionsTimes(Long class_id) {
        try {
            String alarmScript = " SELECT " +
                    "'?????????? ?????????? ??????????' AS alarmTypeTitleFa, 'SumSessionsTimes' AS alarmTypeTitleEn, id AS classId, null AS sessionId, " +
                    " null AS teacherId, null AS studentId, null AS instituteId, null AS trainingPlaceId, null AS reservationId, id AS targetRecordId, " +
                    " 'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, " +
                    " (CASE WHEN floor( (class_time - session_time) / 60) > 0 THEN concat(concat('?????????? ?????????? ?????????? ',floor( (class_time - session_time) / 60) ),' ???????? ???????? ???? ?????? ???????? ??????') " +
                    "  ELSE concat(concat('?????????? ?????????? ?????????? ',abs(floor( (class_time - session_time) / 60) ) ),' ???????? ?????????? ???? ?????? ???????? ??????') END) AS alarm, " +
                    " null AS detailRecordId, '1' AS sortField, null AS classIdConflict, null AS sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, " +
                    " null AS reservationIdConflict " +
                    " FROM " +
                    " ( " +
                    "   SELECT " +
                    "       tbl_class.id, " +
                    "       concat(concat(concat(concat('???????? ',tbl_class.c_title_class),' ???? ???? '),tbl_class.c_code),' : ') AS class_name, " +
                    "       (CASE WHEN SUM(round(to_number(TO_DATE(tbl_session.c_session_end_hour,'HH24:MI') - TO_DATE(tbl_session.c_session_start_hour,'HH24:MI') ) * 24 * 60)) IS NOT NULL THEN " +
                    "       SUM(round(to_number(TO_DATE(tbl_session.c_session_end_hour,'HH24:MI') - TO_DATE(tbl_session.c_session_start_hour,'HH24:MI') ) * 24 * 60)) ELSE 0 END) AS session_time, " +
                    "       ( tbl_class.n_h_duration * 60 ) AS class_time " +
                    "   FROM " +
                    "       tbl_session " +
                    "       RIGHT JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "   WHERE tbl_class.id = :class_id " +
                    "   GROUP BY " +
                    "       tbl_class.id, " +
                    "       tbl_class.n_h_duration, " +
                    "       tbl_class.c_code, " +
                    "       tbl_class.c_title_class " +
                    " ) " +
                    " WHERE " +
                    " floor(abs((class_time - session_time) / 60)) > 0 ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("SumSessionsTimes", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class capacity alarm*****************
    @Transactional
    public void alarmClassCapacity(Long class_id) {
        try {
            String alarmScript = " SELECT alarmTypeTitleFa, 'ClassCapacity' AS alarmTypeTitleEn, classId, null AS sessionId,null AS teacherId, null AS studentId,  " +
                    " null AS instituteId, null AS trainingPlaceId, null AS reservationId, targetRecordId, tabName, pageAddress, " +
                    "('?????????? ???????? ?????????????? ???????? ???? ' ||  CASE WHEN status = 'MAX' THEN '???????????? ?????????? ???????? ??????????' ELSE '?????????? ?????????? ???????? ????????' END || ' ??????')  AS alarm, " +
                    " null AS detailRecordId,  sortField, null AS classIdConflict, null AS sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, " +
                    " null AS reservationIdConflict " +
                    " FROM " +
                    " (SELECT " +
                    "    tbl_class.id AS classId, " +
                    "    tbl_class.id AS targetrecordid, " +
                    "    'classStudentsTab' AS tabname, " +
                    "    '/tclass/show-form' AS pageaddress, " +
                    "    '?????????? ????????' AS alarmTypeTitleFa, " +
                    "    '2' AS sortfield, " +
                    "    CASE " +
                    "        WHEN COUNT(tbl_class_student.student_id) > tbl_class.n_max_capacity THEN " +
                    "            'MAX' " +
                    "        WHEN COUNT(tbl_class_student.student_id) < tbl_class.n_min_capacity THEN " +
                    "            'MIN' " +
                    "    END AS status, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity, " +
                    "    COUNT(tbl_class_student.student_id) AS studentcount " +
                    " FROM " +
                    "    tbl_class left " +
                    "    JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id " +
                    " WHERE " +
                    "    tbl_class.id = :class_id " +
                    " GROUP BY " +
                    "    tbl_class.id, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity " +
                    " HAVING ( COUNT(tbl_class_student.student_id) > tbl_class.n_max_capacity ) " +
                    "       OR ( COUNT(tbl_class_student.student_id) < tbl_class.n_min_capacity )) ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("ClassCapacity", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class teacher conflict alarm*****************
    @Transactional
    public void alarmTeacherConflict(Long class_id) {
        try {

            Long term_id = tclassDAO.getTermIdByClassId(class_id);

            String alarmScript = " SELECT '?????????? ????????' AS alarmTypeTitleFa, 'TeacherConflict' AS alarmTypeTitleEn, classId, sessionId ,null AS teacherId, null AS studentId,null AS instituteId, " +
                    " null AS trainingPlaceId, null AS reservationId, targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, " +
                    "'???????? ' || c_session_start_hour ||  ' ???? ' || c_session_end_hour || ' ' || c_day_name || ' ' || c_session_date ||' ???????? '|| c_title_class_current ||' ???? ???? '|| c_code_current ||  ' '|| teachername ||' ???? ???????? '|| c_session_start_hour1 ||' ???? '|| c_session_end_hour1 ||' '   || c_day_name1  || ' '|| c_session_date1||' ???????? '|| c_title_class ||' ???? ???? '|| c_code ||' ?????????? ????????' AS alarm, " +
                    " null AS detailRecordId, sortField, classIdConflict, sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
                    " FROM " +
                    "    (SELECT " +
                    "    tb1.id AS sessionId, " +
                    "    tb1.f_class_id             AS classId, " +
                    "    tb1.f_class_id             AS targetrecordid, " +
                    "    tb1.c_day_name, " +
                    "    tb1.c_session_date, " +
                    "    tb1.c_session_end_hour, " +
                    "    tb1.c_session_start_hour, " +
                    "    tb2.id                     AS sessionIdConflict, " +
                    "    tb2.f_class_id             AS classIdConflict, " +
                    "    tb2.c_day_name             AS c_day_name1, " +
                    "    tb2.c_session_date         AS c_session_date1, " +
                    "    tb2.c_session_end_hour     AS c_session_end_hour1, " +
                    "    tb2.c_session_start_hour   AS c_session_start_hour1, " +
                    "    ( ( " +
                    "        CASE " +
                    "            WHEN tbl_personal_info.e_gender = 1 THEN " +
                    "                '????????' " +
                    "            ELSE " +
                    "                '????????' " +
                    "        END " +
                    "    ) " +
                    "      || ' ' " +
                    "      || tbl_personal_info.c_first_name_fa " +
                    "      || ' ' " +
                    "      || tbl_personal_info.c_last_name_fa ) AS teachername, " +
                    "    tbl_class.c_code, " +
                    "    tbl_class.c_title_class, " +
                    " ( '3' || ' ?????????? ???????? ' " +
                    "      || tb1.c_session_date " +
                    "      || '_' " +
                    "      || tb1.c_session_end_hour " +
                    "      || '_' " +
                    "      || tb1.c_session_start_hour ) AS sortfield, " +
                    "    tbl_class1.c_code          AS c_code_current, " +
                    "    tbl_class1.c_title_class   AS c_title_class_current " +
                    " FROM " +
                    "    tbl_session tb1 " +
                    "    INNER JOIN tbl_session tb2 ON tb2.f_teacher_id = tb1.f_teacher_id " +
                    "    AND tb1.c_session_date = tb2.c_session_date " +
                    "    INNER JOIN tbl_teacher ON tbl_teacher.id = tb1.f_teacher_id " +
                    "    INNER JOIN tbl_personal_info ON tbl_personal_info.id = tbl_teacher.f_personality " +
                    "    INNER JOIN tbl_class ON tbl_class.id = tb2.f_class_id " +
                    "    INNER JOIN tbl_class tbl_class1 ON tb1.f_class_id = tbl_class1.id " +
                    " WHERE " +
                    " tbl_class1.c_status <> 3 AND " +
                    " tbl_class.c_status <> 3 AND  " +
                    " tbl_class1.f_term = :term_id AND " +
                    " tbl_class.f_term = :term_id  AND  " +
                    "    tb1.id <> tb2.id " +
                    "    AND tb1.f_class_id = :class_id " +
                    "    AND ( ( tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND tb1.c_session_start_hour < tb2.c_session_end_hour ) " +
                    "          OR ( tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "               AND tb1.c_session_end_hour > tb2.c_session_start_hour ))) ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).setParameter("term_id", term_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToDeleteQueue("TeacherConflict", class_id);
                    addAlarmsToDeleteConflictQueue("TeacherConflict", class_id);
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("TeacherConflict", class_id);
                    addAlarmsToDeleteConflictQueue("TeacherConflict", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class student conflict alarm*****************
    @Transactional
    public void alarmStudentConflict(Long class_id) {
        try {

            Long term_id = tclassDAO.getTermIdByClassId(class_id);

            String alarmScript = " SELECT  '?????????? ????????????' AS alarmTypeTitleFa, 'StudentConflict' AS alarmTypeTitleEn, tb1.f_class_id AS classId, tb1.id AS sessionId, null AS teacherId, tb1.classStudentId AS studentId, " +
                    " null AS instituteId, null AS trainingPlaceId, null AS reservationId, tb1.f_class_id AS targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, " +
                    " ' ???????? ' " +
                    " || tb1.c_session_start_hour " +
                    "|| ' ???? ' " +
                    " || tb1.c_session_end_hour " +
                    " || ' ' " +
                    " || tb1.c_day_name " +
                    " || ' ' " +
                    " || tb1.c_session_date " +
                    " || ' ' " +
                    " || tb1.classname " +
                    " || ' ' " +
                    " || tb1.studentName " +
                    " || ' ???? ???????? ' " +
                    " || tb2.c_session_start_hour " +
                    "|| ' ???? ' " +
                    " || tb2.c_session_end_hour " +
                    " || ' ' " +
                    " || tb2.c_day_name " +
                    " || ' ' " +
                    " || tb2.c_session_date " +
                    " || ' ' " +
                    " || tb2.classname " +
                    " || ' ?????????? ????????' AS alarm, " +
                    " null AS detailRecordId, " +
                    " ('4' || tb1.student_id || ' ?????????? ???????????? ' || tb1.c_session_date || tb1.c_session_start_hour ) AS sortField, " +
                    " tb2.f_class_id AS classIdConflict, tb2.id AS  sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
                    " FROM " +
                    " ( " +
                    "        SELECT " +
                    "        tbl_session.id, " +
                    "        tbl_session.f_class_id, " +
                    "        tbl_session.c_day_name, " +
                    "        tbl_session.c_session_date, " +
                    "        tbl_session.c_session_end_hour, " +
                    "        tbl_session.c_session_start_hour, " +
                    "        tbl_class_student.student_id, " +
                    "        tbl_class_student.id AS classStudentId, " +
                    "        tbl_student.first_name, " +
                    "        tbl_student.last_name, " +
                    "        tbl_student.national_code, " +
                    "        tbl_student.personnel_no, " +
                    "        ( " +
                    "            CASE " +
                    "                WHEN tbl_student.gender_title = '??????' THEN ' ???????? ' " +
                    "                ELSE ' ???????? ' " +
                    "            END " +
                    "        || tbl_student.first_name " +
                    "        || ' ' " +
                    "        || tbl_student.last_name " +
                    "        || ' ???? ?????????? ???????????? ' " +
                    "        || tbl_student.personnel_no ) AS studentName, " +
                    "                ( ' ???????? ' " +
                    "        || tbl_class.c_title_class " +
                    "        || ' ???? ???? ' " +
                    "        || tbl_class.c_code ) AS classname " +
                    "    FROM " +
                    "        tbl_session " +
                    "        INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "        INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "        INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "        WHERE tbl_class.f_term = :term_id AND tbl_class.c_status <> 3 " +
                    " ) tb1 " +
                    " INNER JOIN ( " +
                    "    SELECT " +
                    "        tbl_session.id, " +
                    "        tbl_session.f_class_id, " +
                    "        tbl_session.c_day_name, " +
                    "        tbl_session.c_session_date, " +
                    "        tbl_session.c_session_end_hour, " +
                    "        tbl_session.c_session_start_hour, " +
                    "        tbl_class_student.student_id, " +
                    "        tbl_class_student.id AS classStudentId, " +
                    "        tbl_student.first_name, " +
                    "        tbl_student.last_name, " +
                    "        tbl_student.national_code, " +
                    "        tbl_student.personnel_no, " +
                    "        ( " +
                    "            CASE " +
                    "                WHEN tbl_student.gender_title = '??????' THEN ' ???????? ' " +
                    "                ELSE ' ???????? ' " +
                    "            END " +
                    "        || tbl_student.first_name " +
                    "        || ' ' " +
                    "        || tbl_student.last_name " +
                    "        || ' ???? ?????????? ???????????? ' " +
                    "        || tbl_student.personnel_no ) AS studentName, " +
                    "        ( ' ???????? ' " +
                    "        || tbl_class.c_title_class " +
                    "        || ' ???? ???? ' " +
                    "        || tbl_class.c_code ) AS classname         " +
                    "    FROM " +
                    "        tbl_session " +
                    "        INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "        INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "        INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "        WHERE tbl_class.f_term = :term_id AND tbl_class.c_status <> 3 " +
                    " ) tb2 ON tb2.c_session_date = tb1.c_session_date " +
                    "         AND tb2.national_code = tb1.national_code " +
                    " WHERE " +
                    " tb1.id <> tb2.id " +
                    " AND   ( " +
                    "    ( " +
                    "        tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "        AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "    ) " +
                    "    OR    ( " +
                    "        tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "        AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "    ) " +
                    " ) " +
                    " AND tb1.f_class_id =:class_id ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).setParameter("term_id", term_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToDeleteQueue("StudentConflict", class_id);
                    addAlarmsToDeleteConflictQueue("StudentConflict", class_id);
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("StudentConflict", class_id);
                    addAlarmsToDeleteConflictQueue("StudentConflict", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class training place conflict alarm*****************
    @Transactional
    public void alarmTrainingPlaceConflict(Long class_id) {
        try {

            Long term_id = tclassDAO.getTermIdByClassId(class_id);

            String alarmScript = " SELECT " +
                    "        '?????????? ?????? ??????????????' AS alarmTypeTitleFa, 'TrainingPlaceConflict' AS alarmTypeTitleEn, " +
                    "        tb1.f_class_id AS classId, tb1.id AS sessionId, null AS teacherId, null AS studentId,  " +
                    "        tb1.f_institute_id  AS instituteId, tb1.f_training_place_id AS trainingPlaceId, null AS reservationId, tb1.f_class_id AS targetrecordid, " +
                    "        'classSessionsTab' AS tabname, '/tclass/show-form' AS pageaddress, " +
                    "        '?????? ?????????????? ' || tb1.c_title_fa1 || ' ?????????? ' || tb1.c_title_fa || '??' || ' ???????? '|| tb1.c_title_class " +
                    "        || ' ???? '  || tb1.c_code || ' ?????? ' || tb1.c_day_name || ' ' || tb1.c_session_date || ' ???? ' " +
                    "        || tb1.c_session_start_hour || ' ???? ' || tb1.c_session_end_hour || ' ???? ???????? '|| tb2.c_title_class " +
                    "        || ' ???? ' || tb2.c_code || ' ?????????? ????????' AS alarm, null AS detailrecordid, " +
                    "        ('5' ||  tb1.f_institute_id || tb1.f_training_place_id || tb1.c_session_date || tb1.c_session_start_hour || tb1.c_session_end_hour ) AS sortfield, " +
                    "        tb2.f_class_id AS classIdConflict, tb2.id AS sessionIdConflict, tb2.f_institute_id  AS instituteIdConflict, tb2.f_training_place_id AS trainingPlaceIdConflict, " +
                    "        null AS reservationIdConflict " +
                    "    FROM " +
                    "        ( " +
                    "            SELECT " +
                    "                tbl_session.id, " +
                    "                tbl_session.f_class_id, " +
                    "                tbl_session.c_day_name, " +
                    "                tbl_session.c_session_date, " +
                    "                tbl_session.c_session_end_hour, " +
                    "                tbl_session.c_session_start_hour, " +
                    "                tbl_session.f_institute_id, " +
                    "                tbl_institute.c_title_fa, " +
                    "                tbl_session.f_training_place_id, " +
                    "                tbl_training_place.c_title_fa AS c_title_fa1, " +
                    "                tbl_class.c_code, " +
                    "                tbl_class.c_title_class " +
                    "            FROM " +
                    "                tbl_session " +
                    "                INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "                INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "                INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "            WHERE tbl_class.f_term = :term_id AND tbl_class.c_status <> 3 " +
                    "        ) tb1 " +
                    "        INNER JOIN ( " +
                    "            SELECT " +
                    "                tbl_session.id, " +
                    "                tbl_session.f_class_id, " +
                    "                tbl_session.c_day_name, " +
                    "                tbl_session.c_session_date, " +
                    "                tbl_session.c_session_end_hour, " +
                    "                tbl_session.c_session_start_hour, " +
                    "                tbl_session.f_institute_id, " +
                    "                tbl_institute.c_title_fa, " +
                    "                tbl_session.f_training_place_id, " +
                    "                tbl_training_place.c_title_fa AS c_title_fa1, " +
                    "                tbl_class.c_code, " +
                    "                tbl_class.c_title_class " +
                    "            FROM " +
                    "                tbl_session " +
                    "                INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "                INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "                INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "           WHERE tbl_class.f_term = :term_id AND tbl_class.c_status <> 3 " +
                    "        ) tb2 ON tb1.c_session_date = tb2.c_session_date " +
                    "                 AND tb1.f_institute_id = tb2.f_institute_id " +
                    "                 AND tb1.f_training_place_id = tb2.f_training_place_id " +
                    "    WHERE " +
                    "        tb1.f_class_id = :class_id AND " +
                    "        tb1.id <> tb2.id " +
                    "        AND   ( " +
                    "            (tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND   tb1.c_session_start_hour < tb2.c_session_end_hour) " +
                    "            OR    (tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "            AND   tb1.c_session_end_hour > tb2.c_session_start_hour) " +
                    "        ) ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).setParameter("term_id", term_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToDeleteQueue("TrainingPlaceConflict", class_id);
                    addAlarmsToDeleteConflictQueue("TrainingPlaceConflict", class_id);
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("TrainingPlaceConflict", class_id);
                    addAlarmsToDeleteConflictQueue("TrainingPlaceConflict", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class check list conflict alarm*****************
    @Transactional
    public void alarmCheckListConflict(Long class_id) {
        ////disabled , because in update check list run into error
//        try {
        ////****Point : if class_id is zero, it check, checklist conflict alarms for all classes****

//            String alarmScript = " SELECT DISTINCT " +
//                    "'?????? ?????????? ???? ????????' AS alarmTypeTitleFa, " +
//                    " 'CheckListConflict' AS alarmTypeTitleEn, tbchecklist.class_id  AS classId, null AS sessionId, null AS teacherId,  " +
//                    " null AS studentId, null AS instituteId, null AS trainingPlaceId, null AS reservationId,  tbchecklist.class_id AS targetrecordid, " +
//                    " 'classCheckListTab' AS tabname, '/tclass/show-form' AS pageaddress, " +
//                    "'???? ???? ???????? \"' || tbchecklist.c_title_fa || '\" ?????? \"' || tbchecklist.c_group || '\" ???????? \"' || tbchecklist.c_title_fa1 || '\" ?????????? ?????????? ???????? ?????? (???????????? ???? ?????? ??????????????)' AS alarm,     " +
//                    " null AS detailrecordid, ( '6' || tbchecklist.id || '-' || tbchecklist.iditem ) AS sortfield, null AS classIdConflict,  " +
//                    " null AS  sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
//                    " FROM " +
//                    " ( " +
//                    "    SELECT " +
//                    "        tbl_check_list.id, " +
//                    "        tbl_check_list.c_title_fa, " +
//                    "        tbl_check_list_item.id AS iditem, " +
//                    "        tbl_check_list_item.c_group, " +
//                    "        tbl_check_list_item.c_title_fa AS c_title_fa1, " +
//                    "        tbl_check_list_item.b_is_deleted, " +
//                    "        tbl_class.id AS class_id " +
//                    "    FROM " +
//                    "        tbl_check_list " +
//                    "        INNER JOIN tbl_check_list_item ON tbl_check_list.id = tbl_check_list_item.f_check_list_id, " +
//                    "        tbl_class " +
//                    "    WHERE " +
//                    "        (CASE WHEN :class_id = 0 THEN 1 WHEN tbl_class.id = :class_id THEN 1 END) IS NOT NULL AND " +
//                    "         tbl_check_list_item.b_is_deleted IS NULL " +
//                    " ) tbchecklist " +
//                    " LEFT JOIN tbl_class_check_list ON tbchecklist.iditem = tbl_class_check_list.f_check_list_item_id " +
//                    "                                  AND tbchecklist.class_id = tbl_class_check_list.f_tclass_id " +
//                    " INNER JOIN tbl_class ON tbl_class.id = tbchecklist.class_id " +
//                    " WHERE " +
//                    " tbl_class.c_status <> 3 AND " +
//                    " tbl_class_check_list.c_description IS NULL " +
//                    " AND   ( " +
//                    "    tbl_class_check_list.b_enabled IS NULL " +
//                    "    OR    tbl_class_check_list.b_enabled = 0 " +
//                    " ) ";
//
//            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).getResultList();
//
//            List<ClassAlarmDTO> alarmList = null;
//            if (alarms != null) {
//                alarmList = new ArrayList<>(alarms.size());
//
//                for (int i = 0; i < alarms.size(); i++) {
//                    Object[] alarm = (Object[]) alarms.get(i);
//                    alarmList.add(convertObjectToDTO(alarm));
//                }
//
//                ////because is to long , I disabled this part
//                ////if (class_id == 0L) {
//                ////    alarmDAO.deleteAlarmsByAlarmTypeTitleEn("CheckListConflict");
//                ////}
//
//                if (alarmList.size() > 0) {
//                    addAlarmsToQueue(alarmList, class_id);
//                } else {
//                    addAlarmsToDeleteQueue("CheckListConflict", class_id);
//                }
//            }
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }
    }
    //*********************************

    //****************class pre course test question alarm*****************
    @Transactional
    public void alarmPreCourseTestQuestion(Long class_id) {
        try {
            String alarmScript = "  SELECT " +
                    "'???????????? ?????? ??????????'AS alarmTypeTitleFa, 'PreCourseTestQuestion' AS alarmTypeTitleEn, tbl_class.id AS classId, null AS sessionId, null AS teacherId, null AS studentId, " +
                    " null AS instituteId, null AS trainingPlaceId, null AS reservationId, tbl_class.id AS targetRecordId,'classPreCourseTestQuestionsTab' AS tabName, '/tclass/show-form' AS pageAddress, " +
                    "'???????????? ?????????? ?????? ???? ?????????????? ???????? ?????? ???????? ??????.'AS alarm,  null AS detailRecordId, '8' AS sortField,  null AS classIdConflict, null AS  sessionIdConflict, " +
                    "  null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
                    " FROM " +
                    " tbl_class  " +
                    " LEFT JOIN tbl_class_pre_course_test_question ON tbl_class_pre_course_test_question.f_class_id = tbl_class.id " +
                    " WHERE " +
                    " tbl_class.c_status<>3 and tbl_class.id =:class_id and tbl_class.pre_course_test = 1 and tbl_class_pre_course_test_question.f_class_id is null ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).getResultList();

            List<ClassAlarmDTO> alarmList = null;
            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToDeleteQueue("PreCourseTestQuestion", class_id);
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("PreCourseTestQuestion", class_id);
                    setClassHasWarningStatus(class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************class attendance alarm*****************IS ON LINE for > Attendance and EvaluationBehaviour and CheckListConflict
    @Transactional
    public List<ClassAlarmDTO> alarmAttendance(Long class_id) {

        List<ClassAlarmDTO> alarmList = null;

        try {
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date();
            String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));

            String alarmScript = "  SELECT DISTINCT " +
                    " alarmTypeTitleFa, 'Attendance' AS alarmTypeTitleEn, classId, null AS sessionId, null AS teacherId, null AS studentId," +
                    " null AS instituteId, null AS trainingPlaceId, null AS reservationId, targetRecordId, tabName, pageAddress," +
                    " alarm, null AS detailRecordId,  sortField,  null AS classIdConflict, null AS  sessionIdConflict," +
                    " null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict" +
                    " FROM " +
                    " ( " +
                    " SELECT" +
                    "    tbl_session.f_class_id AS classId," +
                    "    tbl_session.f_class_id AS targetRecordId," +
                    "   'classAttendanceTab' AS tabName," +
                    "   '/tclass/show-form' AS pageAddress," +
                    "   '???????? ?? ????????' as alarmTypeTitleFa, " +
                    "('???????? ?? ???????? ' || '???????? ' ||  tbl_session.c_session_start_hour || ' ???? ' || tbl_session.c_session_end_hour || ' ' || tbl_session.c_day_name || ' ?????????? ' || tbl_session.c_session_date || ' ?????????? ???????? ??????') as alarm, " +
                    "   tbl_session.id AS detailRecordId," +
                    "   ('7' || tbl_session.c_session_date || tbl_session.c_session_start_hour) AS sortField " +
                    " FROM " +
                    "   tbl_class_student" +
                    "   INNER JOIN tbl_session ON tbl_class_student.class_id = tbl_session.f_class_id" +
                    "   LEFT JOIN tbl_attendance ON tbl_session.id = tbl_attendance.f_session" +
                    " WHERE " +
                    "   tbl_session.f_class_id = :class_id " +
                    "   AND tbl_session.c_session_date <:todaydat" +
                    "   AND (tbl_attendance.c_state IS NULL OR tbl_attendance.c_state = 0)" +
                    " ) " +
                    " UNION ALL " +
                    " SELECT " +
                    "  '?????? ???????? ?????????????? ????????????'  AS alarmTypeTitleFa, 'EvaluationBehaviour' AS alarmTypeTitleEn, id AS classId, null AS sessionId, null AS teacherId, null AS studentId, " +
                    "  null AS instituteId, null AS trainingPlaceId, null AS reservationId, id AS targetRecordId,'tabName' AS tabName, '/tclass/show-form' AS pageAddress, " +
                    "   alarm,  null AS detailRecordId, '9' AS sortField,  null AS classIdConflict, null AS  sessionIdConflict, " +
                    "  null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
                    " FROM " +
                    " (SELECT " +
                    " tbl_class.id,  '???????? ' || COUNT( tbl_class.id) || ' ???????????? ?????? ???????? ?????????????? ???????????? ???????? ???????? ??????'  as alarm " +
                    " FROM " +
                    "   tbl_class " +
                    "   INNER JOIN tbl_class_student ON tbl_class_student.class_id = tbl_class.id " +
                    "   INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id " +
                    " WHERE " +
                    " tbl_class.id = :class_id AND " +
                    "   tbl_course.c_evaluation = 3 AND " +
                    "   tbl_class.c_status = 3 " +
                    "   AND ( tbl_class_student.evaluation_status_behavior IS NULL " +
                    "         OR tbl_class_student.evaluation_status_behavior = 0 ) " +
                    " AND     " +
                    "   trunc(ADD_MONTHS(tbl_class.c_status_date, (CASE WHEN tbl_class.start_evaluation IS NULL THEN 0 ELSE tbl_class.start_evaluation END))) - trunc(sysdate) <= 14 " +
                    " GROUP BY tbl_class.id    " +
                    " HAVING COUNT( tbl_class.id) > 0)  " +
                    " UNION ALL " +
                    " SELECT DISTINCT " +
                    "'?????? ?????????? ???? ????????' AS alarmTypeTitleFa, " +
                    " 'CheckListConflict' AS alarmTypeTitleEn, tbchecklist.class_id  AS classId, null AS sessionId, null AS teacherId,  " +
                    " null AS studentId, null AS instituteId, null AS trainingPlaceId, null AS reservationId,  tbchecklist.class_id AS targetrecordid, " +
                    " 'classCheckListTab' AS tabname, '/tclass/show-form' AS pageaddress, " +
                    "'???? ???? ???????? \"' || tbchecklist.c_title_fa || '\" ?????? \"' || tbchecklist.c_group || '\" ???????? \"' || tbchecklist.c_title_fa1 || '\" ?????????? ?????????? ???????? ?????? (???????????? ???? ?????? ??????????????)' AS alarm,     " +
                    " null AS detailrecordid, ( '6' || tbchecklist.id || '-' || tbchecklist.iditem ) AS sortfield, null AS classIdConflict,  " +
                    " null AS  sessionIdConflict, null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict " +
                    " FROM " +
                    " ( " +
                    "    SELECT " +
                    "        tbl_check_list.id, " +
                    "        tbl_check_list.c_title_fa, " +
                    "        tbl_check_list_item.id AS iditem, " +
                    "        tbl_check_list_item.c_group, " +
                    "        tbl_check_list_item.c_title_fa AS c_title_fa1, " +
                    "        tbl_check_list_item.b_is_deleted, " +
                    "        tbl_class.id AS class_id " +
                    "    FROM " +
                    "        tbl_check_list " +
                    "        INNER JOIN tbl_check_list_item ON tbl_check_list.id = tbl_check_list_item.f_check_list_id, " +
                    "        tbl_class " +
                    "    WHERE " +
                    "        (CASE WHEN :class_id = 0 THEN 1 WHEN tbl_class.id = :class_id THEN 1 END) IS NOT NULL AND " +
                    "         tbl_check_list_item.b_is_deleted IS NULL " +
                    " ) tbchecklist " +
                    " LEFT JOIN tbl_class_check_list ON tbchecklist.iditem = tbl_class_check_list.f_check_list_item_id " +
                    "                                  AND tbchecklist.class_id = tbl_class_check_list.f_tclass_id " +
                    " INNER JOIN tbl_class ON tbl_class.id = tbchecklist.class_id " +
                    " WHERE " +
                    " tbl_class.c_status <> 3 AND " +
                    " tbl_class_check_list.c_description IS NULL " +
                    " AND   ( " +
                    "    tbl_class_check_list.b_enabled IS NULL " +
                    "    OR    tbl_class_check_list.b_enabled = 0 " +
                    " ) ";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).setParameter("todaydat", todayDate).getResultList();

            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return alarmList;
    }
    //*********************************

    //****************class attendance alarm*****************checking for unjustified absence limitations
    @Transactional
    public void alarmAttendanceUnjustifiedAbsence(Long class_id) {

        List<ClassAlarmDTO> alarmList = null;

        try {

            String alarmScript = "SELECT DISTINCT \n" +
                    "    alarmTypeTitleFa, 'UnjustifiedAttendance' AS alarmTypeTitleEn, classId, null AS sessionId, null AS teacherId, studentId,\n" +
                    "    null AS instituteId, null AS trainingPlaceId, null AS reservationId, targetRecordId, tabName, pageAddress,\n" +
                    "    alarm, detailRecordId, sortField,  null AS classIdConflict, null AS  sessionIdConflict,\n" +
                    "    null AS instituteIdConflict, null AS trainingPlaceIdConflict, null AS reservationIdConflict\n" +
                    "    FROM \n" +
                    "    ( \n" +
                    "    SELECT\n" +
                    "    classId,\n" +
                    "    targetRecordId,\n" +
                    "    detailRecordId,\n" +
                    "    null AS studentId,\n" +
                    "    'classAttendanceTab' AS tabName,\n" +
                    "    '/tclass/show-form' AS pageAddress,\n" +
                    "    '???????? ?? ????????' as alarmTypeTitleFa,\n" +
                    "    ( '?????????? ???????? ?????? ???????? ???????????? ???? ?????? '|| tbl_student.first_name || ' ' || tbl_student.last_name || ' ???? ???? ???????????? ' || tbl_student.emp_no || ' ???? ???? ???????? ?????????? ?????? ') AS alarm,\n" +
                    "    ( '8' ) AS sortField,\n" +
                    "    sum_session_time,\n" +
                    "    absence_session_time,\n" +
                    "    tbl_student.first_name,\n" +
                    "    tbl_student.last_name,\n" +
                    "    tbl_student.emp_no\n" +
                    "FROM\n" +
                    "    (\n" +
                    "        SELECT\n" +
                    "            tbl_session.f_class_id AS classId,\n" +
                    "            tbl_session.f_class_id AS targetRecordId,\n" +
                    "            tbl_class_student.student_id AS detailRecordId,\n" +
                    "            SUM(round(to_number(TO_DATE( (\n" +
                    "                CASE\n" +
                    "                    WHEN substr(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59'\n" +
                    "                    ELSE tbl_session.c_session_end_hour\n" +
                    "                END\n" +
                    "            ),'HH24:MI') - TO_DATE( (\n" +
                    "                CASE\n" +
                    "                    WHEN substr(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59'\n" +
                    "                    ELSE tbl_session.c_session_start_hour\n" +
                    "                END\n" +
                    "            ),'HH24:MI') ) * 24 * 60 * 60 * 1000) ) AS sum_session_time,\n" +
                    "            SUM(\n" +
                    "                CASE\n" +
                    "                    WHEN tbl_attendance.c_state = 3                      THEN round(to_number(TO_DATE( (\n" +
                    "                        CASE\n" +
                    "                            WHEN substr(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59'\n" +
                    "                            ELSE tbl_session.c_session_end_hour\n" +
                    "                        END\n" +
                    "                    ),'HH24:MI') - TO_DATE( (\n" +
                    "                        CASE\n" +
                    "                            WHEN substr(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59'\n" +
                    "                            ELSE tbl_session.c_session_start_hour\n" +
                    "                        END\n" +
                    "                    ),'HH24:MI') ) * 24 * 60 * 60 * 1000)\n" +
                    "                    ELSE 0\n" +
                    "                END\n" +
                    "            ) AS absence_session_time\n" +
                    "        FROM\n" +
                    "            tbl_class_student\n" +
                    "            INNER JOIN tbl_session ON tbl_class_student.class_id = tbl_session.f_class_id\n" +
                    "            INNER JOIN tbl_attendance ON tbl_session.id = tbl_attendance.f_session\n" +
                    "                                         AND tbl_attendance.f_student = tbl_class_student.student_id\n" +
                    "        WHERE\n" +
                    "            tbl_session.f_class_id =:class_id\n" +
                    "--            AND   tbl_attendance.f_student =:student_id\n" +
                    "        GROUP BY\n" +
                    "            tbl_session.f_class_id,\n" +
                    "            tbl_class_student.student_id\n" +
                    "    )\n" +
                    "    INNER JOIN tbl_student ON tbl_student.id = detailrecordid\n" +
                    "WHERE\n" +
                    "    sum_session_time * :absence_percentage < absence_session_time\n" +
                    "    )";

            List<?> alarms = (List<?>) entityManager.createNativeQuery(alarmScript).setParameter("class_id", class_id).setParameter("absence_percentage", 0.34).getResultList();

            if (alarms != null) {
                alarmList = new ArrayList<>(alarms.size());

                for (int i = 0; i < alarms.size(); i++) {
                    Object[] alarm = (Object[]) alarms.get(i);
                    alarmList.add(convertObjectToDTO(alarm));
                }

                if (alarmList.size() > 0) {
                    addAlarmsToQueue(alarmList, class_id);
                } else {
                    addAlarmsToDeleteQueue("UnjustifiedAttendance", class_id);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    //*********************************

    //****************convert object to dto*****************
    private ClassAlarmDTO convertObjectToDTO(Object[] alarm) {
        return new ClassAlarmDTO(
                (alarm[0] != null ? alarm[0].toString() : null),
                (alarm[1] != null ? alarm[1].toString() : null),
                (alarm[2] != null ? Long.parseLong(alarm[2].toString()) : null),
                (alarm[3] != null ? Long.parseLong(alarm[3].toString()) : null),
                (alarm[4] != null ? Long.parseLong(alarm[4].toString()) : null),
                (alarm[5] != null ? Long.parseLong(alarm[5].toString()) : null),
                (alarm[6] != null ? Long.parseLong(alarm[6].toString()) : null),
                (alarm[7] != null ? Long.parseLong(alarm[7].toString()) : null),
                (alarm[8] != null ? Long.parseLong(alarm[8].toString()) : null),
                (alarm[9] != null ? Long.parseLong(alarm[9].toString()) : null),
                (alarm[10] != null ? alarm[10].toString() : null),
                (alarm[11] != null ? alarm[11].toString() : null),
                (alarm[12] != null ? alarm[12].toString() : null),
                (alarm[13] != null ? Long.parseLong(alarm[13].toString()) : null),
                (alarm[14] != null ? alarm[14].toString() : null),
                (alarm[15] != null ? Long.parseLong(alarm[15].toString()) : null),
                (alarm[16] != null ? Long.parseLong(alarm[16].toString()) : null),
                (alarm[17] != null ? Long.parseLong(alarm[17].toString()) : null),
                (alarm[18] != null ? Long.parseLong(alarm[18].toString()) : null),
                (alarm[19] != null ? Long.parseLong(alarm[19].toString()) : null)
        );
    }
    //*********************************

    //****************save created alarms*****************

    @Transactional
    public void addAlarmsToQueue(List<ClassAlarmDTO> alarmList, Long class_id) {

        if (alarmList.size() > 0) {
            alarmQueue.addAll(alarmList);
            alarmQueueType.add(alarmList.get(0));
            classIdQueue = class_id;
        }
    }

    @Transactional
    public void addAlarmsToDeleteQueue(String alarmType, Long class_id) {
        alarmQueueDelete.put(alarmType, class_id);
    }

    @Transactional
    public void addAlarmsToDeleteConflictQueue(String alarmType, Long class_id) {
        alarmConflictQueueDelete.put(alarmType, class_id);
    }


    @Transactional
    public void saveAlarms() {

        Boolean alarmChanged = false;

        for (Map.Entry<String, Long> alarmForDelete : alarmQueueDelete.entrySet()) {
            alarmDAO.deleteAlarmsByAlarmTypeTitleEnAndClassId(alarmForDelete.getKey(), alarmForDelete.getValue());
            alarmChanged = true;
        }

        for (Map.Entry<String, Long> alarmConflictForDelete : alarmConflictQueueDelete.entrySet()) {
            alarmDAO.deleteAlarmsByAlarmTypeTitleEnAndClassIdConflict(alarmConflictForDelete.getKey(), alarmConflictForDelete.getValue());
            alarmChanged = true;
        }

        if (alarmQueue.size() > 0 || alarmQueueType.size() > 0) {
            for (ClassAlarmDTO classAlarmDTO : alarmQueueType)
                alarmDAO.deleteAlarmsByAlarmTypeTitleEnAndClassIdAndSessionIdAndTeacherIdAndStudentIdAndInstituteIdAndTrainingPlaceIdAndReservationIdAndClassIdConflictAndSessionIdConflictAndInstituteIdConflictAndTrainingPlaceIdConflictAndReservationIdConflict(classAlarmDTO.getAlarmTypeTitleEn()==null?"":classAlarmDTO.getAlarmTypeTitleEn(), classAlarmDTO.getClassId()==null?-1:classAlarmDTO.getClassId(), classAlarmDTO.getSessionId()==null?-1:classAlarmDTO.getSessionId(), classAlarmDTO.getTeacherId()==null?-1:classAlarmDTO.getTeacherId(), classAlarmDTO.getStudentId()==null?-1:classAlarmDTO.getStudentId(), classAlarmDTO.getInstituteId()==null?-1:classAlarmDTO.getInstituteId(), classAlarmDTO.getTrainingPlaceId()==null?-1:classAlarmDTO.getTrainingPlaceId(), classAlarmDTO.getReservationId()==null?-1:classAlarmDTO.getReservationId(), classAlarmDTO.getClassIdConflict()==null?-1:classAlarmDTO.getClassIdConflict(), classAlarmDTO.getSessionIdConflict()==null?-1:classAlarmDTO.getSessionIdConflict(), classAlarmDTO.getInstituteIdConflict()==null?-1:classAlarmDTO.getInstituteIdConflict(), classAlarmDTO.getTrainingPlaceIdConflict()==null?-1:classAlarmDTO.getTrainingPlaceIdConflict(), classAlarmDTO.getReservationIdConflict()==null?-1:classAlarmDTO.getReservationIdConflict());

            alarmDAO.saveAll(modelMapper.map(alarmQueue, new TypeToken<List<Alarm>>() {
            }.getType()));

            alarmChanged = true;
        }

        if (alarmChanged) {
            setClassHasWarningStatus(classIdQueue);

            alarmQueueDelete.clear();
            alarmConflictQueueDelete.clear();
            alarmQueue.clear();
            alarmQueueType.clear();
            classIdQueue = null;
        }
    }
    //*********************************

    //****************save created alarms*****************
    public void setClassHasWarningStatus(Long class_id) {

        //*****this method check all not ended class and set alarm status for them*****
        if(class_id!=null)
        tclassDAO.updateAllClassHasWarning(class_id);
//        if (class_id == 0L) {
//            //*****this method check all not ended class and set alarm status for them*****
//            tclassDAO.updateAllClassHasWarning();
//            //*****************************************************************************
//        } else {
//            if (alarmDAO.existsAlarmsByClassIdOrClassIdConflict(class_id, class_id)) {
//                tclassDAO.updateClassHasWarning(class_id, "alarm");
//            } else {
//                tclassDAO.updateClassHasWarning(class_id, "");
//            }
//        }
    }
    //*********************************


    //****************delete all class alarms*****************
    @Transactional
    public void deleteAllClassAlarms(Long classId) {
        alarmDAO.deleteAlarmsByClassId(classId);
    }
    //*********************************

    //*********************************
    @Override
    public List<ClassAlarmDTO> list(Long classId, HttpServletResponse response) throws IOException {

        List<ClassAlarmDTO> allClassAlarmDTO = null;

        try {


            List<ClassAlarmDTO> classAlarmDTO = modelMapper.map(alarmDAO.getAlarmsByClassIdOrClassIdConflictOrderBySortField(classId, classId), new TypeToken<List<ClassAlarmDTO>>() {
            }.getType());

            allClassAlarmDTO = new ArrayList<>(classAlarmDTO);

            //*****add online attendance to existing offline alarms*****
            List<ClassAlarmDTO> attendance = alarmAttendance(classId);
            if (attendance != null && attendance.size() > 0) {
                allClassAlarmDTO.addAll(attendance);
            }
            //**********************************************************
            allClassAlarmDTO.addAll(classConflictsByClass(classId));

        } catch (Exception ex) {
            ex.printStackTrace();

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(503, messageSource.getMessage("database.not.accessible", null, locale));
        }

        return allClassAlarmDTO;
    }
    //*********************************

    //*********************************
    //******old code for alarms********
    //*********************************
    //*********************************
    //*********************************
    //*********************************
    /*point : for ended classes do not fetch alarms && only check alarm for current term*/

    @Override
    public List<String> hasAlarm(Long class_id, HttpServletResponse response) throws IOException {

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));


        List<String> AlarmList = null;
        List<ClassAlarmDTO> classAlarmDTO = null;
        try {

            List<String> alarmScripts = new ArrayList<>();

            //*****time of sessions*****
            alarmScripts.add(" SELECT " +
                    " 'has alarm' AS hasalarm " +
                    " FROM " +
                    "    ( " +
                    "        SELECT" +
                    "            tbl_session.f_class_id, " +
                    "            concat(concat(concat(concat('???????? ',tbl_class.c_title_class),' ???? ???? '),tbl_class.c_code),' : ') AS class_name, " +
                    "            SUM(round(to_number(TO_DATE(tbl_session.c_session_end_hour,'HH24:MI') - TO_DATE(tbl_session.c_session_start_hour,'HH24:MI') ) * 24 * 60) " +
                    " ) AS session_time, " +
                    "            ( tbl_class.n_h_duration * 60 ) AS class_time " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "        WHERE " +
                    "            tbl_session.f_class_id =:class_id " +
                    "        GROUP BY " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_class.n_h_duration, " +
                    "            tbl_class.c_code, " +
                    "            tbl_class.c_title_class " +
                    "    ) " +
                    " WHERE " +
                    "    floor(abs( (class_time - session_time) / 60) ) > 0 AND :todaydat = :todaydat AND rownum = 1 ");


            //*****attendance*****
            alarmScripts.add(" SELECT " +
                    "    'has alarm' AS hasalarm " +
                    " FROM " +
                    "    tbl_class_student " +
                    "    INNER JOIN tbl_session ON tbl_class_student.class_id = tbl_session.f_class_id " +
                    "    LEFT JOIN tbl_attendance ON tbl_session.id = tbl_attendance.f_session " +
                    " WHERE " +
                    "    tbl_session.f_class_id =:class_id " +
                    "    AND   tbl_session.c_session_date <:todaydat " +
                    "    AND   ( " +
                    "        tbl_attendance.c_state IS NULL " +
                    "        OR    tbl_attendance.c_state = 0 " +
                    "    ) AND rownum = 1 ");

            //*****class capacity*****
            alarmScripts.add(" SELECT " +
                    " 'has alarm' AS hasalarm " +
                    " FROM " +
                    "    tbl_class " +
                    "    INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id " +
                    " WHERE " +
                    "    tbl_class.id =:class_id " +
                    " GROUP BY " +
                    "    tbl_class.id, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity " +
                    " HAVING (COUNT(tbl_class_student.student_id) > tbl_class.n_max_capacity " +
                    "       OR COUNT(tbl_class_student.student_id) < tbl_class.n_min_capacity) AND :todaydat = :todaydat ");

            //*****check list not verify*****
            alarmScripts.add(" SELECT  " +
                    "    'has alarm' AS hasalarm  " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_check_list.id, " +
                    "            tbl_check_list.c_title_fa, " +
                    "            tbl_check_list_item.id AS iditem, " +
                    "            tbl_check_list_item.c_group, " +
                    "            tbl_check_list_item.c_title_fa AS c_title_fa1, " +
                    "            tbl_check_list_item.b_is_deleted, " +
                    "            :class_id AS class_id " +
                    "        FROM " +
                    "            tbl_check_list " +
                    "            INNER JOIN tbl_check_list_item ON tbl_check_list.id = tbl_check_list_item.f_check_list_id " +
                    "        WHERE " +
                    "            tbl_check_list_item.b_is_deleted IS NULL " +
                    "    ) tbchecklist " +
                    "    LEFT JOIN tbl_class_check_list ON tbchecklist.iditem = tbl_class_check_list.f_check_list_item_id " +
                    "                                      AND tbchecklist.class_id = tbl_class_check_list.f_tclass_id " +
                    " WHERE " +
                    "    tbl_class_check_list.c_description IS NULL " +
                    "    AND   ( " +
                    "        tbl_class_check_list.b_enabled IS NULL " +
                    "        OR    tbl_class_check_list.b_enabled = 0 " +
                    "    ) " +
                    "    AND rownum=1 AND :todaydat = :todaydat ");

            //*****teacher conflict*****
            alarmScripts.add(" SELECT " +
                    " 'has alarm' AS hasalarm " +
                    " FROM " +
                    "    tbl_session tb1 " +
                    "    INNER JOIN tbl_session tb2 ON tb2.f_teacher_id = tb1.f_teacher_id " +
                    "                                  AND tb1.c_session_date = tb2.c_session_date " +
                    "    INNER JOIN tbl_teacher ON tbl_teacher.id = tb1.f_teacher_id " +
                    "    INNER JOIN tbl_personal_info ON tbl_personal_info.id = tbl_teacher.f_personality " +
                    "    INNER JOIN tbl_class ON tbl_class.id = tb2.f_class_id " +
                    " WHERE " +
                    "    tb1.id <> tb2.id AND :todaydat = :todaydat " +
                    "    AND   tb1.f_class_id =:class_id " +
                    "    AND   ( " +
                    "        ( " +
                    "            tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "        ) " +
                    "        OR    ( " +
                    "            tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "            AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "        ) " +
                    "    ) AND rownum = 1 ");

            //*****student place conflict*****
            alarmScripts.add(" SELECT " +
                    " 'has alarm' AS hasalarm " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.student_id, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no " +
                    "        FROM" +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "    ) tb1" +
                    "    INNER JOIN ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.student_id, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no " +
                    "        FROM" +
                    "            tbl_session" +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "    ) tb2 ON tb2.c_session_date = tb1.c_session_date " +
                    "             AND tb2.national_code = tb1.national_code " +
                    " WHERE" +
                    "    tb1.id <> tb2.id  AND :todaydat = :todaydat " +
                    "    AND   (" +
                    "        (" +
                    "            tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "        )" +
                    "        OR    (" +
                    "            tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "            AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "        )" +
                    "    )" +
                    "    AND   tb1.f_class_id =:class_id AND rownum = 1 ");

            //*****training place conflict*****
            alarmScripts.add(" SELECT " +
                    "    'has alarm' AS hasalarm " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_session.f_institute_id, " +
                    "            tbl_institute.c_title_fa, " +
                    "            tbl_session.f_training_place_id, " +
                    "            tbl_training_place.c_title_fa AS c_title_fa1 " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "            INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "    ) tb1 " +
                    "    INNER JOIN ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_session.f_institute_id, " +
                    "            tbl_institute.c_title_fa, " +
                    "            tbl_session.f_training_place_id, " +
                    "            tbl_training_place.c_title_fa AS c_title_fa1, " +
                    "            tbl_class.c_code, " +
                    "            tbl_class.c_title_class " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "            INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "    ) tb2 ON tb1.c_session_date = tb2.c_session_date " +
                    "             AND tb1.f_institute_id = tb2.f_institute_id " +
                    "             AND tb1.f_training_place_id = tb2.f_training_place_id " +
                    " WHERE " +
                    "    tb1.id <> tb2.id AND :todaydat = :todaydat " +
                    "    AND   tb1.f_class_id =:class_id " +
                    "    AND   ( " +
                    "        ( " +
                    "            tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "        ) " +
                    "        OR    ( " +
                    "            tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "            AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "        ) " +
                    "    ) AND rownum = 1 ");


            //*****pre course test question*****
            alarmScripts.add(" SELECT " +
                    "    'has alarm' AS hasalarm " +
                    " FROM " +
                    "    tbl_class " +
                    "    LEFT JOIN tbl_class_pre_course_test_question ON tbl_class_pre_course_test_question.f_class_id = tbl_class.id " +
                    " WHERE " +
                    "    tbl_class.id =:class_id and tbl_class.pre_course_test = 1 and tbl_class_pre_course_test_question.f_class_id is null AND :todaydat = :todaydat ");

            //*****evaluation behaviour for student*****
            alarmScripts.add(" SELECT " +
                    "    'has alarm' AS hasalarm  " +
                    "FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_class.id, " +
                    "            '???????? ' " +
                    "            || COUNT(tbl_class.id) " +
                    "            || ' ???????????? ?????? ???????? ?????????????? ???????????? ???????? ???????? ??????' AS alarm " +
                    "        FROM " +
                    "            tbl_class " +
                    "            INNER JOIN tbl_class_student ON tbl_class_student.class_id = tbl_class.id " +
                    "            INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id " +
                    "        WHERE " +
                    "            tbl_class.id = :class_id " +
                    "            AND tbl_course.c_evaluation = 3 " +
                    "            AND tbl_class.c_status = 3 " +
                    "            AND ( tbl_class_student.evaluation_status_behavior IS NULL " +
                    "                  OR tbl_class_student.evaluation_status_behavior = 0 ) " +
                    "            AND trunc(add_months(tbl_class.c_status_date,( " +
                    "                CASE " +
                    "                    WHEN tbl_class.start_evaluation IS NULL THEN " +
                    "                        0 " +
                    "                    ELSE " +
                    "                        tbl_class.start_evaluation " +
                    "                END " +
                    "            ))) - trunc(sysdate) <= 14 " +
                    "        GROUP BY " +
                    "            tbl_class.id " +
                    "        HAVING " +
                    "            COUNT(tbl_class.id) > 0 AND :todaydat = :todaydat " +
                    "    ) ");


            for (String script : alarmScripts) {
                AlarmList = (List<String>) entityManager.createNativeQuery(script)
                        .setParameter("class_id", class_id)
                        .setParameter("todaydat", todayDate).getResultList();

                if (AlarmList.size() > 0)
                    break;
            }


        } catch (Exception ex) {
            ex.printStackTrace();

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(503, messageSource.getMessage("database.not.accessible", null, locale));
        }

        return AlarmList;

    }
    //*********************************

    //*********************************
    /*point : for ended classes do not fetch alarms && only check alarm for current term */
//    @Override
    public List<ClassAlarmDTO> list_old(Long class_id, HttpServletResponse response) throws IOException {

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));

        ////*** Wildcard ***
        List<?> AlarmList = null;
        List<ClassAlarmDTO> classAlarmDTO = null;
        try {

            //*****time of sessions*****
            StringBuilder alarmScript = new StringBuilder().append(" SELECT " +
                    "    f_class_id AS targetRecordId, " +
                    "    'classSessionsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    '??????????' AS alarmType, " +
                    "   (CASE WHEN floor( (class_time - session_time) / 60) > 0 THEN concat(concat('?????????? ?????????? ?????????? ',floor( (class_time - session_time) / 60) ),' ???????? ???????? ???? ?????? ???????? ??????') " +
                    "                            ELSE concat(concat('?????????? ?????????? ?????????? ',abs(floor( (class_time - session_time) / 60) ) ),' ???????? ?????????? ???? ?????? ???????? ??????') END) AS alarm,     " +
                    " 1 AS detailRecordId, " +
                    " '??????????' AS sortField " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.f_class_id, " +
                    "            concat(concat(concat(concat('???????? ',tbl_class.c_title_class),' ???? ???? '),tbl_class.c_code),' : ') AS class_name, " +
                    "            SUM(round(to_number(TO_DATE(tbl_session.c_session_end_hour,'HH24:MI') - TO_DATE(tbl_session.c_session_start_hour,'HH24:MI') ) * 24 * 60)) AS session_time, " +
                    "            ( tbl_class.n_h_duration * 60 ) AS class_time " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "        WHERE tbl_session.f_class_id = :class_id " +
                    "        GROUP BY " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_class.n_h_duration, " +
                    "            tbl_class.c_code, " +
                    "            tbl_class.c_title_class " +
                    "    ) " +
                    " WHERE " +
                    "    floor(abs((class_time - session_time) / 60)) > 0");

            alarmScript.append(" UNION ALL ");

            //*****attendance*****
            alarmScript.append(" SELECT DISTINCT targetRecordId, tabName, pageAddress, alarmType, alarm, detailRecordId, sortField " +
                    " FROM " +
                    " ( " +
                    " SELECT tbl_session.f_class_id AS targetRecordId, " +
                    "    'classAttendanceTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    '???????? ?? ????????' AS alarmType, " +
                    " ('???????? ?? ???????? ' || '???????? ' ||  tbl_session.c_session_start_hour || ' ???? ' || tbl_session.c_session_end_hour || ' ' || tbl_session.c_day_name || ' ?????????? ' || tbl_session.c_session_date || ' ?????????? ???????? ??????') as alarm, " +
                    "    tbl_session.id AS detailRecordId, " +
                    "    ('???????? ?? ????????' || tbl_session.c_session_date || tbl_session.c_session_start_hour) AS sortField  " +
                    " FROM " +
                    "    tbl_class_student " +
                    "    INNER JOIN tbl_session ON tbl_class_student.class_id = tbl_session.f_class_id " +
                    "    LEFT JOIN tbl_attendance ON tbl_session.id = tbl_attendance.f_session " +
                    " WHERE  " +
                    "    tbl_session.f_class_id = :class_id  " +
                    "    AND tbl_session.c_session_date <:todaydat " +
                    "    AND (tbl_attendance.c_state IS NULL OR tbl_attendance.c_state = 0) " +
                    " ) ");

            alarmScript.append(" UNION ALL ");

            //*****class capacity*****
            alarmScript.append(" SELECT targetRecordId, tabName, pageAddress, alarmType,  " +
                    " ('?????????? ???????? ?????????????? ???????? ???? ' ||  CASE WHEN status = 'MAX' THEN '???????????? ?????????? ???????? ??????????' ELSE '?????????? ?????????? ???????? ????????' END || ' ??????')  AS alarm, " +
                    " 1 AS detailRecordId, sortField " +
                    " FROM " +
                    " (SELECT " +
                    "    tbl_class.id AS targetRecordId, " +
                    "    'classStudentsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    '?????????? ????????' AS alarmType, " +
                    "      ('?????????? ????????'|| ' ' || tbl_class.id) AS sortField, " +
                    "      CASE WHEN COUNT(tbl_class_student.student_id) > tbl_class.n_max_capacity THEN 'MAX' WHEN " +
                    "                COUNT(tbl_class_student.student_id) < tbl_class.n_min_capacity THEN 'MIN' END AS status, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity, " +
                    "   COUNT(tbl_class_student.student_id) AS studentCount " +
                    " FROM " +
                    "    tbl_class " +
                    "    INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id " +
                    " WHERE tbl_class.id = :class_id " +
                    "    GROUP BY      " +
                    "    tbl_class.id, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity " +
                    "    HAVING COUNT(tbl_class_student.student_id) > tbl_class.n_max_capacity OR " +
                    "           COUNT(tbl_class_student.student_id) < tbl_class.n_min_capacity) ");

            alarmScript.append(" UNION ALL ");

            //*****check list not verify*****
            alarmScript.append(" SELECT DISTINCT " +
                    "    class_id AS targetrecordid, 'classCheckListTab' AS tabname, '/tclass/show-form' AS pageaddress, '?????? ?????????? ???? ????????' AS alarmtype, " +
                    "    '???? ???? ???????? \"' || tbchecklist.c_title_fa || '\" ?????? \"' || tbchecklist.c_group || '\" ???????? \"' || tbchecklist.c_title_fa1 " +
                    "    || '\" ?????????? ?????????? ???????? ?????? (???????????? ???? ?????? ??????????????)' AS alarm, " +
                    "    1 AS detailrecordid, ( '?????? ?????????? ???? ????????' || tbchecklist.id || '-' || tbchecklist.iditem ) AS sortfield " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_check_list.id, " +
                    "            tbl_check_list.c_title_fa, " +
                    "            tbl_check_list_item.id AS iditem, " +
                    "            tbl_check_list_item.c_group, " +
                    "            tbl_check_list_item.c_title_fa AS c_title_fa1, " +
                    "            tbl_check_list_item.b_is_deleted, " +
                    "            :class_id AS class_id " +
                    "        FROM " +
                    "            tbl_check_list " +
                    "            INNER JOIN tbl_check_list_item ON tbl_check_list.id = tbl_check_list_item.f_check_list_id " +
                    "        WHERE " +
                    "            ( tbl_check_list_item.b_is_deleted IS NULL ) " +
                    "    ) tbchecklist " +
                    "    LEFT JOIN tbl_class_check_list ON tbchecklist.iditem = tbl_class_check_list.f_check_list_item_id " +
                    "                                      AND tbchecklist.class_id = tbl_class_check_list.f_tclass_id " +
                    " WHERE  tbl_class_check_list.c_description IS NULL " +
                    "    AND (tbl_class_check_list.b_enabled IS NULL OR tbl_class_check_list.b_enabled = 0 ) ");

            alarmScript.append(" UNION ALL ");

            //*****teacher conflict*****
            alarmScript.append(" SELECT targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, '?????????? ????????' AS alarmType, " +
                    "       '???????? ' || c_session_start_hour ||  ' ???? ' || c_session_end_hour || ' ' || c_day_name || ' ' || c_session_date || ' '|| teachername ||' ???? ???????? '|| c_session_start_hour1 ||' ???? '|| c_session_end_hour1 ||' '   || c_day_name1  || ' '|| c_session_date1||' ???????? '|| c_title_class ||' ???? ???? '|| c_code ||' ?????????? ????????' AS alarm, " +
                    "       id1 AS detailRecordId, sortField " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tb1.id, " +
                    "            tb1.f_class_id AS targetRecordId, " +
                    "            tb1.c_day_name, " +
                    "            tb1.c_session_date, " +
                    "            tb1.c_session_end_hour, " +
                    "            tb1.c_session_start_hour, " +
                    "            tb2.id AS id1, " +
                    "            tb2.f_class_id AS f_class_id1, " +
                    "            tb2.c_day_name AS c_day_name1, " +
                    "            tb2.c_session_date AS c_session_date1, " +
                    "            tb2.c_session_end_hour AS c_session_end_hour1, " +
                    "            tb2.c_session_start_hour AS c_session_start_hour1, " +
                    "            ( ( " +
                    "                CASE " +
                    "                    WHEN tbl_personal_info.e_gender = 1 THEN '????????' " +
                    "                    ELSE '????????' " +
                    "                END " +
                    "            ) " +
                    "            || ' ' " +
                    "            || tbl_personal_info.c_first_name_fa " +
                    "            || ' ' " +
                    "            || tbl_personal_info.c_last_name_fa ) AS teachername, " +
                    "            tbl_class.c_code, " +
                    "            tbl_class.c_title_class, " +
                    "            (' ?????????? ???????? ' || tb1.c_session_date " +
                    "            || '_' " +
                    "            || tb1.c_session_end_hour " +
                    "            || '_' " +
                    "            || tb1.c_session_start_hour ) AS sortfield " +
                    "        FROM " +
                    "            tbl_session tb1 " +
                    "            INNER JOIN tbl_session tb2 ON tb2.f_teacher_id = tb1.f_teacher_id " +
                    "                                          AND tb1.c_session_date = tb2.c_session_date " +
                    "            INNER JOIN tbl_teacher ON tbl_teacher.id = tb1.f_teacher_id " +
                    "            INNER JOIN tbl_personal_info ON tbl_personal_info.id = tbl_teacher.f_personality " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tb2.f_class_id " +
                    "        WHERE " +
                    "            tb1.id <> tb2.id " +
                    "            AND   tb1.f_class_id =:class_id " +
                    "            AND   ( " +
                    "                ( " +
                    "                    tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "                    AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "                ) " +
                    "                OR    ( " +
                    "                    tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "                    AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "                ) " +
                    "            ) " +
                    "    ) ");

            alarmScript.append(" UNION ALL ");

            //*****student place conflict*****
            alarmScript.append("SELECT tb1.f_class_id AS targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, '?????????? ????????????' AS alarmType, " +
                    "    ' ???????? ' " +
                    "    || tb1.c_session_start_hour " +
                    "    || ' ???? ' " +
                    "    || tb1.c_session_end_hour " +
                    "    || ' ' " +
                    "    || tb1.c_day_name " +
                    "    || ' ' " +
                    "    || tb1.c_session_date " +
                    "    || ' ' " +
                    "    || tb1.studentName " +
                    "    || ' ???? ???????? ' " +
                    "    || tb2.c_session_start_hour " +
                    "    || ' ???? ' " +
                    "    || tb2.c_session_end_hour " +
                    "    || ' ' " +
                    "    || tb2.c_day_name " +
                    "    || ' ' " +
                    "    || tb2.c_session_date " +
                    "    || ' ' " +
                    "    || tb2.classname " +
                    "    || ' ?????????? ????????' AS alarm, " +
                    "    tb2.id AS detailRecordId, " +
                    "    (tb1.studentName || ' ?????????? ???????????? ' || tb1.c_session_date || tb1.c_session_start_hour || tb1.c_session_end_hour ) AS sortField " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.student_id, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no, " +
                    "            ( " +
                    "                CASE " +
                    "                    WHEN tbl_student.gender_title = '??????' THEN ' ???????? ' " +
                    "                    ELSE ' ???????? ' " +
                    "                END " +
                    "            || tbl_student.first_name " +
                    "            || ' ' " +
                    "            || tbl_student.last_name " +
                    "            || ' ???? ?????????? ???????????? ' " +
                    "            || tbl_student.personnel_no ) AS studentName " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "    ) tb1 " +
                    "    INNER JOIN ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.student_id, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no, " +
                    "            ( " +
                    "                CASE " +
                    "                    WHEN tbl_student.gender_title = '??????' THEN ' ???????? ' " +
                    "                    ELSE ' ???????? ' " +
                    "                END " +
                    "            || tbl_student.first_name " +
                    "            || ' ' " +
                    "            || tbl_student.last_name " +
                    "            || ' ???? ?????????? ???????????? ' " +
                    "            || tbl_student.personnel_no ) AS studentName, " +
                    "            ( ' ???????? ' " +
                    "            || tbl_class.c_title_class " +
                    "            || ' ???? ???? ' " +
                    "            || tbl_class.c_code ) AS classname " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id " +
                    "            INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "    ) tb2 ON tb2.c_session_date = tb1.c_session_date " +
                    "             AND tb2.national_code = tb1.national_code " +
                    " WHERE " +
                    "    tb1.id <> tb2.id " +
                    "    AND   ( " +
                    "        ( " +
                    "            tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "            AND   tb1.c_session_start_hour < tb2.c_session_end_hour " +
                    "        ) " +
                    "        OR    ( " +
                    "            tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "            AND   tb1.c_session_end_hour > tb2.c_session_start_hour " +
                    "        ) " +
                    "    ) " +
                    "    AND   tb1.f_class_id =:class_id ");


            alarmScript.append(" UNION ALL ");

            //*****training place conflict*****
            alarmScript.append(" SELECT " +
                    "    tbalarm.targetrecordid, " +
                    "    tbalarm.tabname, " +
                    "    tbalarm.pageaddress, " +
                    "    tbalarm.alarmtype, " +
                    "    (tbalarm.alarm || ' _ ???????? ?????????????? ???????? : ' || CASE WHEN tbfreeplaces.freeplaces IS NULL THEN '?????????? ???????? ???????? ??????????' ELSE tbfreeplaces.freeplaces END) AS alarm, " +
                    "    tbalarm.detailrecordid, " +
                    "    tbalarm.sortfield " +
                    "FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tb1.f_class_id AS targetrecordid, " +
                    "            'classSessionsTab' AS tabname, " +
                    "            '/tclass/show-form' AS pageaddress, " +
                    "            '?????????? ?????? ??????????????' AS alarmtype, " +
                    "            '?????? ?????????????? ' " +
                    "            || tb1.c_title_fa1 " +
                    "            || ' ?????????? ' " +
                    "            || tb1.c_title_fa " +
                    "            || ' ?????? ' " +
                    "            || tb1.c_day_name " +
                    "            || ' ' " +
                    "            || tb1.c_session_date " +
                    "            || ' ???? ' " +
                    "            || tb1.c_session_start_hour " +
                    "            || ' ???? ' " +
                    "            || tb1.c_session_end_hour " +
                    "            || ' ???? ???????? ' " +
                    "            || tb2.c_title_class " +
                    "            || ' ???? ' " +
                    "            || tb2.c_code " +
                    "            || ' ?????????? ????????' AS alarm, " +
                    "            tb1.id AS detailrecordid, " +
                    "            ( '?????????? ?????? ??????????????' " +
                    "            || tb1.c_title_fa1 " +
                    "            || tb1.c_title_fa " +
                    "            || tb1.c_session_date " +
                    "            || tb1.c_session_start_hour " +
                    "            || tb1.c_session_end_hour ) AS sortfield, " +
                    "            tb1.c_session_date, " +
                    "            tb1.c_session_start_hour, " +
                    "            tb1.c_session_end_hour, " +
                    "            tb1.f_institute_id " +
                    "        FROM " +
                    "            ( " +
                    "                SELECT " +
                    "                    tbl_session.id, " +
                    "                    tbl_session.f_class_id, " +
                    "                    tbl_session.c_day_name, " +
                    "                    tbl_session.c_session_date, " +
                    "                    tbl_session.c_session_end_hour, " +
                    "                    tbl_session.c_session_start_hour, " +
                    "                    tbl_session.f_institute_id, " +
                    "                    tbl_institute.c_title_fa, " +
                    "                    tbl_session.f_training_place_id, " +
                    "                    tbl_training_place.c_title_fa AS c_title_fa1 " +
                    "                FROM " +
                    "                    tbl_session " +
                    "                    INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "                    INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "            ) tb1 " +
                    "            INNER JOIN ( " +
                    "                SELECT " +
                    "                    tbl_session.id, " +
                    "                    tbl_session.f_class_id, " +
                    "                    tbl_session.c_day_name, " +
                    "                    tbl_session.c_session_date, " +
                    "                    tbl_session.c_session_end_hour, " +
                    "                    tbl_session.c_session_start_hour, " +
                    "                    tbl_session.f_institute_id, " +
                    "                    tbl_institute.c_title_fa, " +
                    "                    tbl_session.f_training_place_id, " +
                    "                    tbl_training_place.c_title_fa AS c_title_fa1, " +
                    "                    tbl_class.c_code, " +
                    "                    tbl_class.c_title_class " +
                    "                FROM " +
                    "                    tbl_session " +
                    "                    INNER JOIN tbl_institute ON tbl_institute.id = tbl_session.f_institute_id " +
                    "                    INNER JOIN tbl_training_place ON tbl_training_place.id = tbl_session.f_training_place_id " +
                    "                    INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id " +
                    "            ) tb2 ON tb1.c_session_date = tb2.c_session_date " +
                    "                     AND tb1.f_institute_id = tb2.f_institute_id " +
                    "                     AND tb1.f_training_place_id = tb2.f_training_place_id " +
                    "        WHERE " +
                    "            tb1.f_class_id = :class_id AND " +
                    "            tb1.id <> tb2.id " +
                    "            AND   ( " +
                    "                (tb1.c_session_start_hour >= tb2.c_session_start_hour " +
                    "                AND   tb1.c_session_start_hour < tb2.c_session_end_hour) " +
                    "                OR    (tb1.c_session_end_hour <= tb2.c_session_end_hour " +
                    "                AND   tb1.c_session_end_hour > tb2.c_session_start_hour) " +
                    "            ) " +
                    "    ) tbalarm " +
                    "    LEFT JOIN ( " +
                    "        SELECT " +
                    "            c_session_date, " +
                    "            c_session_start_hour, " +
                    "            c_session_end_hour, " +
                    "            f_institute_id, " +
                    "            LISTAGG(c_title_fa, " +
                    "            ' , ') WITHIN GROUP( " +
                    "            ORDER BY " +
                    "                c_title_fa " +
                    "            ) AS freeplaces " +
                    "        FROM " +
                    "            ( " +
                    "                SELECT DISTINCT " +
                    "                    tba.c_session_date, " +
                    "                    tba.c_session_start_hour, " +
                    "                    tba.c_session_end_hour, " +
                    "                    tba.f_institute_id, " +
                    "                    tba.c_title_fa " +
                    "                FROM " +
                    "                    ( " +
                    "                        SELECT " +
                    "                            tbsession.c_session_date, " +
                    "                            tbsession.c_session_start_hour, " +
                    "                            tbsession.c_session_end_hour, " +
                    "                            tbsession.f_institute_id, " +
                    "                            tbsession.f_training_place_id, " +
                    "                            tbl_training_place.id, " +
                    "                            tbl_training_place.f_institute, " +
                    "                            tbl_training_place.c_title_fa, " +
                    "                            CASE " +
                    "                                    WHEN tbsession.f_training_place_id = tbl_training_place.id THEN 'YES' " +
                    "                                    ELSE 'NO' " +
                    "                                END " +
                    "                            AS status " +
                    "                        FROM " +
                    "                            ( " +
                    "                                SELECT DISTINCT " +
                    "                                    tbl_session.c_session_date, " +
                    "                                    tbl_session.c_session_start_hour, " +
                    "                                    tbl_session.c_session_end_hour, " +
                    "                                    tbl_session.f_institute_id, " +
                    "                                    tbl_session.f_training_place_id " +
                    "                                FROM " +
                    "                                    tbl_session " +
                    "                            ) tbsession, " +
                    "                            tbl_training_place " +
                    "                        WHERE " +
                    "                            tbsession.f_institute_id = tbl_training_place.f_institute " +
                    "                    ) tba " +
                    "                    LEFT JOIN ( " +
                    "                        SELECT " +
                    "                            tbsession.c_session_date, " +
                    "                            tbsession.c_session_start_hour, " +
                    "                            tbsession.c_session_end_hour, " +
                    "                            tbsession.f_institute_id, " +
                    "                            tbsession.f_training_place_id, " +
                    "                            tbl_training_place.id, " +
                    "                            tbl_training_place.f_institute, " +
                    "                            tbl_training_place.c_title_fa, " +
                    "                            CASE " +
                    "                                    WHEN tbsession.f_training_place_id = tbl_training_place.id THEN 'YES' " +
                    "                                    ELSE 'NO' " +
                    "                                END " +
                    "                            AS status " +
                    "                        FROM " +
                    "                            ( " +
                    "                                SELECT DISTINCT " +
                    "                                    tbl_session.c_session_date, " +
                    "                                    tbl_session.c_session_start_hour, " +
                    "                                    tbl_session.c_session_end_hour, " +
                    "                                    tbl_session.f_institute_id, " +
                    "                                    tbl_session.f_training_place_id " +
                    "                                FROM " +
                    "                                    tbl_session " +
                    "                            ) tbsession, " +
                    "                            tbl_training_place " +
                    "                        WHERE " +
                    "                            tbsession.f_institute_id = tbl_training_place.f_institute " +
                    "                            AND   tbsession.f_training_place_id = tbl_training_place.id " +
                    "                    ) tbb ON tbb.c_session_date = tba.c_session_date " +
                    "                             AND tbb.c_session_start_hour = tba.c_session_start_hour " +
                    "                             AND tbb.c_session_end_hour = tba.c_session_end_hour " +
                    "                             AND tbb.f_institute_id = tba.f_institute_id " +
                    "                             AND tba.id = tbb.id " +
                    "                WHERE " +
                    "                    tbb.status IS NULL " +
                    "            ) " +
                    "        GROUP BY " +
                    "            c_session_date, " +
                    "            c_session_start_hour, " +
                    "            c_session_end_hour, " +
                    "            f_institute_id " +
                    "    ) tbfreeplaces ON tbfreeplaces.c_session_date = tbalarm.c_session_date " +
                    "                      AND tbfreeplaces.c_session_start_hour = tbalarm.c_session_start_hour " +
                    "                      AND tbfreeplaces.c_session_end_hour = tbalarm.c_session_end_hour " +
                    "                      AND tbfreeplaces.f_institute_id = tbalarm.f_institute_id ");

            alarmScript.append(" UNION ALL ");

            //*****pre course test question*****
            alarmScript.append(" SELECT " +
                    "    tbl_class.id AS targetRecordId, " +
                    "    'classPreCourseTestQuestionsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    '???????????? ?????? ??????????' AS alarmType, " +
                    "    '???????????? ?????????? ?????? ???? ?????????????? ???????? ?????? ???????? ??????.'  AS alarm, " +
                    "    1 AS detailRecordId, " +
                    "    '???????????? ?????? ??????????' AS sortField " +
                    " FROM " +
                    "    tbl_class  " +
                    "    LEFT JOIN tbl_class_pre_course_test_question ON tbl_class_pre_course_test_question.f_class_id = tbl_class.id " +
                    " WHERE " +
                    "    tbl_class.id =:class_id and tbl_class.pre_course_test = 1 and tbl_class_pre_course_test_question.f_class_id is null ");

            alarmScript.append(" UNION ALL ");

            //*****evaluation behaviour for student*****
            alarmScript.append(" SELECT  " +
                    " id AS targetRecordId, " +
                    " 'tabName' AS tabName, " +
                    " '/tclass/show-form' AS pageAddress, " +
                    " '?????? ???????? ?????????????? ????????????' AS alarmType, " +
                    " alarm, " +
                    "   1 AS detailRecordId, " +
                    "   '?????? ???????? ?????????????? ????????????' AS sortField " +
                    " FROM " +
                    " (SELECT " +
                    " tbl_class.id,  '???????? ' || COUNT( tbl_class.id) || ' ???????????? ?????? ???????? ?????????????? ???????????? ???????? ???????? ??????'  as alarm " +
                    " FROM " +
                    "    tbl_class " +
                    "    INNER JOIN tbl_class_student ON tbl_class_student.class_id = tbl_class.id " +
                    "    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id " +
                    " WHERE " +
                    " tbl_class.id = :class_id AND " +
                    "    tbl_course.c_evaluation = 3 AND " +
                    "    tbl_class.c_status = 3 " +
                    "    AND ( tbl_class_student.evaluation_status_behavior IS NULL " +
                    "          OR tbl_class_student.evaluation_status_behavior = 0 ) " +
                    " AND      " +
                    "    trunc(ADD_MONTHS(tbl_class.c_status_date, (CASE WHEN tbl_class.start_evaluation IS NULL THEN 0 ELSE tbl_class.start_evaluation END))) - trunc(sysdate) <= 14  " +
                    " GROUP BY tbl_class.id     " +
                    " HAVING COUNT( tbl_class.id) > 0) " +
                    " ORDER BY sortField ");

            //***order by must be in the last script***

            AlarmList = (List<?>) entityManager.createNativeQuery(alarmScript.toString())
                    .setParameter("class_id", class_id)
                    .setParameter("todaydat", todayDate).getResultList();

            if (AlarmList != null) {
                classAlarmDTO = new ArrayList<>(AlarmList.size());

                for (int i = 0; i < AlarmList.size(); i++) {
                    Object[] alarm = (Object[]) AlarmList.get(i);
                    //Old// classAlarmDTO.add(new ClassAlarmDTO(Long.parseLong(alarm[0].toString()), alarm[1].toString(), alarm[2].toString(), alarm[3].toString(), alarm[4].toString()));

                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(503, messageSource.getMessage("database.not.accessible", null, locale));
        }

        return (classAlarmDTO != null ? modelMapper.map(classAlarmDTO, new TypeToken<List<ClassAlarmDTO>>() {
        }.getType()) : null);

    }
    //*********************************

    //*********************************
    /*point : for ended classes do not fetch alarms && only check alarm for current term*/
    @Override
    public String checkAlarmsForEndingClass(Long class_id, String endDate, HttpServletResponse response) throws IOException {

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));

        StringBuilder AlarmList = new StringBuilder();
        StringBuilder endingClassAlarm = new StringBuilder();

        try {

            List<String> alarmScripts = new ArrayList<>();

            //*****check list not verify*****
            alarmScripts.add(" SELECT  " +
                    "    '???? ???????? ????' AS hasalarm  " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_check_list.id, " +
                    "            tbl_check_list.c_title_fa, " +
                    "            tbl_check_list_item.id AS iditem, " +
                    "            tbl_check_list_item.c_group, " +
                    "            tbl_check_list_item.c_title_fa AS c_title_fa1, " +
                    "            tbl_check_list_item.b_is_deleted, " +
                    "            :class_id AS class_id " +
                    "        FROM " +
                    "            tbl_check_list " +
                    "            INNER JOIN tbl_check_list_item ON tbl_check_list.id = tbl_check_list_item.f_check_list_id " +
                    "        WHERE " +
                    "            tbl_check_list_item.b_is_deleted IS NULL " +
                    "    ) tbchecklist " +
                    "    LEFT JOIN tbl_class_check_list ON tbchecklist.iditem = tbl_class_check_list.f_check_list_item_id " +
                    "                                      AND tbchecklist.class_id = tbl_class_check_list.f_tclass_id " +
                    " WHERE " +
                    "    tbl_class_check_list.c_description IS NULL " +
                    "    AND   ( " +
                    "        tbl_class_check_list.b_enabled IS NULL " +
                    "        OR    tbl_class_check_list.b_enabled = 0 " +
                    "    ) " +
                    "    AND rownum=1 AND :todaydat = :todaydat ");


            for (String script : alarmScripts) {

                List<?> Alarm = (List<?>) entityManager.createNativeQuery(script)
                        .setParameter("class_id", class_id)
                        .setParameter("todaydat", todayDate).getResultList();

                if (!Alarm.isEmpty())
                    AlarmList.append(AlarmList.length() > 0 ? " ?? " + Alarm.get(0) : Alarm.get(0));
            }

            ////old code **> endingClassAlarm.append(AlarmList.length() > 0 ? "?????? ???? ?????????? ???????? ???????????????? " + AlarmList.toString() + " ???? ?????????? ?? ?????????? ????????????." : "");
            if (endDate.replaceAll("-", "/").compareTo(todayDate) > 0)
                endingClassAlarm.append("?????????? ?????????? ???????? " + endDate.replaceAll("-", "/") + " ???? ????????.<br />");

            if (classStudentDAO.countClassStudentsByTclassId(class_id) == 0)
                endingClassAlarm.append("???? ???????? ?????? ?????????????? ???????? ??????????.<br />");

            endingClassAlarm.append(AlarmList.length() > 0 ? "?????? ???? ?????????? ???????? " + AlarmList.toString() + " ???? ?????????? ?? ?????????? ????????????." : "");


            //*****score alarm*****

            String alarmLastScripts;

            //*****student score*****
            alarmLastScripts = " SELECT " +
                    "    '?????? ?????????? ???????? ?????????? ???????? ??????.' AS hasalarm " +
                    " FROM " +
                    "    tbl_class_student " +
                    " WHERE " +
                    "    tbl_class_student.class_id = :class_id " +
                    "    AND   tbl_class_student.failure_reason_id IS NULL " +
                    "    AND   tbl_class_student.score IS NULL " +
                    "    AND   (tbl_class_student.scores_state_id IS NULL OR  tbl_class_student.scores_state_id = 410) " +
                    "    AND   rownum = 1 AND :todaydat = :todaydat ";

            List<?> Alarm = (List<?>) entityManager.createNativeQuery(alarmLastScripts)
                    .setParameter("class_id", class_id)
                    .setParameter("todaydat", todayDate).getResultList();

            if (!Alarm.isEmpty())
                endingClassAlarm.append(endingClassAlarm.length() > 0 ? " <br />?? ???????????? " + Alarm.get(0) : Alarm.get(0));

        } catch (Exception ex) {
            ex.printStackTrace();

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(503, messageSource.getMessage("database.not.accessible", null, locale));
        }

        return endingClassAlarm.toString();

    }

    @Override
    public Integer deleteAllAlarmsBySessionIds(List<Long> sessionIds) {
        return alarmDAO.deleteAllBySessionIds(sessionIds);
    }
    //*********************************

    public List<ClassAlarmDTO> classConflictsByClass(Long classId) {
        List<ViewClassConflict> list = classConflictDAO.findAllByClass1Id(classId);
        List<ClassAlarmDTO> result = new ArrayList<>();
        if (list != null && !list.isEmpty()) {
            final Locale locale = LocaleContextHolder.getLocale();
            String alarmType = messageSource.getMessage("alarm.type.class.conflict", new Object[]{}, locale);
            for (ViewClassConflict conflict : list) {
                String warnMessage = messageSource.getMessage("alarm.class.conflict.warn", new Object[]{
                        conflict.getC2Code(),
                        conflict.getSessionDate(),
                        conflict.getSession2StartHour(),
                        conflict.getStudentFirstName(),
                        conflict.getStudentLastName(),
                        conflict.getStudentNationalCode(),
                }, locale);
                ClassAlarmDTO alarm = new ClassAlarmDTO();
                alarm.setClassId(conflict.getClass1Id());
                alarm.setClassIdConflict(conflict.getClass2Id());
                alarm.setSessionId(conflict.getId().getSession1Id());
                alarm.setSessionIdConflict(conflict.getId().getSession2Id());
                alarm.setStudentId(conflict.getId().getStudentId());
                alarm.setAlarmTypeTitleFa(alarmType);
                alarm.setAlarmTypeTitleEn("Class Concurrency");
                alarm.setAlarm(warnMessage);
                result.add(alarm);
            }
        }
        return result;
    }

    public List<ViewClassConflict> classConflictsByTerm(Long termId) {
        return classConflictDAO.findAllByTermId(termId);
    }
}
