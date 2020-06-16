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

        String reportScript = "SELECT\n" +
                "    c_title_fa,\n" +
                "    category_title,\n" +
                "    CASE WHEN planing IS NOT NULL THEN planing ELSE 0 END as planing,\n" +
                "    CASE WHEN processing IS NOT NULL THEN processing ELSE 0 END as processing,\n" +
                "    CASE WHEN ended IS NOT NULL THEN ended ELSE 0 END as ended,\n" +
                "    CASE WHEN finished IS NOT NULL THEN finished ELSE 0 END as finished,\n" +
                "    f_institute_organizer,\n" +
                "    category_id\n" +
                "FROM\n" +
                "(SELECT\n" +
                "    clp.c_title_fa,\n" +
                "    clp.category_title,\n" +
                "    clp.status,\n" +
                "    COUNT(clp.status) statusCount,\n" +
                "    clp.f_institute_organizer,\n" +
                "    clp.category_id\n" +
                "FROM\n" +
                "    view_class_performance clp\n" +
                "WHERE\n" +
                "    (((CASE WHEN length(:firststartdate) = 10 AND clp.c_start_date >=:firststartdate THEN 1 WHEN length(:firststartdate) != 10 THEN 1 END) IS NOT NULL AND   \n" +
                "    (CASE WHEN length(:secondstartdate) = 10 AND clp.c_start_date <=:secondstartdate THEN 1 WHEN length(:secondstartdate) != 10 THEN 1 END) IS NOT NULL) \n" +
                "    AND\n" +
                "    ((CASE WHEN length(:firstfinishdate) = 10 AND clp.c_end_date >=:firstfinishdate THEN 1 WHEN length(:firstfinishdate) != 10 THEN 1 END) IS NOT NULL AND\n" +
                "    (CASE WHEN length(:secondfinishdate) = 10 AND clp.c_end_date <=:secondfinishdate THEN 1 WHEN length(:secondfinishdate) != 10 THEN 1 END)IS NOT NULL))\n" +
                "    AND   \n" +
                "    (CASE WHEN :institute = 'همه' THEN 1 WHEN clp.f_institute_organizer =:institute THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :term = 'همه' THEN 1 WHEN clp.f_term =:term THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :course_id = 'همه' THEN 1 WHEN clp.course_id =:course_id THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :category_id = 'همه' THEN 1 WHEN clp.category_id =:category_id THEN 1 END) IS NOT NULL AND\n" +
                "    (CASE WHEN :subcategory_id = 'همه' THEN 1 WHEN clp.subcategory_id =:subcategory_id THEN 1 END) IS NOT NULL\n" +
                "GROUP BY\n" +
                "    clp.c_title_fa,\n" +
                "    clp.category_title,\n" +
                "    clp.f_institute_organizer,\n" +
                "    clp.category_id,\n" +
                "    clp.status)\n" +
                "PIVOT(\n" +
                "    SUM (statusCount)\n" +
                "    FOR status\n" +
                "    IN(\n" +
                "    '1' as planing,\n" +
                "    '2' as processing,\n" +
                "    '3' as ended,\n" +
                "    '4' as finished\n" +
                "    )) ORDER BY f_institute_organizer;\n";

        CPReportList = (List<?>) entityManager.createNativeQuery(reportScript)
                .setParameter("firstStartDate", firstStartDate)
                .setParameter("secondStartDate", secondStartDate)
                .setParameter("firstFinishDate", firstFinishDate)
                .setParameter("secondFinishDate", secondFinishDate)
                .setParameter("institute", institute)
                .setParameter("category", category)
                .setParameter("subcategory", subcategory)
                .setParameter("term", term)
                .setParameter("course", course)
                .getResultList();

        if (CPReportList != null) {
            classPerformanceReportDTO = new ArrayList<>(CPReportList.size());

            for (int i = 0; i < CPReportList.size(); i++) {
                Object[] cpReport = (Object[]) CPReportList.get(i);
                classPerformanceReportDTO.add(new ClassPerformanceReportDTO(
                        cpReport[0] != null ? cpReport[0].toString() : null,
                        cpReport[0] != null ? cpReport[1].toString() : null,
                        cpReport[0] != null ? (Integer)cpReport[2] : null,
                        cpReport[0] != null ? (Integer)cpReport[3] : null,
                        cpReport[0] != null ? (Integer)cpReport[4] : null,
                        cpReport[0] != null ? (Integer)cpReport[5] : null,
                        cpReport[0] != null ? (Long)cpReport[6] : null,
                        cpReport[0] != null ? (Long)cpReport[7] : null));

            }
        }

        return (classPerformanceReportDTO != null ? modelMapper.map(classPerformanceReportDTO, new TypeToken<List<ClassPerformanceReportDTO>>() {
        }.getType()) : null);
    }
}
