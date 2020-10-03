package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnalysis")
public class EvaluationAnalysisRestController {
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final IEvaluationAnalysisService evaluationAnalysisService;

    @Loggable
    @PostMapping(value = {"/printReactionEvaluation"})
    public void printReactionEvaluation(HttpServletResponse response,
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

        if(!FERPass.equalsIgnoreCase(""))
            params.put("FERPass", FERPass);
        else
            params.put("FERPass", "عدم تائید");
        if(!FETPass.equalsIgnoreCase(""))
            params.put("FETPass", FETPass);
        else
            params.put("FETPass", "عدم تائید");
        if(!FECRPass.equalsIgnoreCase(""))
            params.put("FECRPass",FECRPass);
        else
            params.put("FECRPass", "عدم تائید");

        params.put("minScore_ER", minScore_ER);
        params.put("minScore_ET", minScore_ET);

        params.put("differFER", differFER);
        params.put("differFET", differFET);

        if(!teacherGradeToClass.equalsIgnoreCase(""))
            params.put("teacherGradeToClass", Double.parseDouble(teacherGradeToClass));
        else
            params.put("teacherGradeToClass", 0.0);
        if(!studentsGradeToTeacher.equalsIgnoreCase(""))
            params.put("studentsGradeToTeacher", Double.parseDouble(studentsGradeToTeacher));
        else
            params.put("studentsGradeToTeacher", 0.0);
        if(!studentsGradeToFacility.equalsIgnoreCase(""))
            params.put("studentsGradeToFacility", Double.parseDouble(studentsGradeToFacility));
        else
            params.put("studentsGradeToFacility", 0.0);
        if(!studentsGradeToGoals.equalsIgnoreCase(""))
            params.put("studentsGradeToGoals", Double.parseDouble(studentsGradeToGoals));
        else
            params.put("studentsGradeToGoals", 0.0);
        if(!trainingGradeToTeacher.equalsIgnoreCase(""))
            params.put("trainingGradeToTeacher", Double.parseDouble(trainingGradeToTeacher));
        else
            params.put("trainingGradeToTeacher", 0.0);

        HashMap<Double,String> doubleArrayList = new HashMap<>();
        if(!trainingGradeToTeacher.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(trainingGradeToTeacher),"نمره مسئول آموزش به مدرس");
        if(!studentsGradeToTeacher.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"نمره فراگیران به مدرس");
        if(doubleArrayList.size() != 0)
            params.put("teacherEvaluationAnalysis", getMinFactor(doubleArrayList).toString());
        else
            params.put("teacherEvaluationAnalysis", "");

        doubleArrayList = new HashMap<>();
        if(!studentsGradeToTeacher.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"نمره فراگیران به مدرس");
        if(!studentsGradeToFacility.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(studentsGradeToFacility),"نمره فراگیران به امکانات");
        if(!studentsGradeToGoals.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(studentsGradeToGoals),"نمره فراگیران به محتوای دوره");
        if(!teacherGradeToClass.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(teacherGradeToClass),"نمره مدرس به کلاس");
        if(doubleArrayList.size() != 0)
            params.put("reactionEvaluationAnalysis", getMinFactor(doubleArrayList).toString());
        else
            params.put("reactionEvaluationAnalysis", "");

        ArrayList<String> list = new ArrayList();
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(list) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/ReactionEvaluationResult.jasper", params, jsonDataSource, response);
    }

    private String getMinFactor(HashMap<Double, String> list){
        String result = "";
        Double min = 1000.0;
        for (Map.Entry<Double, String> doubleStringEntry : list.entrySet()) {
            if(doubleStringEntry.getKey() < min) {
                min = doubleStringEntry.getKey();
                result = doubleStringEntry.getValue();
            }
        }
        return result;
    }

    @Loggable
    @PostMapping(value = {"/printBehavioralEvaluation"})
    public void printBehavioralEvaluation(HttpServletResponse response,
                                          @RequestParam(value = "code") String code, @RequestParam(value = "titleClass") String titleClass,
                                          @RequestParam(value = "term") String term, @RequestParam(value = "studentCount") String studentCount,
                                          @RequestParam(value = "teacher") String teacher, @RequestParam(value = "classPassedTime") String classPassedTime,
                                          @RequestParam(value = "numberOfFilledFormsBySuperviosers") String numberOfFilledFormsBySuperviosers,
                                          @RequestParam(value = "numberOfFilledFormsByStudents") String numberOfFilledFormsByStudents,
                                          @RequestParam(value = "studentsMeanGrade") String studentsMeanGrade,
                                          @RequestParam(value = "supervisorsMeanGrade") String supervisorsMeanGrade,
                                          @RequestParam(value = "FEBGrade") String FEBGrade,@RequestParam(value = "FEBPass") String FEBPass,
                                          @RequestParam(value = "FECBGrade") String FECBGrade,@RequestParam(value = "FECBPass") String FECBPass) throws Exception {
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, "PDF");

        params.put("code",code);
        params.put("titleClass",titleClass);
        params.put("term",term);
        params.put("studentCount", studentCount);
        params.put("teacher", teacher);
        params.put("classPassedTime",classPassedTime);
        params.put("numberOfFilledFormsBySuperviosers",numberOfFilledFormsBySuperviosers);
        params.put("numberOfFilledFormsByStudents",numberOfFilledFormsByStudents);
        params.put("studentsMeanGrade",studentsMeanGrade);
        params.put("supervisorsMeanGrade",supervisorsMeanGrade);
        params.put("FEBGrade",FEBGrade);
        params.put("FEBPass", Boolean.parseBoolean(FEBPass));
        params.put("FECBGrade",FECBGrade);
        params.put("FECBPass",Boolean.parseBoolean(FECBPass));

        ArrayList<String> list = new ArrayList();
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(list) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/BehavioralEvaluationResult.jasper", params, jsonDataSource, response);
    }



    @PostMapping(value = "/printLearningEvaluation")
    public void printLearningEvaluation(HttpServletResponse response, @RequestParam(value = "recordId") String recordId,@RequestParam(value = "minScoreLearning") String minScoreLearning, @RequestParam(value = "Record") String Record) throws Exception {
        Map<String, Object> params = new HashMap();
        Map<String, String> map = new HashMap<>();
        map.put("1", "ارزشی");
        map.put("2", "نمره از صد");
        map.put("3", "نمره از بیست");
        map.put("4", "بدون نمره");
        JSONObject json = new JSONObject(Record);
        params.put("code", json.getString("tclassCode").toString());
        params.put("studentCount", json.getString("tclassStudentsCount").toString());
        params.put("endDate", json.getString("tclassEndDate").toString());
        params.put("startDate", json.getString("tclassStartDate").toString());
        params.put("teacher", json.getString("teacherFullName").toString());
        params.put("courseCode", json.getString("courseCode").toString());
        params.put("coursetitleFa", json.getString("courseTitleFa").toString());
        if(json.has("classScoringMethod"))
            params.put("scoringMethod", map.get(json.getString("classScoringMethod")));
        else
            params.put("scoringMethod", "");
        params.put("minScoreLearning",minScoreLearning.toString());
        String scoringMethod = "3";
        if(json.has("classScoringMethod"))
            scoringMethod = json.getString("classScoringMethod");
        EvaluationDTO.EvaluationLearningResult result = evaluationAnalysisService.evaluationAnalysistLearningResultTemp(Long.parseLong(recordId),scoringMethod);

        params.put("score", result.getPostTestMeanScore());
        params.put("preTestScore", result.getPreTestMeanScore());
        params.put("ScoreEvaluation",result.getFelgrade());
        if(result.getFelpass() != null && result.getFelpass().equalsIgnoreCase("true"))
        {
            params.put("resault","تایید");
        }
        else
        {
            params.put("resault","عدم تایید");
        }


        params.put("ScoreEffective", result.getFeclgrade());
        if(result.getFeclpass() != null && result.getFeclpass().equalsIgnoreCase("true"))
            params.put("resultEffective", "تایید");
        else
            params.put("resultEffective", "عدم تایید");

        List<?> list=evaluationAnalysisService.getStudentWithOutPreTest(Long.parseLong(recordId));
        String data = "{" + "\"studentWithOutPreTest\": " + objectMapper.writeValueAsString(list) + "}";
        params.put(ConstantVARs.REPORT_TYPE, "pdf");
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/evaluationAnalysistLearning.jasper", params, jsonDataSource, response);
    }

    @GetMapping("/updateLearningEvaluation/{classId}/{scoringMethod}")
    public void updateLearningEvaluation(@PathVariable Long classId, @PathVariable String scoringMethod) {
        evaluationAnalysisService.updateLearningEvaluation(classId,scoringMethod);
    }

    @GetMapping("/updateEvaluationAnalysis/{classId}")
    public void updateEvaluationAnalysis(@PathVariable Long classId) {
        evaluationAnalysisService.updateReactionEvaluation(classId);
    }

    @GetMapping("/updateBehavioralEvaluation/{classId}")
    public void updateBehavioralEvaluation(@PathVariable Long classId) {
        evaluationAnalysisService.updateBehavioral(classId);
    }

    @GetMapping("/evaluationAnalysistLearningResult/{classId}/{scoringMethod}")
    public ResponseEntity<EvaluationDTO.EvaluationLearningResult> evaluationAnalysistLearningResult(@PathVariable Long classId, @PathVariable String scoringMethod) {
        EvaluationDTO.EvaluationLearningResult resultSet = evaluationAnalysisService.evaluationAnalysistLearningResultTemp(classId,scoringMethod);
        return new ResponseEntity<>(resultSet,HttpStatus.OK);
    }

    }
