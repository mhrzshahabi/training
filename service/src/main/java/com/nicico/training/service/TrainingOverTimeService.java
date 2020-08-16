package com.nicico.training.service;

import com.nicico.training.dto.TrainingOverTimeDTO;
import com.nicico.training.iservice.ITrainingOverTimeService;
import com.nicico.training.repository.AttendanceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.modelmapper.TypeToken;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TrainingOverTimeService implements ITrainingOverTimeService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;

    private AttendanceDAO attendanceDAO;

    @Override
    public List<TrainingOverTimeDTO.Info> getTrainingOverTimeReportList(String startDate, String endDate) {

        List<?> tOTReportList = null;
        List<TrainingOverTimeDTO> overTimeDTOList = null;


        StringBuilder stringBuilder=new StringBuilder().append(
                " SELECT distinct\n " +
                "    std.personnel_no AS personalnum,\n " +
                "    std.emp_no  AS personalnum2,\n " +
                "    std.national_code AS nationalcode,\n " +
                "    std.first_name || ' ' || std.last_name AS name,\n " +
                "    dep.c_hoze_title  AS ccparea,\n " +
                "    dep.c_omor_title  AS ccpafairs,\n " +
                "    class.c_code AS classcode,\n " +
                "    class.c_title_class AS classname,\n " +
                "    csession.c_session_date,\n " +
                " case when floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) >=6 then floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60)+2 else floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) END  ||  ':' || MOD( SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) , 60) AS time\n"+
                " FROM\n " +
                "    tbl_attendance att\n " +
                "    INNER JOIN tbl_student std ON att.f_student = std.id\n " +
                "    INNER JOIN (\n " +
                "        SELECT\n " +
                "            * from view_active_personnel\n"+
                "    ) personnel ON std.national_code = personnel.national_code\n " +
                "    LEFT JOIN tbl_department dep ON dep.id = personnel.f_department_id \n " +
                "    INNER JOIN tbl_session csession ON att.f_session = csession.id\n " +
                "    INNER JOIN tbl_class class ON csession.f_class_id = class.id\n " +
                " WHERE\n " +
                "    att.c_state = '2' AND (csession.c_session_date >= :startDate AND csession.c_session_date <= :endDate)\n " +
                " GROUP BY\n " +
                "    std.personnel_no,\n " +
                "    std.emp_no,\n " +
                "    std.national_code,\n " +
                "    std.first_name || ' ' || std.last_name,\n " +
                "    dep.c_hoze_title,\n " +
                "    dep.c_omor_title,\n " +
                "    class.c_code,\n " +
                "    class.c_title_class,\n "+
                "    csession.c_session_date");

       // String reportScript = "SELECT tbl_student.personnel_no AS personalNum,tbl_student.emp_no AS personalNum2,tbl_student.national_code AS nationalCode,tbl_student.first_name || ' ' ||  tbl_student.last_name AS name,tbl_personnel.ccp_area AS ccpArea,tbl_personnel.ccp_affairs AS ccpAfairs,tbl_class.c_code AS classCode,tbl_class.c_title_class AS className,tbl_session.c_session_date, case when floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) >=6 then floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60)+2 else floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) END  ||  ':' || MOD( SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) , 60) AS time FROM tbl_attendance INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student INNER JOIN tbl_personnel ON tbl_personnel.national_code = tbl_student.national_code INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id WHERE tbl_personnel.EMPLOYMENT_STATUS_ID=5 and tbl_personnel.active=1 AND tbl_attendance.c_state = '2' AND (tbl_session.c_session_date >=  :startDate  AND tbl_session.c_session_date <= :endDate ) GROUP BY tbl_student.personnel_no,tbl_student.emp_no,tbl_student.national_code,tbl_student.first_name || ' ' || tbl_student.last_name,tbl_personnel.ccp_area,tbl_personnel.ccp_affairs,tbl_class.c_code,tbl_class.c_title_class,tbl_session.c_session_date";
        tOTReportList = (List<?>) entityManager.createNativeQuery(stringBuilder.toString())
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();

        if (tOTReportList != null) {
            overTimeDTOList = new ArrayList<>(tOTReportList.size());

            for (int i = 0; i < tOTReportList.size(); i++) {
                Object[] totReport = (Object[]) tOTReportList.get(i);
                overTimeDTOList.add(new TrainingOverTimeDTO(
                        totReport[0] != null ? totReport[0].toString() : null,
                        totReport[1] != null ? totReport[1].toString() : null,
                        totReport[2] != null ? totReport[2].toString() : null,
                        totReport[3] != null ? totReport[3].toString() : null,
                        totReport[4] != null ? totReport[4].toString() : null,
                        totReport[5] != null ? totReport[5].toString() : null,
                        totReport[6] != null ? totReport[6].toString() : null,
                        totReport[7] != null ? totReport[7].toString() : null,
                        totReport[8] != null ? totReport[8].toString() : null,
                        totReport[9] != null ? totReport[9].toString().split(":")[1].equals("0") ? totReport[9].toString().split(":")[0] : totReport[9].toString() : null
                ));

            }
        }

        return (overTimeDTOList != null ? modelMapper.map(overTimeDTOList, new TypeToken<List<TrainingOverTimeDTO.Info>>() {
        }.getType()) : null);
    }
}
