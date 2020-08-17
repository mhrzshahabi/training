package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.AnnualStatisticalReportDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.activiti.engine.impl.util.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/annualStatisticsReport")
public class AnnualStatisticalReportController {

    private final ModelMapper modelMapper;

    @Autowired
    EntityManager entityManager;

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs> list(@RequestBody String data) {
        JSONObject jsonObject = new JSONObject(data);
        List<?> tOTReportList = null;
        List<AnnualStatisticalReportDTO> DTOList = null;

        String startDate1 = null;

        String startDate2 = null;

        String endDate1 = null;

        String endDate2 = null;

        String courseCategory = null;

        String institute = null;

        String classYear = null;

        String termId = null;

        String Unit = null;

        String Affairs = null;

        String Assistant = null;

        String complex_MSReport = null;

        if (!jsonObject.isNull("startDate"))
            startDate1 = modelMapper.map(jsonObject.get("startDate"), String.class);

        if (!jsonObject.isNull("startDate2"))
            startDate2 = modelMapper.map(jsonObject.get("startDate2"), String.class);

        if (!jsonObject.isNull("endDate"))
            endDate1 = modelMapper.map(jsonObject.get("endDate"), String.class);

        if (!jsonObject.isNull("endDate2"))
            endDate2 = modelMapper.map(jsonObject.get("endDate2"), String.class);

        if (!jsonObject.isNull("institute"))
            institute = modelMapper.map(jsonObject.get("institute"), String.class);

        if (!jsonObject.isNull("category"))
            courseCategory = modelMapper.map(jsonObject.get("category"), String.class);

        if (!jsonObject.isNull("classYear"))
            classYear = modelMapper.map(jsonObject.get("classYear"), String.class);

        if (!jsonObject.isNull("termId"))
            termId = modelMapper.map(jsonObject.get("termId"), String.class);

        if (!jsonObject.isNull("Unit"))
            Unit = modelMapper.map(jsonObject.get("Unit"), String.class);

        if (!jsonObject.isNull("Affairs"))
            Affairs = modelMapper.map(jsonObject.get("Affairs"), String.class);

        if (!jsonObject.isNull("Assistant"))
            Assistant = modelMapper.map(jsonObject.get("Assistant"), String.class);

        if (!jsonObject.isNull("complex_MSReport"))
            complex_MSReport = modelMapper.map(jsonObject.get("complex_MSReport"), String.class);


        String reportScript =
                "SELECT DISTINCT\n" +
                        "    institute_id,\n" +
                        "    institute_title,\n" +
                        "    category_id,\n" +
                        "    category_title,\n" +
                        "    class_status,\n" +
                        "    COUNT(class_status) AS count_courses,\n" +
                        "    SUM(count_class_status) AS count_students,\n" +
                        "    SUM(hours) AS sum_hours,\n" +
                        "    SUM(count_class_status) * SUM(hours) AS sum_hours_per_person\n" +
                        "FROM\n" +
                        "    (\n" +
                        "        SELECT\n" +
                        "            tbl_institute.c_title_fa   AS institute_title,\n" +
                        "            tbl_institute.id           AS institute_id,\n" +
                        "            tbl_category.c_title_fa    AS category_title,\n" +
                        "            tbl_category.id            category_id,\n" +
                        " (\n" +
                        "                CASE\n" +
                        "                    WHEN tbl_class.c_status IN (\n" +
                        "                        '2',\n" +
                        "                        '3'\n" +
                        "                    ) THEN\n" +
                        "                        1\n" +
                        "                    ELSE\n" +
                        "                        4\n" +
                        "                END\n" +
                        "            ) AS class_status,\n"+
                        "            COUNT(tbl_class.c_status) AS count_class_status,\n" +
                        "            tbl_class.c_start_date,\n" +
                        "            tbl_class.c_end_date,\n" +
                        "            substr(tbl_class.c_start_date, 1, 4) AS year,\n" +
                        "            SUM(round(to_number(to_date(tbl_session.c_session_end_hour, 'HH24:MI') - to_date(tbl_session.c_session_start_hour, 'HH24:MI'\n" +
                        "            )) * 24, 1)) AS hours,\n" +
                        "            tbl_department.c_hoze_title,\n" +
                        "            tbl_department.c_moavenat_title,\n" +
                        "            tbl_department.c_omor_title,\n" +
                        "            tbl_department.c_vahed_title,\n" +
                        "            tbl_department.c_ghesmat_title,\n" +
                        "            substr(tbl_class.c_start_date, 1, 4),\n" +
                        "            tbl_term.id                AS term_id,\n" +
                        "            tbl_term.c_title_fa        AS term_title\n" +
                        "        FROM\n" +
                        "            tbl_class\n" +
                        "            INNER JOIN tbl_course ON tbl_course.id = tbl_class.f_course\n" +
                        "            INNER JOIN tbl_category ON tbl_category.id = tbl_course.category_id\n" +
                        "            INNER JOIN tbl_term ON tbl_term.id = tbl_class.f_term\n" +
                        "            INNER JOIN tbl_class_student ON tbl_class_student.class_id = tbl_class.id\n" +
                        "            INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id\n" +
                        "            INNER JOIN (\n" +
                        "                SELECT\n" +
                        "                    tbl_personnel.national_code,\n" +
                        "                    f_department_id\n" +
                        "                FROM\n" +
                        "                    tbl_personnel\n" +
                        "                WHERE\n" +
                        "                    tbl_personnel.deleted = 0\n" +
                        "                UNION ALL\n" +
                        "                SELECT\n" +
                        "                    tbl_personnel_registered.national_code,\n" +
                        "                    f_department_id\n" +
                        "                FROM\n" +
                        "                    tbl_personnel_registered\n" +
                        "                WHERE\n" +
                        "                    tbl_personnel_registered.deleted = 0\n" +
                        "            ) personnel ON personnel.national_code = tbl_student.national_code\n" +
                        "            INNER JOIN tbl_institute ON tbl_institute.id = tbl_class.f_institute\n" +
                        "            INNER JOIN tbl_session ON tbl_session.f_class_id = tbl_class.id\n" +
                        "            LEFT JOIN tbl_department ON tbl_department.id = personnel.f_department_id\n" +
                        "        WHERE\n" +
                        "            tbl_class.c_status <> 1\n";

        if (startDate2 != null)
            reportScript += " AND tbl_class.C_START_DATE <= " + "'" + startDate2 + "'" + " \n";

        if (startDate1 != null)
            reportScript += " AND tbl_class.C_START_DATE >= " + "'" + startDate1 + "'" + " \n";

        if (endDate2 != null)
            reportScript += " AND tbl_class.C_END_DATE <= " + "'" + endDate2 + "'" + " \n";

        if (endDate1 != null)
            reportScript += " AND tbl_class.C_END_DATE >= " + "'" + endDate1 + "'" + " \n";

        if (classYear != null)
            reportScript += " AND SUBSTR(tbl_class.C_START_DATE,1,4)='" + classYear + "' " + "\n";

        if (termId != null)
            reportScript += " AND tbl_class.f_term='" + termId + "' " + "\n";

        if (institute != null) {
            reportScript += " AND tbl_class.f_institute ='" + institute + "' " + "\n";
        }

        if (complex_MSReport != null) {
            reportScript += " AND tbl_department.c_hoze_title='" + complex_MSReport + "' " + "\n";
        }

        if (Assistant != null) {
            reportScript += " AND tbl_department.c_moavenat_title='" + Assistant + "' " + "\n";
        }

        if (Affairs != null) {
            reportScript += " AND tbl_department.c_omor_title='" + Affairs + "' " + "\n";
        }

        if (Unit != null) {
            reportScript += " AND tbl_department.c_vahed_title='" + Unit + "' " + "\n";
        }

        if (courseCategory != null)
            reportScript += " AND tbl_course.category_id='" + courseCategory + "' " + " \n";


        reportScript +=
                "        GROUP BY\n" +
                        "            tbl_institute.c_title_fa,\n" +
                        "            tbl_institute.id,\n" +
                        "            tbl_category.c_title_fa,\n" +
                        "            tbl_category.id,\n" +
                        "            tbl_class.c_status,\n" +
                        "            tbl_class.c_start_date,\n" +
                        "            tbl_class.c_end_date,\n" +
                        "            tbl_department.c_hoze_title,\n" +
                        "            tbl_department.c_moavenat_title,\n" +
                        "            tbl_department.c_omor_title,\n" +
                        "            tbl_department.c_vahed_title,\n" +
                        "            tbl_department.c_ghesmat_title,\n" +
                        "            tbl_term.id,\n" +
                        "            tbl_term.c_title_fa\n" +
                        "        ORDER BY\n" +
                        "            tbl_institute.c_title_fa,\n" +
                        "            tbl_category.c_title_fa,\n" +
                        "            tbl_class.c_status,\n" +
                        "            tbl_class.c_start_date,\n" +
                        "            tbl_class.c_end_date,\n" +
                        "            tbl_term.id,\n" +
                        "            tbl_term.c_title_fa\n" +
                        "    )\n" +
                        "GROUP BY\n" +
                        "    institute_id,\n" +
                        "    institute_title,\n" +
                        "    category_id,\n" +
                        "    category_title,\n" +
                        "    class_status";

        tOTReportList = (List<?>) entityManager.createNativeQuery(reportScript).getResultList();

        if (tOTReportList != null) {
            DTOList = new ArrayList<>(tOTReportList.size());

            for (int i = 0; i < tOTReportList.size(); i++) {
                Object[] totReport = (Object[]) tOTReportList.get(i);
                DTOList.add(new AnnualStatisticalReportDTO(
                        totReport[0] != null ? Long.parseLong(totReport[0].toString()) : null,
                        totReport[1] != null ? totReport[1].toString() : null,
                        totReport[2] != null ? Long.parseLong(totReport[2].toString()) : null,
                        totReport[3] != null ? totReport[3].toString() : null,
                        totReport[4] != null ? totReport[4].toString() : null,
                        totReport[5] != null ? Long.parseLong(totReport[5].toString()) : null,
                        totReport[6] != null ? Long.parseLong(totReport[6].toString()) : null,
                        totReport[7] != null ? Float.parseFloat(totReport[7].toString()) : null,
                        totReport[8] != null ? Float.parseFloat(totReport[8].toString()) : null
                ));

            }
        }
        List<AnnualStatisticalReportDTO.Info> response = DTOList != null ? modelMapper.map(DTOList, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
        }.getType()) : null;

        final AnnualStatisticalReportDTO.SpecRs specResponse = new AnnualStatisticalReportDTO.SpecRs();
        final AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs specRs = new AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs();
        specResponse.setData(response)
                .setStartRow(0)
                .setEndRow(response.size())
                .setTotalRows(response.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}
