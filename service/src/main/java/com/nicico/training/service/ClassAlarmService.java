package com.nicico.training.service;

import com.nicico.training.dto.ClassAlarmDTO;
import com.nicico.training.iservice.IClassAlarm;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ClassAlarmService implements IClassAlarm {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    //*********************************
      /*point : for ended classes do not fetch alarms*/
    @Transactional
    @Override
    public List<ClassAlarmDTO> list(Long class_id) {

        List<Object> AlarmList = null;
        List<ClassAlarmDTO> classAlarmDTO = null;
        try {

            String mainSql = "SELECT " +
                    "    f_class_id AS targetRecordId, " +
                    "    'classSessionsTab' AS tabName, " +
                    "    '/tclass/show-form' AS pageAddress, " +
                    "    'جلسات' AS alarmType, " +
                    "   (CASE WHEN floor( (class_time - session_time) / 60) > 0 THEN concat(concat('مجموع ساعت جلسات ',floor( (class_time - session_time) / 60) ),' ساعت کمتر از مدت کلاس است') " +
                    "                            ELSE concat(concat('مجموع ساعت جلسات ',abs(floor( (class_time - session_time) / 60) ) ),' ساعت بیشتر از مدت کلاس است') END) AS alarm     " +
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
                    "    floor(abs((class_time - session_time) / 60)) > 0";

            AlarmList = (List<Object>) entityManager.createNativeQuery(mainSql).setParameter("class_id",class_id).getResultList();

            if (AlarmList != null) {
                classAlarmDTO = new ArrayList<>(AlarmList.size());

                for (int i = 0; i < AlarmList.size(); i++) {
                    Object[] alarm = (Object[]) AlarmList.get(i);
                    classAlarmDTO.add(new ClassAlarmDTO(Long.parseLong(alarm[0].toString()), alarm[1].toString(), alarm[2].toString(), alarm[3].toString(), alarm[4].toString()));

                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("اشکال در ارتباط با دیتابیس");
        }

        return (classAlarmDTO != null ? modelMapper.map(classAlarmDTO, new TypeToken<List<ClassAlarmDTO>>(){}.getType()) : null);

    }
    //*********************************

}
