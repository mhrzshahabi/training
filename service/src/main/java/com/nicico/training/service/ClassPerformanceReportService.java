package com.nicico.training.service;

import com.nicico.training.dto.ClassPerformanceReportDTO;
import com.nicico.training.iservice.IClassPerformanceReportService;
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
public class ClassPerformanceReportService implements IClassPerformanceReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    @Override
    public List<ClassPerformanceReportDTO> classPerformanceList(String reportParameter) {

        JSONObject jsonObject = new JSONObject(reportParameter);

        String firstStartDate = jsonObject.get("firstStartDate").toString().replace("^","/");
        String secondStartDate = jsonObject.get("secondStartDate").toString().replace("^","/");
        String firstFinishDate = jsonObject.get("firstFinishDate").toString().replace("^","/");
        String secondFinishDate = jsonObject.get("secondFinishDate").toString().replace("^","/");
        String institute = jsonObject.get("institute").toString();
        String category = jsonObject.get("category").toString();
        String subcategory = jsonObject.get("subcategory").toString();
        String term = jsonObject.get("term").toString();
        String course = jsonObject.get("course").toString();

        ////*** Wildcard ***
        List<?> CPReportList = null;
        List<ClassPerformanceReportDTO> classPerformanceReportDTO = null;

        String reportScript = "SELECT " +
                "    c_title_fa, " +
                "    category_title, " +
                "    CASE WHEN planing IS NOT NULL THEN planing ELSE 0 END as planing, " +
                "    CASE WHEN processing IS NOT NULL THEN processing ELSE 0 END as processing, " +
                "    CASE WHEN ended IS NOT NULL THEN ended ELSE 0 END as ended, " +
                "    CASE WHEN finished IS NOT NULL THEN finished ELSE 0 END as finished, " +
                "    f_institute_organizer, " +
                "    category_id " +
                " FROM " +
                " (SELECT " +
                "    clp.c_title_fa, " +
                "    clp.category_title, " +
                "    clp.status, " +
                "    COUNT(clp.status) statusCount, " +
                "    clp.f_institute_organizer, " +
                "    clp.category_id " +
                " FROM " +
                "    view_class_performance clp " +
                " WHERE " +
                "    (((CASE WHEN length(:firststartdate) = 10 AND clp.c_start_date >=:firststartdate THEN 1 WHEN length(:firststartdate) != 10 THEN 1 END) IS NOT NULL AND    " +
                "    (CASE WHEN length(:secondstartdate) = 10 AND clp.c_start_date <=:secondstartdate THEN 1 WHEN length(:secondstartdate) != 10 THEN 1 END) IS NOT NULL)  " +
                "    AND " +
                "    ((CASE WHEN length(:firstfinishdate) = 10 AND clp.c_end_date >=:firstfinishdate THEN 1 WHEN length(:firstfinishdate) != 10 THEN 1 END) IS NOT NULL AND " +
                "    (CASE WHEN length(:secondfinishdate) = 10 AND clp.c_end_date <=:secondfinishdate THEN 1 WHEN length(:secondfinishdate) != 10 THEN 1 END)IS NOT NULL)) " +
                "    AND    " +
                "    (CASE WHEN :institute = 'همه' THEN 1 WHEN clp.f_institute_organizer =:institute THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :term = 'همه' THEN 1 WHEN clp.f_term =:term THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :course_id = 'همه' THEN 1 WHEN clp.course_id =:course_id THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :category_id = 'همه' THEN 1 WHEN clp.category_id =:category_id THEN 1 END) IS NOT NULL AND " +
                "    (CASE WHEN :subcategory_id = 'همه' THEN 1 WHEN clp.subcategory_id =:subcategory_id THEN 1 END) IS NOT NULL " +
                " GROUP BY " +
                "    clp.c_title_fa, " +
                "    clp.category_title, " +
                "    clp.f_institute_organizer, " +
                "    clp.category_id, " +
                "    clp.status) " +
                " PIVOT( " +
                "    SUM (statusCount) " +
                "    FOR status " +
                "    IN( " +
                "    '1' as planing, " +
                "    '2' as processing, " +
                "    '3' as ended, " +
                "    '4' as finished " +
                "    )) ORDER BY f_institute_organizer ";

        CPReportList = (List<?>) entityManager.createNativeQuery(reportScript)
                .setParameter("firststartdate", firstStartDate)
                .setParameter("secondstartdate", secondStartDate)
                .setParameter("firstfinishdate", firstFinishDate)
                .setParameter("secondfinishdate", secondFinishDate)
                .setParameter("institute", institute)
                .setParameter("category_id", category)
                .setParameter("subcategory_id", subcategory)
                .setParameter("term", term)
                .setParameter("course_id", course)
                .getResultList();

        if (CPReportList != null) {
            classPerformanceReportDTO = new ArrayList<>(CPReportList.size());

            for (int i = 0; i < CPReportList.size(); i++) {
                Object[] cpReport = (Object[]) CPReportList.get(i);
                classPerformanceReportDTO.add(new ClassPerformanceReportDTO(
                        cpReport[0] != null ? cpReport[0].toString() : null,
                        cpReport[1] != null ? cpReport[1].toString() : null,
                        cpReport[2] != null ? Integer.parseInt(cpReport[2].toString()) : null,
                        cpReport[3] != null ? Integer.parseInt(cpReport[3].toString()) : null,
                        cpReport[4] != null ? Integer.parseInt(cpReport[4].toString()) : null,
                        cpReport[5] != null ? Integer.parseInt(cpReport[5].toString()) : null,
                        cpReport[6] != null ? Long.parseLong(cpReport[6].toString()) : null,
                        cpReport[7] != null ? Long.parseLong(cpReport[7].toString()) : null));

            }
        }

        return (classPerformanceReportDTO != null ? modelMapper.map(classPerformanceReportDTO, new TypeToken<List<ClassPerformanceReportDTO>>() {
        }.getType()) : null);
    }
}
