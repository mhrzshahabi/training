package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.MonthlyStatisticalReportDTO;
import com.nicico.training.iservice.IMonthlyStatisticalReportService;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONArray;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MonthlyStatisticalReportService implements IMonthlyStatisticalReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    @Override
    public List<MonthlyStatisticalReportDTO> monthlyStatisticalList(String reportParameter) throws IOException {

        JSONObject jsonObject = new JSONObject(reportParameter);

        String firstDate = jsonObject.get("firstDate").toString().replace("^", "/");
        String secondDate = jsonObject.get("secondDate").toString().replace("^", "/");
        String complex_title = jsonObject.get("complex_title").toString();
        String assistant = jsonObject.get("assistant").toString();
        String affairs = jsonObject.get("affairs").toString();
        String section = jsonObject.get("section").toString();
        String unit = jsonObject.get("unit").toString();
        List<Integer> Technical = objectMapper.readValue(jsonObject.get("technical").toString().replace("*", "[").replace("@", "]"), new TypeReference<List<Integer>>() {
        });
        List<Long> Course = objectMapper.readValue(jsonObject.get("course").toString().replace("*", "[").replace("@", "]"), new TypeReference<List<Long>>() {
        });
        List<Long> Class = objectMapper.readValue(jsonObject.get("class").toString().replace("*", "[").replace("@", "]"), new TypeReference<List<Long>>() {
        });
        List<String> PostGrade = objectMapper.readValue(jsonObject.get("postGrade").toString().replace("*", "[").replace("@", "]"), new TypeReference<List<String>>() {
        });
        List<Long> Personnel = objectMapper.readValue(jsonObject.get("personnel").toString().replace("*", "[").replace("@", "]"), new TypeReference<List<Long>>() {
        });


        ////*** Wildcard ***
        List<?> MSReportList = null;
        List<MonthlyStatisticalReportDTO> monthlyStatisticalDTO = null;

        String reportScript = " SELECT DISTINCT " +
                "                 (CASE WHEN ccp_unit IS NULL THEN '-' ELSE ccp_unit END) ccp_unit, " +
                "                 (CASE WHEN ccp_assistant IS NULL THEN '-' ELSE ccp_assistant END) ccp_assistant, " +
                "                 (CASE WHEN ccp_affairs IS NULL THEN '-' ELSE ccp_affairs END) ccp_affairs, " +
                "                 (CASE WHEN ccp_section IS NULL THEN '-' ELSE ccp_section END) ccp_section, " +
                "                 (CASE WHEN complex_title IS NULL THEN '-' ELSE complex_title END) complex_title, " +
                "                 (CASE WHEN present IS NULL THEN '0' ELSE TO_CHAR(FLOOR(present/60)) || ':' || TO_CHAR(MOD(present,60)) END) present,   " +
                "                 (CASE WHEN overtime IS NULL THEN '0' ELSE TO_CHAR(FLOOR(overtime/60)) || ':' || TO_CHAR(MOD(overtime,60)) END) overtime,   " +
                "                 (CASE WHEN unjustifiedAbsence IS NULL THEN '0' ELSE TO_CHAR(FLOOR(unjustifiedAbsence/60)) || ':' || TO_CHAR(MOD(unjustifiedAbsence,60)) END) unjustifiedAbsence,  " +
                "                 (CASE WHEN acceptableAbsence IS NULL THEN '0' ELSE TO_CHAR(FLOOR(acceptableAbsence/60)) || ':' || TO_CHAR(MOD(acceptableAbsence,60)) END) acceptableAbsence " +
                "                 FROM  " +
                "                 (SELECT      " +
                "                    department.c_vahed_title as ccp_unit,    " +
                "                    A.c_state,  " +
                "                    department.c_hoze_title as complex_title, " +
                "                    department.c_moavenat_title as ccp_assistant, " +
                "                    department.c_omor_title ccp_affairs, " +
                "                    department.c_ghesmat_title as ccp_section, " +
                "                    SUM(round(to_number(TO_DATE((CASE WHEN SUBSTR(S.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE S.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(S.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE S.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) AS session_time  " +
                "                 FROM  " +
                "                    tbl_attendance A  " +
                "                    INNER JOIN tbl_student ST ON ST.id = A.f_student  " +
                "                    INNER JOIN (\n " +
                "                        SELECT\n " +
                "                            * from view_active_personnel\n"+
                "                    ) personnel ON ST.national_code = personnel.national_code\n " +
                "                    LEFT JOIN tbl_department department ON department.id = personnel.f_department_id \n " +
                "                    INNER JOIN tbl_session S ON S.id = A.f_session  " +
                "                    INNER JOIN tbl_class C ON S.f_class_id = C.id  " +
                "                    INNER JOIN tbl_course CO ON C.f_course = CO.id  " +
                "                    LEFT JOIN tbl_post P ON personnel.F_POST_ID = P.ID "+
                "                    LEFT JOIN tbl_post_grade PG ON P.F_POST_GRADE_ID = PG.ID "+
                "                 WHERE  department.c_vahed_title<>'-' and department.c_hoze_title<>'-' and department.c_moavenat_title<>'-' and department.c_omor_title<>'-' and department.c_ghesmat_title<>'-' and S.c_session_date >= :firstDate AND S.c_session_date <= :secondDate AND A.c_state <> 0  " +
                "                 AND (CASE WHEN :complex_title = 'همه' THEN 1 WHEN  department.c_hoze_title = :complex_title THEN 1 END) IS NOT NULL  " +
                "                 AND (CASE WHEN :assistant = 'همه' THEN 1 WHEN  department.c_moavenat_title = :assistant THEN 1 END) IS NOT NULL  " +
                "                 AND (CASE WHEN :affairs = 'همه' THEN 1 WHEN  department.c_omor_title = :affairs THEN 1 END) IS NOT NULL  " +
                "                 AND (CASE WHEN :section = 'همه' THEN 1 WHEN  department.c_ghesmat_title = :section THEN 1 END) IS NOT NULL  " +
                "                 AND (CASE WHEN :unit = 'همه' THEN 1 WHEN  department.c_vahed_title = :unit THEN 1 END) IS NOT NULL  ";
        if ((Technical.size() != 0))
            reportScript += "                 AND CO.E_TECHNICAL_TYPE in (" + StringUtils.join(Technical, ",") + ")";

        if ((Course.size() != 0))
            reportScript += "                 AND CO.id in(" + StringUtils.join(Course, ",") + ")";

        if ((Class.size() != 0))
            reportScript += "                 AND C.id in(" + StringUtils.join(Class, ",") + ")";

        if ((PostGrade.size() != 0))
            reportScript += "                 AND PG.id in(" + StringUtils.join(PostGrade, ",") + ")";

        if ((Personnel.size() != 0))
            reportScript += "                 AND personnel.id in(" + StringUtils.join(Personnel, ",") + ")";

        reportScript += "                 GROUP BY A.c_state, department.c_vahed_title, department.c_hoze_title,department.c_moavenat_title,department.c_omor_title, department.c_ghesmat_title)  " +
                "                 PIVOT(  " +
                "                    SUM(session_time)  " +
                "                    FOR c_state  " +
                "                    IN (   " +
                "                        '1' as present,  " +
                "                        '2' as overtime,  " +
                "                        '3' as unjustifiedAbsence,  " +
                "                        '4' as acceptableAbsence  " +
                "                    ) " +
                "                 )  ";

        MSReportList = (List<?>) entityManager.createNativeQuery(reportScript)
                .setParameter("firstDate", firstDate)
                .setParameter("secondDate", secondDate)
                .setParameter("complex_title", complex_title)
                .setParameter("assistant", assistant)
                .setParameter("affairs", affairs)
                .setParameter("section", section)
                .setParameter("unit", unit)

                .getResultList();


        if (MSReportList != null) {
            monthlyStatisticalDTO = new ArrayList<>(MSReportList.size());

            for (int i = 0; i < MSReportList.size(); i++) {
                Object[] msReport = (Object[]) MSReportList.get(i);
                monthlyStatisticalDTO.add(new MonthlyStatisticalReportDTO(msReport[0].toString(), msReport[1].toString(), msReport[2].toString(), msReport[3].toString(), msReport[4].toString(), msReport[5].toString(), msReport[6].toString(), msReport[7].toString(), msReport[8].toString()));

            }
        }

        return (monthlyStatisticalDTO != null ? modelMapper.map(monthlyStatisticalDTO, new TypeToken<List<MonthlyStatisticalReportDTO>>() {
        }.getType()) : null);
    }

}
