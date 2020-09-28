package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ControlReportDTO;
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
@RequestMapping(value = "/api/controlReport")
public class ControlReportController {
    private final ModelMapper modelMapper;

    @Autowired
    EntityManager entityManager;

    @Loggable
    @PostMapping(value = "/listClassIds")
    @Transactional(readOnly = true)
    public ResponseEntity<ControlReportDTO.ControlReportDTOSpecRs> list(@RequestBody String data) {
        JSONObject jsonObject = new JSONObject(data);
        String[] classCode = null;
        String classCode_Str="";

        String classYear=null;

        String termId=null;

        String instituteId=null;

        String courseCategory=null;

        String courseSubCategory=null;

        String startDate1=null;

        String startDate2=null;

        String endDate1=null;

        String endDate2=null;

        String[] classStatus = null;
        String clasStatus_Str="";

        if(!jsonObject.isNull("classCode")) {
            String resClassCode = modelMapper.map(jsonObject.get("classCode"), String.class);
            if (resClassCode.length()!=0) {
                classCode = resClassCode.split(",");
            }//end if
        }//end if

        if(!jsonObject.isNull("classYear"))
            classYear = modelMapper.map(jsonObject.get("classYear"),String.class);

        if(!jsonObject.isNull("termId"))
            termId = modelMapper.map(jsonObject.get("termId"),String.class);

        if(!jsonObject.isNull("instituteId"))
            instituteId = modelMapper.map(jsonObject.get("instituteId"),String.class);

        if(!jsonObject.isNull("courseCategory"))
            courseCategory = modelMapper.map(jsonObject.get("courseCategory"),String.class);

        if(!jsonObject.isNull("courseSubCategory"))
            courseSubCategory = modelMapper.map(jsonObject.get("courseSubCategory"),String.class);

        if(!jsonObject.isNull("startDate1"))
            startDate1 = modelMapper.map(jsonObject.get("startDate1"),String.class);

        if(!jsonObject.isNull("startDate2"))
            startDate2 = modelMapper.map(jsonObject.get("startDate2"),String.class);

        if(!jsonObject.isNull("endDate1"))
            endDate1 = modelMapper.map(jsonObject.get("endDate1"),String.class);

        if(!jsonObject.isNull("endDate2"))
            endDate2 = modelMapper.map(jsonObject.get("endDate2"),String.class);

        if(!jsonObject.isNull("classStatus"))
            classStatus = modelMapper.map(jsonObject.get("classStatus"), String.class).replaceAll("[\\[\\](){}\"]","").split(",");

        String reportScript = "select distinct(tbl_class.id) as idClass,tbl_class.c_code as codeClass,tbl_course.c_title_fa as nameCourse,SUBSTR(tbl_class.C_START_DATE,1,4) as yearClass,tbl_term.c_title_fa as termClass,tbl_institute.c_title_fa as instituteClass,tbl_CATEGORY.c_title_fa as categoryClass,tbl_SUB_CATEGORY.c_title_fa as subCategoryClass,tbl_class.C_START_DATE as startDateClass,tbl_class.C_END_DATE as endDateClass,tbl_class.c_status as statusClass from tbl_student INNER JOIN tbl_class_student ON tbl_student.id = tbl_class_student.student_id INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id INNER JOIN tbl_term ON tbl_class.f_term = tbl_term.id LEFT JOIN tbl_institute ON tbl_class.f_institute = tbl_institute.id INNER JOIN tbl_category ON tbl_course.category_id = tbl_category.id INNER JOIN tbl_sub_category ON tbl_course.subcategory_id = tbl_sub_category.id where tbl_class.id>0  ";

        if(classCode != null) {
            if (classCode.length!=0) {
                classCode_Str += "'" + classCode[0] + "'";
                for (int i = 1; i < classCode.length; i++) {
                    classCode_Str += "," + "'" + classCode[i] + "'";
                }
                reportScript += " AND tbl_class.c_code IN (" + classCode_Str + ") ";
            }
        }

        if(classYear != null)
            reportScript += " AND SUBSTR(tbl_class.C_START_DATE,1,4)='" + classYear + "' ";

        if(termId != null)
            reportScript += " AND tbl_class.f_term='" + termId + "' ";

        if(instituteId != null)
            reportScript += " AND tbl_class.f_institute='" + instituteId + "' ";

        if(courseCategory != null)
            reportScript += " AND tbl_course.category_id='" + courseCategory + "' ";

        if(courseSubCategory != null)
            reportScript += " AND tbl_course.subcategory_id='" + courseSubCategory + "' ";

        if(startDate2 != null)
            reportScript += " AND tbl_class.C_START_DATE <= " + "'"+startDate2+"'" + " ";

        if(startDate1 != null)
            reportScript += " AND tbl_class.C_START_DATE >= " + "'"+startDate1+"'" + " ";

        if(endDate2 != null)
            reportScript += " AND tbl_class.C_END_DATE <= " + "'"+endDate2+"'" + " ";

        if(endDate1 != null)
            reportScript += " AND tbl_class.C_END_DATE >= " + "'"+endDate1+"'" + " ";

        if(classStatus != null) {
            clasStatus_Str += "'" + classStatus[0] + "'";
            for (int i = 1; i < classStatus.length; i++) {
                clasStatus_Str += "," + "'" + classStatus[i] + "'" ;
            }
            reportScript+=" AND tbl_class.c_status IN (" + clasStatus_Str + ") ";
        }

        List<?> reportList=entityManager.createNativeQuery(reportScript).getResultList();
        List<ControlReportDTO> controlReportDTOList = null;

        if (reportList != null) {
            controlReportDTOList = new ArrayList<>(reportList.size());

            for (int i = 0; i < reportList.size(); i++) {
                Object[] report = (Object[]) reportList.get(i);
                controlReportDTOList.add(new ControlReportDTO(
                        report[0]  != null ? Long.parseLong(report[0].toString())  : null,
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
        }//end if

        List<ControlReportDTO.Info> response = controlReportDTOList != null ? modelMapper.map(controlReportDTOList, new TypeToken<List<ControlReportDTO.Info>>(){}.getType()) : null;

        final ControlReportDTO.SpecRs specResponse = new ControlReportDTO.SpecRs();
        final ControlReportDTO.ControlReportDTOSpecRs specRs = new ControlReportDTO.ControlReportDTOSpecRs();
        specResponse.setData(response)
                .setStartRow(0)
                .setEndRow(response.size())
                .setTotalRows(response.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
