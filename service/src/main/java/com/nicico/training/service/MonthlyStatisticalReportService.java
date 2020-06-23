package com.nicico.training.service;

import com.nicico.training.dto.MonthlyStatisticalReportDTO;
import com.nicico.training.iservice.IMonthlyStatisticalReportService;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MonthlyStatisticalReportService implements IMonthlyStatisticalReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;

    @Override
    public List<MonthlyStatisticalReportDTO> monthlyStatisticalList(String reportParameter) {

        JSONObject jsonObject = new JSONObject(reportParameter);

        String firstDate = jsonObject.get("firstDate").toString().replace("^","/");
        String secondDate = jsonObject.get("secondDate").toString().replace("^","/");
        String complex_title = jsonObject.get("complex_title").toString();
        String assistant = jsonObject.get("assistant").toString();
        String affairs = jsonObject.get("affairs").toString();
        String section = jsonObject.get("section").toString();
        String unit = jsonObject.get("unit").toString();


        ////*** Wildcard ***
        List<?> MSReportList = null;
        List<MonthlyStatisticalReportDTO> monthlyStatisticalDTO = null;

        String reportScript = " SELECT (CASE WHEN ccp_unit IS NULL THEN '-' ELSE ccp_unit END) ccp_unit,(CASE WHEN present IS NULL THEN '0' ELSE TO_CHAR(FLOOR(present/60)) || ':' || TO_CHAR(MOD(present,60)) END) present,  " +
                " (CASE WHEN overtime IS NULL THEN '0' ELSE TO_CHAR(FLOOR(overtime/60)) || ':' || TO_CHAR(MOD(overtime,60)) END) overtime,  " +
                " (CASE WHEN unjustifiedAbsence IS NULL THEN '0' ELSE TO_CHAR(FLOOR(unjustifiedAbsence/60)) || ':' || TO_CHAR(MOD(unjustifiedAbsence,60)) END) unjustifiedAbsence, " +
                " (CASE WHEN acceptableAbsence IS NULL THEN '0' ELSE TO_CHAR(FLOOR(acceptableAbsence/60)) || ':' || TO_CHAR(MOD(acceptableAbsence,60)) END) acceptableAbsence " +
                " FROM " +
                " (SELECT     " +
                "    P.ccp_unit, " +
                "    A.c_state, " +
                "    SUM(round(to_number(TO_DATE((CASE WHEN SUBSTR(S.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE S.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(S.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE S.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) AS session_time " +
                " FROM " +
                "    tbl_attendance A " +
                "    INNER JOIN tbl_student ON tbl_student.id = A.f_student " +
                "    INNER JOIN tbl_personnel P ON P.national_code = tbl_student.national_code " +
                "    INNER JOIN tbl_session S ON S.id = A.f_session " +
                " WHERE S.c_session_date >= :firstDate AND S.c_session_date <= :secondDate AND A.c_state <> 0 " +
                " AND (CASE WHEN :complex_title = 'همه' THEN 1 WHEN P.complex_title = :complex_title THEN 1 END) IS NOT NULL " +
                " AND (CASE WHEN :assistant = 'همه' THEN 1 WHEN P.ccp_assistant = :assistant THEN 1 END) IS NOT NULL " +
                " AND (CASE WHEN :affairs = 'همه' THEN 1 WHEN P.ccp_affairs = :affairs THEN 1 END) IS NOT NULL " +
                " AND (CASE WHEN :section = 'همه' THEN 1 WHEN P.ccp_section = :section THEN 1 END) IS NOT NULL " +
                " AND (CASE WHEN :unit = 'همه' THEN 1 WHEN P.ccp_unit = :unit THEN 1 END) IS NOT NULL " +
                " GROUP BY A.c_state, P.ccp_unit) " +
                " PIVOT( " +
                "    SUM(session_time) " +
                "    FOR c_state " +
                "    IN (  " +
                "        '1' as present, " +
                "        '2' as overtime, " +
                "        '3' as unjustifiedAbsence, " +
                "        '4' as acceptableAbsence " +
                "    ) " +
                " ) " +
                " ORDER BY ccp_unit ";


        MSReportList = (List<?>) entityManager.createNativeQuery(reportScript)
                .setParameter("firstDate", firstDate)
                .setParameter("secondDate", secondDate)
                .setParameter("complex_title", complex_title)
                .setParameter("assistant", assistant)
                .setParameter("affairs", affairs)
                .setParameter("section", section)
                .setParameter("unit", unit).getResultList();


        if (MSReportList != null) {
            monthlyStatisticalDTO = new ArrayList<>(MSReportList.size());

            for (int i = 0; i < MSReportList.size(); i++) {
                Object[] msReport = (Object[]) MSReportList.get(i);
                monthlyStatisticalDTO.add(new MonthlyStatisticalReportDTO(msReport[0].toString(), msReport[1].toString(), msReport[2].toString(), msReport[3].toString(), msReport[4].toString()));

            }
        }

        return (monthlyStatisticalDTO != null ? modelMapper.map(monthlyStatisticalDTO, new TypeToken<List<MonthlyStatisticalReportDTO>>() {
        }.getType()) : null);
    }

}
