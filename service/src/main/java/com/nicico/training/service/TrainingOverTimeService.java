package com.nicico.training.service;

import com.nicico.training.dto.TrainingOverTimeDTO;
import com.nicico.training.iservice.ITrainingOverTimeService;
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

    @Override
    public List<TrainingOverTimeDTO.Info> getTrainingOverTimeReportList(String startDate, String endDate) {

        List<?> tOTReportList = null;
        List<TrainingOverTimeDTO> overTimeDTOList = null;

        String reportScript = "\n" +
                "SELECT\n" +
                "    tbl_student.personnel_no AS personalNum,\n" +
                "    tbl_student.emp_no AS personalNum2,\n" +
                "    tbl_student.national_code AS nationalCode,\n" +
                "    tbl_student.first_name || ' ' ||  tbl_student.last_name AS name,\n" +
                "    tbl_student.ccp_area AS ccpArea,\n" +
                "    tbl_class.c_code AS classCode,\n" +
                "    tbl_class.c_title_class AS className,\n" +
                "    tbl_session.c_session_date,\n" +
                "   \n" +
                "    SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) / 60 ||  ' ساعت و '    ||\n" +
                "    MOD( SUM( round(to_number(TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(tbl_session.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE tbl_session.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) , 60) || ' دقیقه ' AS time\n" +
                "FROM\n" +
                "    tbl_attendance\n" +
                "    INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session\n" +
                "    INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student\n" +
                "    INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id\n" +
                "WHERE\n" +
                "    tbl_attendance.c_state = '2' AND tbl_session.c_session_date >= :startDate AND tbl_session.c_session_date <= :endDate\n" +
                "GROUP BY  tbl_student.personnel_no ,\n" +
                "    tbl_student.emp_no ,\n" +
                "    tbl_student.national_code ,\n" +
                "    tbl_student.first_name || ' ' ||  tbl_student.last_name ,\n" +
                "    tbl_student.ccp_area ,\n" +
                "    tbl_class.c_code ,\n" +
                "    tbl_class.c_title_class ,\n" +
                "    tbl_session.c_session_date    \n";

        tOTReportList = (List<?>) entityManager.createNativeQuery(reportScript)
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
                        totReport[8] != null ? totReport[8].toString() : null
                ));

            }
        }

        return (overTimeDTOList != null ? modelMapper.map(overTimeDTOList, new TypeToken<List<TrainingOverTimeDTO.Info>>() {
        }.getType()) : null);
    }
}
