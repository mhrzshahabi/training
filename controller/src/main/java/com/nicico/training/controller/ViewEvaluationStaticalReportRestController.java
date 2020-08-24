package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEvaluationStaticalReportDTO;
import com.nicico.training.repository.ViewEvaluationStaticalReportDAO;
import com.nicico.training.service.ViewEvaluationStaticalReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.activiti.engine.impl.util.json.JSONArray;
import org.activiti.engine.impl.util.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-evaluation-statical-report")
public class ViewEvaluationStaticalReportRestController {

    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;
    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewEvaluationStaticalReportDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if(searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null){
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                if(criterion.getValue().get(0).equals("true"))
                    criterion.setValue(true);
                if(criterion.getValue().get(0).equals("false"))
                    criterion.setValue(false);
            }
        }
        SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> searchRs = viewEvaluationStaticalReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @PostMapping(value = "/staticalResult")
    public ResponseEntity<ViewEvaluationStaticalReportDTO.Statical> staticalResult(@RequestBody String data) throws IOException {
        ViewEvaluationStaticalReportDTO.Statical result = new ViewEvaluationStaticalReportDTO.Statical();
        JSONObject jsonObject = new JSONObject(data);

        JSONArray classEvaluation = null;
        String evaluation_Str = "";
        String teacherId = null;
        String[] tclassCode = null;
        String tclassCode_Str = "";
        String unitId = null;
        String instituteId = null;
        JSONArray tclassYear = null;
        String tclassYear_Str = "";
        JSONArray termId = null;
        String termId_Str = "";
        String startDate1 = null;
        String startDate2 = null;
        String endDate1 = null;
        String endDate2 = null;
        String[] courseCode = null;
        String courseCode_Str = "";
        JSONArray courseCategory = null;
        String courseCategory_Str = "";
        JSONArray courseSubCategory = null;
        String courseSubCategory_Str = "";


        if(!jsonObject.isNull("classEvaluation"))
            classEvaluation = modelMapper.map(jsonObject.get("classEvaluation"),JSONArray.class);
        if(!jsonObject.isNull("tclassCode"))
            tclassCode = modelMapper.map(jsonObject.get("tclassCode"),String.class).split(";");
        if(!jsonObject.isNull("teacherId"))
            teacherId = modelMapper.map(jsonObject.get("teacherId"),String.class);
        if(!jsonObject.isNull("unitId"))
            unitId = modelMapper.map(jsonObject.get("unitId"),String.class);
        if(!jsonObject.isNull("instituteId"))
            instituteId = modelMapper.map(jsonObject.get("instituteId"),String.class);
        if(!jsonObject.isNull("tclassYear"))
            tclassYear = modelMapper.map(jsonObject.get("tclassYear"),JSONArray.class);
        if(!jsonObject.isNull("termId"))
            termId = modelMapper.map(jsonObject.get("termId"),JSONArray.class);
        if(!jsonObject.isNull("startDate1"))
            startDate1 = modelMapper.map(jsonObject.get("startDate1"),String.class);
        if(!jsonObject.isNull("startDate2"))
            startDate2 = modelMapper.map(jsonObject.get("startDate2"),String.class);
        if(!jsonObject.isNull("endDate1"))
            endDate1 = modelMapper.map(jsonObject.get("endDate1"),String.class);
        if(!jsonObject.isNull("endDate2"))
            endDate2 = modelMapper.map(jsonObject.get("endDate2"),String.class);
        if(!jsonObject.isNull("courseCode"))
            courseCode = modelMapper.map(jsonObject.get("courseCode"),String.class).split(";");
        if(!jsonObject.isNull("courseCategory"))
            courseCategory = modelMapper.map(jsonObject.get("courseCategory"),JSONArray.class);
        if(!jsonObject.isNull("courseSubCategory"))
            courseSubCategory = modelMapper.map(jsonObject.get("courseSubCategory"),JSONArray.class);


        String sql =
                "select \n" +
                "    count(case EVALUATIONANALYSIS_C_REACTION_PASS when 1 then 1 else null end),\n" +
                "    count(case EVALUATIONANALYSIS_C_REACTION_PASS when 0 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_LEARNING_PASS when 1 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_LEARNING_PASS when 0 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_BEHAVIORAL_PASS when 1 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_BEHAVIORAL_PASS when 0 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_RESULTS_PASS when 1 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_RESULTS_PASS when 0 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_TEACHER_PASS when 1 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_TEACHER_PASS when 0 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_EFFECTIVENESS_PASS when 1 then 1 else null end), \n" +
                "    count(case EVALUATIONANALYSIS_C_EFFECTIVENESS_PASS when 0 then 1 else null end) \n" +
                "from view_evaluation_statical_report\n" +
                "where ";

        if(classEvaluation != null) {
            evaluation_Str += classEvaluation.get(0).toString();
            for (int i = 1; i < classEvaluation.length(); i++) {
                evaluation_Str += "," + classEvaluation.get(i).toString();
            }
            sql += "TCLASS_EVALUATION IN (" + evaluation_Str + ") ";
        }

        if(tclassCode != null) {
            tclassCode_Str += "'" + tclassCode[0] + "'";
            for (int i = 1; i < tclassCode.length; i++) {
                tclassCode_Str += "," + "'" + tclassCode[i] + "'" ;
            }
            sql += "AND TCLASS_C_CODE IN (" + tclassCode_Str + ") ";
        }

        if(teacherId != null)
            sql += "AND TEACHER_ID=" + teacherId + " ";


        if(unitId != null)
            sql += "AND UNIT_ID=" + unitId + " ";

        if(instituteId != null)
            sql += "AND INSTITUTE_ID=" + instituteId + " ";

        if(tclassYear != null) {
            tclassYear_Str += "'" + tclassYear.get(0).toString() + "'";
            for (int i = 1; i < tclassYear.length(); i++) {
                tclassYear_Str += "," + "'" + tclassYear.get(i).toString() + "'";
            }
            sql += "AND TCLASS_YEAR IN (" +  tclassYear_Str  + ") ";
        }

        if(termId != null) {
            termId_Str += "'" + termId.get(0).toString() + "'";
            for (int i = 1; i < termId.length(); i++) {
                termId_Str += "," + "'" + termId.get(i).toString() + "'";
            }
            sql += "AND TERM_ID IN (" + termId_Str + ") ";
        }

        if(startDate1 != null)
            sql += "AND TCLASS_C_START_DATE <= " + "'"+startDate1+"'" + " ";
        if(startDate2 != null)
            sql += "AND TCLASS_C_START_DATE >= " + "'"+startDate2+"'" + " ";
        if(endDate1 != null)
            sql += "AND TCLASS_C_END_DATE <= " + "'"+endDate1+"'" + " ";
        if(endDate2 != null)
            sql += "AND TCLASS_C_END_DATE >= " + "'"+endDate2+"'" + " ";

        if(courseCode != null) {
            courseCode_Str += "'" + courseCode[0] + "'";
            for (int i = 1; i < courseCode.length; i++) {
                courseCode_Str += "," + "'" + courseCode[i] + "'";
            }
            sql += "AND COURSE_C_CODE IN (" + courseCode_Str + ") ";
        }

        if(courseCategory != null) {
            courseCategory_Str += "'" + courseCategory.get(0).toString() + "'";
            for (int i = 1; i < courseCategory.length(); i++) {
                courseCategory_Str += "," + "'" + courseCategory.get(i).toString() + "'";
            }
            sql += "AND COURSE_CATEGORY_ID IN (" + courseCategory_Str + ") ";
        }

        if(courseSubCategory != null) {
            courseSubCategory_Str += "'" + courseSubCategory.get(0).toString() + "'";
            for (int i = 1; i < courseSubCategory.length(); i++) {
                courseSubCategory_Str += "," + "'" + courseSubCategory.get(i).toString() + "'";
            }
            sql += "AND COURSE_SUBCATEGORY_ID IN (" + courseSubCategory_Str + ") ";
        }

        List<?> oracleResult = null;
        Object[] oracleResult_Obj = null;
        oracleResult = (List<?>) entityManager.createNativeQuery(sql).getResultList();
        Integer classCount_reaction = 0;
        Integer classCount_learning = 0;
        Integer classCount_behavioral = 0;
        Integer classCount_results = 0;
        Integer classCount_teacher = 0;
        Integer classCount_effectiveness = 0;

        Integer passed_reaction = 0;
        Integer passed_learning = 0;
        Integer passed_behavioral = 0;
        Integer passed_results = 0;
        Integer passed_teacher = 0;
        Integer passed_effectiveness = 0;

        Integer failed_reaction = 0;
        Integer failed_learning = 0;
        Integer failed_behavioral = 0;
        Integer failed_results = 0;
        Integer failed_teacher = 0;
        Integer failed_effectiveness = 0;

        if(oracleResult.size() > 0) {
            oracleResult_Obj = (Object[]) oracleResult.get(0);

            passed_reaction = Integer.parseInt(oracleResult_Obj[0].toString());
            passed_learning = Integer.parseInt(oracleResult_Obj[2].toString());
            passed_behavioral = Integer.parseInt(oracleResult_Obj[4].toString());
            passed_results = Integer.parseInt(oracleResult_Obj[6].toString());
            passed_teacher = Integer.parseInt(oracleResult_Obj[8].toString());
            passed_effectiveness = Integer.parseInt(oracleResult_Obj[10].toString());

            failed_reaction = Integer.parseInt(oracleResult_Obj[1].toString());
            failed_learning = Integer.parseInt(oracleResult_Obj[3].toString());
            failed_behavioral =  Integer.parseInt(oracleResult_Obj[5].toString());
            failed_results = Integer.parseInt(oracleResult_Obj[7].toString());
            failed_teacher = Integer.parseInt(oracleResult_Obj[9].toString());
            failed_effectiveness =  Integer.parseInt(oracleResult_Obj[11].toString());

            classCount_reaction = passed_reaction + failed_reaction;
            classCount_learning = passed_learning + failed_learning ;
            classCount_behavioral = passed_behavioral + failed_behavioral;
            classCount_results = passed_results + failed_results;
            classCount_teacher = passed_teacher + failed_teacher;
            classCount_effectiveness = passed_effectiveness + failed_effectiveness;

        }
        result.setClassCount_reaction(classCount_reaction);
        result.setClassCount_learning(classCount_learning);
        result.setClassCount_behavioral(classCount_behavioral);
        result.setClassCount_teacher(classCount_teacher);
        result.setClassCount_effectiveness(classCount_effectiveness);
        result.setClassCount_results(classCount_results);

        result.setPassed_reaction(passed_reaction);
        result.setPassed_learning(passed_learning);
        result.setPassed_behavioral(passed_behavioral);
        result.setPassed_teacher(passed_teacher);
        result.setPassed_effectiveness(passed_effectiveness);
        result.setPassed_results(passed_results);

        result.setFailed_reaction(failed_reaction);
        result.setFailed_learning(failed_learning);
        result.setFailed_behavioral(failed_behavioral);
        result.setFailed_teacher(failed_teacher);
        result.setFailed_effectiveness(failed_effectiveness);
        result.setFailed_results(failed_results);

        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
