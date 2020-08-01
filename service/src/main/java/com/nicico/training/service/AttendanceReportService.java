package com.nicico.training.service;

import com.nicico.training.dto.AttendanceReportDTO;
import com.nicico.training.iservice.IAttendanceReportService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor

public class AttendanceReportService implements IAttendanceReportService {
    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;

    @Override
    public List<AttendanceReportDTO.Info> getAbsentList(String startDate, String endDate, String absentType) {

        List<?> reportList;
        List<AttendanceReportDTO> attedanceDTOList = null;

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
                        "    att.c_state,\n" +
                        "    case when floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) >=6 then floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60)+2 else floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) END  ||  ':' || MOD( SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(csession.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(csession.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE csession.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) , 60) AS time\n"+
                        " FROM\n " +
                        "    tbl_attendance att\n " +
                        "    INNER JOIN tbl_student std ON att.f_student = std.id\n " +
                        "    INNER JOIN (\n " +
                        "        SELECT\n " +
                        "            * from view_personnels\n"+
                        "    ) personnel ON std.personnel_no = personnel.personnel_no\n " +
                        "    LEFT JOIN tbl_department dep ON dep.id = personnel.department_id \n " +
                        "    INNER JOIN tbl_session csession ON att.f_session = csession.id\n " +
                        "    INNER JOIN tbl_class class ON csession.f_class_id = class.id\n " +
                        " WHERE\n " +
                        "    (att.c_state = :firstState or att.c_state = :secondState) AND (csession.c_session_date >= :startDate AND csession.c_session_date <= :endDate)\n " +
                        " GROUP BY\n " +
                        "    std.personnel_no,\n " +
                        "    std.emp_no,\n " +
                        "    std.national_code,\n " +
                        "    std.first_name || ' ' || std.last_name,\n " +
                        "    dep.c_hoze_title,\n " +
                        "    dep.c_omor_title,\n " +
                        "    class.c_code,\n " +
                        "    class.c_title_class,\n "+
                        "    csession.c_session_date,\n"+
                        "    att.c_state");

        Query query=entityManager.createNativeQuery(stringBuilder.toString()).setParameter("startDate", startDate).setParameter("endDate", endDate);

        switch (absentType)
        {
            case "3":
            reportList=query.setParameter("firstState", "3").setParameter("secondState", "3").getResultList();
            break;

            case "4":
                reportList=query.setParameter("firstState", "4").setParameter("secondState", "4").getResultList();
            break;

            default:
                reportList=query.setParameter("firstState", "3").setParameter("secondState", "4").getResultList();
            break;
        }

        if (reportList != null) {
            attedanceDTOList = new ArrayList<>(reportList.size());

            for (int i = 0; i < reportList.size(); i++) {
                Object[] report = (Object[]) reportList.get(i);
                attedanceDTOList.add(new AttendanceReportDTO(
                        report[0]  != null ? report[0].toString()  : null,
                        report[1]  != null ? report[1].toString()  : null,
                        report[2]  != null ? report[2].toString()  : null,
                        report[3]  != null ? report[3].toString()  : null,
                        report[4]  != null ? report[4].toString()  : null,
                        report[5]  != null ? report[5].toString()  : null,
                        report[6]  != null ? report[6].toString()  : null,
                        report[7]  != null ? report[7].toString()  : null,
                        report[8]  != null ? report[8].toString()  : null,
                        report[9]  != null ? report[9].toString()  : null,
                        report[10] != null ? report[10].toString().split(":")[1].equals("0") ? report[10].toString().split(":")[0] : report[10].toString() : null
                ));
            }
        }

        return (attedanceDTOList != null ? modelMapper.map(attedanceDTOList, new TypeToken<List<AttendanceReportDTO.Info>>(){}.getType()) : null);
    }
}
