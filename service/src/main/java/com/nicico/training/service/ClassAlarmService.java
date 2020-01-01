////*****rastegari 9809*****
package com.nicico.training.service;

import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.ClassAlarmDTO;
import com.nicico.training.iservice.IClassAlarm;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class ClassAlarmService implements IClassAlarm {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;
    private MessageSource messageSource;


    //*********************************
    /*point : for ended classes do not fetch alarms*/
    @Transactional
    @Override
    public List<ClassAlarmDTO> list(Long class_id, HttpServletResponse response) throws IOException {

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));

        ////*** Wildcard ***
        List<?> AlarmList = null;
        List<ClassAlarmDTO> classAlarmDTO = null;
        try {

            StringBuilder alarmScript = new StringBuilder().append(" SELECT " +
                    "    f_class_id AS targetRecordId, " +
                    "    'classSessionsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    'جلسات' AS alarmType, " +
                    "   (CASE WHEN floor( (class_time - session_time) / 60) > 0 THEN concat(concat('مجموع ساعات جلسات ',floor( (class_time - session_time) / 60) ),' ساعت کمتر از مدت کلاس است') " +
                    "                            ELSE concat(concat('مجموع ساعات جلسات ',abs(floor( (class_time - session_time) / 60) ) ),' ساعت بیشتر از مدت کلاس است') END) AS alarm,     " +
                    " 1 AS detailRecordId, " +
                    " 'جلسات' AS sortField " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.f_class_id, " +
                    "            concat(concat(concat(concat('کلاس ',tbl_class.c_title_class),' با کد '),tbl_class.c_code),' : ') AS class_name, " +
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

            alarmScript.append(" SELECT DISTINCT targetRecordId, tabName, pageAddress, alarmType, alarm, detailRecordId, sortField " +
                    " FROM " +
                    " ( " +
                    " SELECT tbl_session.f_class_id AS targetRecordId, " +
                    "    'classAttendanceTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    'حضور و غیاب' AS alarmType, " +
                    " ('حضور و غیاب ' || 'جلسه ' ||  tbl_session.c_session_start_hour || ' تا ' || tbl_session.c_session_end_hour || ' ' || tbl_session.c_day_name || ' تاریخ ' || tbl_session.c_session_date || ' تکمیل نشده است') as alarm, " +
                    "    tbl_session.id AS detailRecordId, " +
                    "    ('حضور و غیاب' || tbl_session.c_session_date || tbl_session.c_session_start_hour) AS sortField  " +
                    " FROM " +
                    "    tbl_class_student " +
                    "    INNER JOIN tbl_session ON tbl_class_student.f_class = tbl_session.f_class_id " +
                    "    LEFT JOIN tbl_attendance ON tbl_session.id = tbl_attendance.f_session " +
                    " WHERE  " +
                    "    tbl_session.f_class_id = :class_id  " +
                    "    AND tbl_session.c_session_date <:todaydat " +
                    "    AND (tbl_attendance.c_state IS NULL OR tbl_attendance.c_state = 0) " +
                    " ) ");

            alarmScript.append(" UNION ALL ");

            alarmScript.append(" SELECT targetRecordId, tabName, pageAddress, alarmType,  " +
                    " ('تعداد شرکت کنندگان کلاس از ' ||  CASE WHEN status = 'MAX' THEN 'حداکثر ظرفیت کلاس بیشتر' ELSE 'حداقل ظرفیت کلاس کمتر' END || ' است')  AS alarm, " +
                    " 1 AS detailRecordId, sortField " +
                    " FROM " +
                    " (SELECT " +
                    "    tbl_class.id AS targetRecordId, " +
                    "    'classStudentsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    'ظرفیت کلاس' AS alarmType, " +
                    "      ('ظرفیت کلاس'|| ' ' || tbl_class.id) AS sortField, " +
                    "      CASE WHEN COUNT(tbl_class_student.f_student) > tbl_class.n_max_capacity THEN 'MAX' WHEN " +
                    "                COUNT(tbl_class_student.f_student) < tbl_class.n_min_capacity THEN 'MIN' END AS status, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity, " +
                    "   COUNT(tbl_class_student.f_student) AS studentCount " +
                    " FROM " +
                    "    tbl_class " +
                    "    INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.f_class " +
                    " WHERE tbl_class.id = :class_id " +
                    "    GROUP BY      " +
                    "    tbl_class.id, " +
                    "    tbl_class.n_max_capacity, " +
                    "    tbl_class.n_min_capacity " +
                    "    HAVING COUNT(tbl_class_student.f_student) > tbl_class.n_max_capacity OR " +
                    "           COUNT(tbl_class_student.f_student) < tbl_class.n_min_capacity) ");


            alarmScript.append(" UNION ALL ");

            alarmScript.append(" SELECT targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, 'تداخل استاد' AS alarmType, " +
                    "       'جلسه ' || c_session_start_hour ||  ' تا ' || c_session_end_hour || ' ' || c_day_name || ' ' || c_session_date || ' '|| teachername ||' با جلسه '|| c_session_start_hour1 ||' تا '|| c_session_end_hour1 ||' '   || c_day_name1  || ' '|| c_session_date1||' کلاس '|| c_title_class ||' با کد '|| c_code ||' تداخل دارد' AS alarm, " +
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
                    "                    WHEN tbl_personal_info.e_gender = 1 THEN 'آقای' " +
                    "                    ELSE 'خانم' " +
                    "                END " +
                    "            ) " +
                    "            || ' ' " +
                    "            || tbl_personal_info.c_first_name_fa " +
                    "            || ' ' " +
                    "            || tbl_personal_info.c_last_name_fa ) AS teachername, " +
                    "            tbl_class.c_code, " +
                    "            tbl_class.c_title_class, " +
                    "            (' تداخل استاد ' || tb1.c_session_date " +
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

            alarmScript.append("SELECT tb1.f_class_id AS targetRecordId,'classSessionsTab' AS tabName, '/tclass/show-form' AS pageAddress, 'تداخل فراگیر' AS alarmType, " +
                    "    ' جلسه ' " +
                    "    || tb1.c_session_start_hour " +
                    "    || ' تا ' " +
                    "    || tb1.c_session_end_hour " +
                    "    || ' ' " +
                    "    || tb1.c_day_name " +
                    "    || ' ' " +
                    "    || tb1.c_session_date " +
                    "    || ' ' " +
                    "    || tb1.studentName " +
                    "    || ' با جلسه ' " +
                    "    || tb2.c_session_start_hour " +
                    "    || ' تا ' " +
                    "    || tb2.c_session_end_hour " +
                    "    || ' ' " +
                    "    || tb2.c_day_name " +
                    "    || ' ' " +
                    "    || tb2.c_session_date " +
                    "    || ' ' " +
                    "    || tb2.classname " +
                    "    || ' تداخل دارد' AS alarm, " +
                    "    tb2.id AS detailRecordId, " +
                    "    (tb1.studentName || ' تداخل فراگیر ' || tb1.c_session_date || tb1.c_session_start_hour || tb1.c_session_end_hour ) AS sortField " +
                    " FROM " +
                    "    ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.f_student, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no, " +
                    "            ( " +
                    "                CASE " +
                    "                    WHEN tbl_student.gender_title = 'مرد' THEN ' آقای ' " +
                    "                    ELSE ' خانم ' " +
                    "                END " +
                    "            || tbl_student.first_name " +
                    "            || ' ' " +
                    "            || tbl_student.last_name " +
                    "            || ' با شماره پرسنلی ' " +
                    "            || tbl_student.personnel_no ) AS studentName " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.f_class " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.f_student " +
                    "    ) tb1 " +
                    "    INNER JOIN ( " +
                    "        SELECT " +
                    "            tbl_session.id, " +
                    "            tbl_session.f_class_id, " +
                    "            tbl_session.c_day_name, " +
                    "            tbl_session.c_session_date, " +
                    "            tbl_session.c_session_end_hour, " +
                    "            tbl_session.c_session_start_hour, " +
                    "            tbl_class_student.f_student, " +
                    "            tbl_student.first_name, " +
                    "            tbl_student.last_name, " +
                    "            tbl_student.national_code, " +
                    "            tbl_student.personnel_no, " +
                    "            ( " +
                    "                CASE " +
                    "                    WHEN tbl_student.gender_title = 'مرد' THEN ' آقای ' " +
                    "                    ELSE ' خانم ' " +
                    "                END " +
                    "            || tbl_student.first_name " +
                    "            || ' ' " +
                    "            || tbl_student.last_name " +
                    "            || ' با شماره پرسنلی ' " +
                    "            || tbl_student.personnel_no ) AS studentName, " +
                    "            ( ' کلاس ' " +
                    "            || tbl_class.c_title_class " +
                    "            || ' با کد ' " +
                    "            || tbl_class.c_code ) AS classname " +
                    "        FROM " +
                    "            tbl_session " +
                    "            INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.f_class " +
                    "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.f_student " +
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
                    "    AND   tb1.f_class_id =:class_id " +
                    " ORDER BY sortField ");
            //***order by must be in the last script***


            AlarmList = (List<?>) entityManager.createNativeQuery(alarmScript.toString())
                    .setParameter("class_id", class_id)
                    .setParameter("todaydat", todayDate).getResultList();

            if (AlarmList != null) {
                classAlarmDTO = new ArrayList<>(AlarmList.size());

                for (int i = 0; i < AlarmList.size(); i++) {
                    Object[] alarm = (Object[]) AlarmList.get(i);
                    classAlarmDTO.add(new ClassAlarmDTO(Long.parseLong(alarm[0].toString()), alarm[1].toString(), alarm[2].toString(), alarm[3].toString(), alarm[4].toString()));

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

}
