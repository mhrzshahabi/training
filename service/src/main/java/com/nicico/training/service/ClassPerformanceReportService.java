package com.nicico.training.service;

import com.nicico.training.dto.ClassPerformanceReportDTO;
import com.nicico.training.iservice.IClassPerformanceReportService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ClassPerformanceReportService implements IClassPerformanceReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    @Override
    public List<ClassPerformanceReportDTO> classPerformanceList(String reportParameter) {


        String reportScript = "SELECT     \n" +
                "    c_title_fa as institute,\n" +
                "    category_title as category,\n" +
                "    CASE WHEN planing IS NOT NULL THEN planing ELSE 0 END as planing,\n" +
                "    CASE WHEN processing IS NOT NULL THEN processing ELSE 0 END as processing,\n" +
                "    CASE WHEN ended IS NOT NULL THEN ended ELSE 0 END as ended,\n" +
                "    CASE WHEN finished IS NOT NULL THEN finished ELSE 0 END as finished,\n" +
                "    f_institute_organizer as id,\n" +
                "    category_id as category_id\n" +
                "FROM\n" +
                "(SELECT\n" +
                "    ins.c_title_fa,\n" +
                "    ca.c_title_fa AS category_title,\n" +
                "    cl.f_institute_organizer,\n" +
                "    co.category_id,\n" +
                "    (CASE WHEN cl.c_workflow_ending_status_code = '2' THEN '4' ELSE cl.c_status END) status,\n" +
                "    COUNT(CASE WHEN cl.c_workflow_ending_status_code = '2' THEN '4' ELSE cl.c_status END) statusCount\n" +
                "FROM\n" +
                "    tbl_class cl\n" +
                "    INNER JOIN tbl_course co ON co.id = cl.f_course\n" +
                "    INNER JOIN tbl_institute ins ON ins.id = cl.f_institute_organizer\n" +
                "    INNER JOIN tbl_category ca ON ca.id = co.category_id\n" +
                "    INNER JOIN tbl_sub_category suca ON suca.id = co.subcategory_id\n" +
                "WHERE\n" +
                "    (((CASE WHEN length(:firststartdate) = 10 AND cl.c_start_date >=:firststartdate THEN 1 WHEN length(:firststartdate) != 10 THEN 1 END) IS NOT NULL AND   \n" +
                "    (CASE WHEN length(:secondstartdate) = 10 AND cl.c_start_date <=:secondstartdate THEN 1 WHEN length(:secondstartdate) != 10 THEN 1 END) IS NOT NULL) \n" +
                "    AND\n" +
                "    ((CASE WHEN length(:firstfinishdate) = 10 AND cl.c_end_date >=:firstfinishdate THEN 1 WHEN length(:firstfinishdate) != 10 THEN 1 END) IS NOT NULL AND\n" +
                "    (CASE WHEN length(:secondfinishdate) = 10 AND cl.c_end_date <=:secondfinishdate THEN 1 WHEN length(:secondfinishdate) != 10 THEN 1 END)IS NOT NULL))\n" +
                "    AND   \n" +
                "    (CASE WHEN :institute = 'همه' THEN 1 WHEN cl.f_institute_organizer =:institute THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :term = 'همه' THEN 1 WHEN cl.f_term =:term THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :coid = 'همه' THEN 1 WHEN co.id =:coid THEN 1 END)IS NOT NULL AND\n" +
                "    (CASE WHEN :categoryid = 'همه' THEN 1 WHEN co.category_id =:categoryid THEN 1 END) IS NOT NULL AND\n" +
                "    (CASE WHEN :subcategory = 'همه' THEN 1 WHEN co.subcategory_id =:subcategory THEN 1 END) IS NOT NULL\n" +
                "GROUP BY\n" +
                "    ins.c_title_fa,\n" +
                "    ca.c_title_fa,\n" +
                "    cl.f_institute_organizer,\n" +
                "    co.category_id,\n" +
                "    (CASE WHEN cl.c_workflow_ending_status_code = '2' THEN '4' ELSE cl.c_status END))\n" +
                "    PIVOT(\n" +
                "    SUM (statusCount)\n" +
                "    FOR status\n" +
                "    IN(\n" +
                "    '1' as planing,\n" +
                "    '2' as processing,\n" +
                "    '3' as ended,\n" +
                "    '4' as finished\n" +
                "    )) ORDER BY f_institute_organizer";

        return null;
    }
}
