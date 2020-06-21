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

        String reportScript = "SELECT tbl_student.personnel_no AS personalNum,tbl_student.emp_no AS personalNum2,tbl_student.national_code AS nationalCode,tbl_student.first_name || ' ' ||  tbl_student.last_name AS name,tbl_student.ccp_area AS ccpArea,tbl_student.ccp_affairs AS ccpAfairs,tbl_class.c_code AS classCode,tbl_class.c_title_class AS className,tbl_session.c_session_date,tbl_attendance.c_state, case when floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) >=6 then floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60)+2 else floor(SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60,0)) / 60) END  ||  ' ساعت و ' || MOD( SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) , 60) || ' دقیقه '  AS time FROM tbl_attendance INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id WHERE (tbl_attendance.c_state = :firstState or tbl_attendance.c_state = :secondState) AND (tbl_session.c_session_date >=  :startDate  AND tbl_session.c_session_date <= :endDate ) GROUP BY tbl_student.personnel_no,tbl_student.emp_no,tbl_student.national_code,tbl_student.first_name || ' ' || tbl_student.last_name,tbl_student.ccp_area,tbl_student.ccp_affairs,tbl_class.c_code,tbl_class.c_title_class,tbl_session.c_session_date,tbl_attendance.c_state";

        Query query=entityManager.createNativeQuery(reportScript).setParameter("startDate", startDate).setParameter("endDate", endDate);

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
                        report[10] != null ? report[10].toString() : null
                ));
            }
        }

        return (attedanceDTOList != null ? modelMapper.map(attedanceDTOList, new TypeToken<List<AttendanceReportDTO.Info>>(){}.getType()) : null);
    }
}
