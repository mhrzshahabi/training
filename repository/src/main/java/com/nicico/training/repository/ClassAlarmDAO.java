package com.nicico.training.repository;

import com.nicico.training.model.ClassAlarm;
import com.nicico.training.model.ClassSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

////*****rastegari 9809*****

public interface ClassAlarmDAO {

    @Query(value = "SELECT " +
            "    f_class_id AS TARGET_RECORD_ID, " +
            "    'classSessionsTab' AS TAB_NAME, " +
            "    '/tclass/show-form' AS PAGE_ADDRESS, " +
            "    'جلسات' AS ALARM_TYPE, " +
            "   CONCAT(class_name, (CASE WHEN floor( (class_time - session_time) / 60) > 0 THEN concat(concat('مجموع ساعت جلسات ',floor( (class_time - session_time) / 60) ),' ساعت کمتر از مدت کلاس است') " +
            "                            ELSE concat(concat('مجموع ساعت جلسات ',abs(floor( (class_time - session_time) / 60) ) ),' ساعت بیشتر از مدت کلاس است') END)) AS ALARM     " +
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
            "        GROUP BY " +
            "            tbl_session.f_class_id, " +
            "            tbl_class.n_h_duration, " +
            "            tbl_class.c_code, " +
            "            tbl_class.c_title_class " +
            "    ) " +
            " WHERE " +
            "    floor(abs((class_time - session_time) / 60)) > 0;" , nativeQuery = true)
          List<ClassAlarm> findSessionAlarms();

}
