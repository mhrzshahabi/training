package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.model.Goal;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.model.Skill;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnalysis")
public class EvaluationAnalysisRestController {
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;

    @Loggable
    @PostMapping(value = {"/printReactionEvaluation"})
    public void printWithDetail(HttpServletResponse response,
                                @RequestParam(value = "code") String code, @RequestParam(value = "titleClass") String titleClass,
                                @RequestParam(value = "term") String term, @RequestParam(value = "studentCount") String studentCount,
                                @RequestParam(value = "classStatus") String classStatus, @RequestParam(value = "teacher") String teacher,
                                @RequestParam(value = "numberOfExportedReactionEvaluationForms") String numberOfExportedReactionEvaluationForms,
                                @RequestParam(value = "numberOfFilledReactionEvaluationForms") String numberOfFilledReactionEvaluationForms,
                                @RequestParam(value = "numberOfInCompletedReactionEvaluationForms") String numberOfInCompletedReactionEvaluationForms,
                                @RequestParam(value = "percenetOfFilledReactionEvaluationForms") String percenetOfFilledReactionEvaluationForms,
                                @RequestParam(value = "FERGrade") String FERGrade, @RequestParam(value = "FETGrade") String FETGrade,
                                @RequestParam(value = "FECRGrade") String FECRGrade, @RequestParam(value = "FERPass") String FERPass,
                                @RequestParam(value = "FETPass") String FETPass, @RequestParam(value = "FECRPass") String FECRPass,
                                @RequestParam(value = "minScore_ER") String minScore_ER, @RequestParam(value = "minScore_ET") String minScore_ET,
                                @RequestParam(value = "differFER") String differFER, @RequestParam(value = "differFET") String differFET,
                                @RequestParam(value = "teacherGradeToClass") String teacherGradeToClass, @RequestParam(value = "studentsGradeToTeacher") String studentsGradeToTeacher,
                                @RequestParam(value = "studentsGradeToFacility") String studentsGradeToFacility, @RequestParam(value = "studentsGradeToGoals") String studentsGradeToGoals,
                                @RequestParam(value = "trainingGradeToTeacher") String trainingGradeToTeacher) throws Exception {
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, "PDF");

        params.put("code",code);
        params.put("titleClass",titleClass);
        params.put("term",term);
        params.put("studentCount", studentCount);
        if(classStatus.equalsIgnoreCase("1"))
            params.put("classStatus", "برنامه ریزی");
        else if(classStatus.equalsIgnoreCase("2"))
            params.put("classStatus", "در حال اجرا");
        else if(classStatus.equalsIgnoreCase("3"))
            params.put("classStatus", "پایان یافته");
        params.put("teacher", teacher);

        params.put("numberOfExportedReactionEvaluationForms", numberOfExportedReactionEvaluationForms);
        params.put("numberOfFilledReactionEvaluationForms", numberOfFilledReactionEvaluationForms);
        params.put("numberOfInCompletedReactionEvaluationForms", numberOfInCompletedReactionEvaluationForms);
        params.put("percenetOfFilledReactionEvaluationForms", percenetOfFilledReactionEvaluationForms);

        params.put("FERGrade", FERGrade);
        params.put("FETGrade", FETGrade);
        params.put("FECRGrade", FECRGrade);

        params.put("FERPass", Boolean.parseBoolean(FERPass));
        params.put("FETPass", Boolean.parseBoolean(FETPass));
        params.put("FECRPass", Boolean.parseBoolean(FECRPass));

        params.put("minScore_ER", minScore_ER);
        params.put("minScore_ET", minScore_ET);

        params.put("differFER", differFER);
        params.put("differFET", differFET);

        params.put("teacherGradeToClass", Double.parseDouble(teacherGradeToClass));
        params.put("studentsGradeToTeacher", Double.parseDouble(studentsGradeToTeacher));
        params.put("studentsGradeToFacility", Double.parseDouble(studentsGradeToFacility));
        params.put("studentsGradeToGoals", Double.parseDouble(studentsGradeToGoals));
        params.put("trainingGradeToTeacher", Double.parseDouble(trainingGradeToTeacher));

        HashMap<Double,String> doubleArrayList = new HashMap<>();
        doubleArrayList.put(Double.parseDouble(trainingGradeToTeacher),"trainingGradeToTeacher");
        doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"studentsGradeToTeacher");
        params.put("teacherEvaluationAnalysis", getMinTeacherEvaluation(doubleArrayList));
        doubleArrayList = new HashMap<>();
        doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"studentsGradeToTeacher");
        doubleArrayList.put(Double.parseDouble(studentsGradeToFacility),"studentsGradeToFacility");
        doubleArrayList.put(Double.parseDouble(studentsGradeToGoals),"studentsGradeToGoals");
        doubleArrayList.put(Double.parseDouble(teacherGradeToClass),"teacherGradeToClass");
        params.put("reactionEvaluationAnalysis", getMinReactionEvaluation(doubleArrayList));

        ArrayList<String> list = new ArrayList();
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(list) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/ReactionEvaluationResult.jasper", params, jsonDataSource, response);
    }

    private String getMinTeacherEvaluation(HashMap<Double, String> list){
        String result = "";
        for (Map.Entry<Double, String> doubleStringEntry : list.entrySet()) {
        }
        return result;
    }

    private String getMinReactionEvaluation(HashMap<Double, String> list){
        String result = "";
        return result;
    }

}
