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
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final ParameterService parameterService;
    private final ITclassService tclassService;
    private final ClassStudentDAO classStudentDAO;
    private final TclassDAO tclassDAO;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private DecimalFormat numberFormat = new DecimalFormat("#.00");

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
        doubleArrayList.put(Double.parseDouble(trainingGradeToTeacher),"نمره مسئول آموزش به مدرس");
        doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"نمره فراگیران به مدرس");
        params.put("teacherEvaluationAnalysis", getMinFactor(doubleArrayList));
        doubleArrayList = new HashMap<>();
        doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"نمره فراگیران به مدرس");
        doubleArrayList.put(Double.parseDouble(studentsGradeToFacility),"نمره فراگیران به امکانات");
        doubleArrayList.put(Double.parseDouble(studentsGradeToGoals),"نمره فراگیران به محتوای دوره");
        doubleArrayList.put(Double.parseDouble(teacherGradeToClass),"نمره مدرس به کلاس");
        params.put("reactionEvaluationAnalysis", getMinFactor(doubleArrayList));

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

    @GetMapping("/updateLearningEvaluation/{classId}/{scoringMethod}")
    public void updateLearningEvaluation(@PathVariable Long classId, @PathVariable String scoringMethod) {
        evaluationAnalysisService.updateLearningEvaluation(classId,scoringMethod);
    }

    @GetMapping("/updateEvaluationAnalysis/{classId}")
    public void updateEvaluationAnalysis(@PathVariable Long classId) {
        evaluationAnalysisService.updateReactionEvaluation(classId);
    }

    @GetMapping("/evaluationAnalysistLearningResult/{classId}/{scoringMethod}")
    public ResponseEntity<EvaluationDTO.EvaluationLearningResult> evaluationAnalysistLearningResult(@PathVariable Long classId,
                                                                                                    @PathVariable String scoringMethod) {
        Float[] result =  evaluationAnalysistLearningService.getStudents(classId,scoringMethod);
        EvaluationDTO.EvaluationLearningResult resultSet = new EvaluationDTO.EvaluationLearningResult();

        Double minScoreEL = 0.0;
        Double minPasTestEL = 0.0;
        Double minPreTestEL = 0.0;
        Double FECLZ1 = 0.0;
        Double FECLZ2 = 0.0;
        Double minScoreFECR = 0.0;

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FEL");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreEL"))
                minScoreEL = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minPasTestEL"))
                minPasTestEL = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("minPreTestEL"))
                minPreTestEL = Double.parseDouble(parameterValue.getValue());
        }

        parameters = parameterService.getByCode("FEC_L");
        parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("FECLZ1"))
                FECLZ1 = Double.parseDouble(parameterValue.getValue());
            else if (parameterValue.getCode().equalsIgnoreCase("FECLZ2"))
                FECLZ2 = Double.parseDouble(parameterValue.getValue());
        }

        parameters = parameterService.getByCode("FEC_R");
        parameterValues = parameters.getResponse().getData();
        for (ParameterValueDTO.Info parameterValue : parameterValues) {
            if (parameterValue.getCode().equalsIgnoreCase("minScoreFECR"))
                minScoreFECR = Double.parseDouble(parameterValue.getValue());
        }

        float postTestMeanGrade = 0;
        float preTestMeanGrade = 0;
        float felGrade = 0;

        if(result != null && result.length > 0)
            postTestMeanGrade = result[0];
        if(result != null && result.length > 1)
            preTestMeanGrade = result[1];
        if(result != null && result.length > 2)
            felGrade = result[3];
        Double ferGrade = tclassService.getJustFERGrade(classId);
        Double feclGradeLong = (felGrade * FECLZ2 + ferGrade * FECLZ1)/100;
        Double feclGrade = Double.parseDouble(numberFormat.format(feclGradeLong).toString());

        resultSet.setFelgrade(numberFormat.format(felGrade).toString());
        if(felGrade >= minScoreEL)
            resultSet.setFelpass("true");
        else
            resultSet.setFelpass("false");
        resultSet.setLimit(minScoreEL + "");
        resultSet.setPostTestMeanScore(numberFormat.format(postTestMeanGrade).toString());
        resultSet.setPreTestMeanScore(numberFormat.format(preTestMeanGrade).toString());
        resultSet.setFeclgrade(feclGrade.floatValue() + "");
        if(feclGrade >= minScoreFECR)
            resultSet.setFeclpass("true");
        else
            resultSet.setFeclpass("false");

        Integer classHasPreTest = tclassDAO.checkIfClassHasPreTest(classId);
        if(classHasPreTest != null && classHasPreTest.equals(new Integer(1)))
            resultSet.setHavePreTest("true");
        else
            resultSet.setHavePreTest("false");

        resultSet.setHavePostTest("false");

        resultSet.setStudentCount(result[2]);

        List<ClassStudent> classStudents = classStudentDAO.findByTclassId(classId);
        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("0", 0);
        map.put("1001", 40);
        map.put("1002", 60);
        map.put("1003", 80);
        map.put("1004", 100);

        int studentCount = 0;
        List<Double> preScores = new ArrayList<>();
        List<Double> postScores = new ArrayList<>();

        for (ClassStudent classStudent : classStudents) {
            if(classStudent.getScore() != null || classStudent.getValence() != null)
                resultSet.setHavePostTest("true");

            if(scoringMethod.equalsIgnoreCase("1") && classStudent.getValence()!=null) {
                if(classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else
                    preScores.add(0.0);
                postScores.add(Double.valueOf(map.get(classStudent.getValence())));
                studentCount++;
            }
            else if(scoringMethod.equalsIgnoreCase("3") && classStudent.getScore()!=null) {
                postScores.add(Double.valueOf(classStudent.getScore()) * 5);
                if(classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else preScores.add(0.0);
                studentCount++;
            }
            else if(classStudent.getScore() != null) {
                postScores.add(Double.valueOf(classStudent.getScore()));
                if(classStudent.getPreTestScore() != null)
                    preScores.add(Double.valueOf(classStudent.getPreTestScore()));
                else  preScores.add(0.0);
                studentCount++;
            }
        }

        Map<String, Boolean> tStudentResult = new HashMap<String, Boolean>();
        if(studentCount != 0)
            tStudentResult = calculateTStudentResult(preScores, postScores,studentCount);
        if(tStudentResult.containsKey("hasDiffer") && tStudentResult.get("hasDiffer")){
            if(tStudentResult.get("positiveDiffer"))
                resultSet.setTstudent("بر اساس توزیع تی استیودنت  با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت چشمگیر مثبتی داشته اند.");
            else
                resultSet.setTstudent("بر اساس توزیع تی استیودنت با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت  چشمگیر منفی داشته اند.");
        }
        else
            resultSet.setTstudent("بر اساس توزیع تی استیودنت با ضریب اطمینان 95 درصد فراگیران بعد از شرکت در کلاس پیشرفت چشمگیری نداشته اند.");

        return new ResponseEntity<>(resultSet,HttpStatus.OK);
    }

    //------------------------------------------------TStudent----------------------------------------------------------
    //Confidence Level = 95%
    public Map<String, Boolean> calculateTStudentResult(List<Double> preScores, List<Double> postScores,int studentCount){
        HashMap<Integer, Double> tStudentTable = new HashMap<>();
        tStudentTable.put(1,12.71);
        tStudentTable.put(2,4.303);
        tStudentTable.put(3,3.182);
        tStudentTable.put(4,2.776);
        tStudentTable.put(5,2.571);
        tStudentTable.put(6,2.447);
        tStudentTable.put(7,2.365);
        tStudentTable.put(8,2.306);
        tStudentTable.put(9,2.262);
        tStudentTable.put(10,2.228);
        tStudentTable.put(11,2.201);
        tStudentTable.put(12,2.179);
        tStudentTable.put(13,2.160);
        tStudentTable.put(14,2.145);
        tStudentTable.put(15,2.131);
        tStudentTable.put(16,2.120);
        tStudentTable.put(17,2.110);
        tStudentTable.put(18,2.101);
        tStudentTable.put(19,2.093);
        tStudentTable.put(20,2.086);
        tStudentTable.put(21,2.080);
        tStudentTable.put(22,2.074);
        tStudentTable.put(23,2.069);
        tStudentTable.put(24,2.064);
        tStudentTable.put(25,2.060);
        tStudentTable.put(26,2.056);
        tStudentTable.put(27,2.052);
        tStudentTable.put(28,2.048);
        tStudentTable.put(29,2.045);
        tStudentTable.put(30,2.042);
        tStudentTable.put(40,2.021);
        tStudentTable.put(60,2.000);
        tStudentTable.put(80,1.990);
        tStudentTable.put(100,1.984);

        Double preScores_mean = getMean(preScores,studentCount);
        Double postScores_mean = getMean(postScores, studentCount);

        Double preScores_deviation = getDeviation(preScores, studentCount,preScores_mean);
        Double postScores_deviation = getDeviation(postScores, studentCount, postScores_mean);

        Double difference_sum = getDifference(preScores,postScores,studentCount);
        Double difference_average = difference_sum/studentCount;
        Double difference_deviation = getDifferenceDeviation(preScores,postScores,studentCount,difference_sum);
        Double t = difference_sum / difference_deviation;
        Double t_table=0.0;
        if(studentCount<=30)
            t_table = tStudentTable.get(studentCount);
        else if(studentCount>30 && studentCount<=40)
            t_table = tStudentTable.get(40);
        else if(studentCount>40 && studentCount<=60)
            t_table = tStudentTable.get(60);
        else if(studentCount>60 && studentCount<=80)
            t_table = tStudentTable.get(80);
        else if(studentCount>80 && studentCount<=100)
            t_table = tStudentTable.get(100);
        Boolean hasDiffer = false;
        if(Math.abs(t) < t_table)
            hasDiffer = false;
        else if(Math.abs(t) >= t_table)
            hasDiffer = true;
        Boolean positiveDiffer = false;
        if(t<0)
            positiveDiffer = true;
        else if(t>0)
            positiveDiffer = false;

        Map<String, Boolean> result = new HashMap<>();
        result.put("positiveDiffer",positiveDiffer);
        result.put("hasDiffer",hasDiffer);
        return  result;
    }

    public Double getMean(List<Double> list, int n){
        Double sum = 0.0;
        for (Double aDouble : list) {
            sum += aDouble;
        }
        return  sum/n;
    }

    public Double getDeviation(List<Double> list, int n,Double average){
        Double dv = 0.0;
        for (Double aDouble : list) {
            double dm = aDouble - average;
            dv += dm * dm;
        }
        return Math.sqrt(dv / n);
    }

    public Double getDifference(List<Double> list1, List<Double> list2, int n){
        Double sum = 0.0;
        for(int i=0;i<n;i++){
            sum += list1.get(i) - list2.get(i);

        }
        return sum;
    }

    public Double getDifferenceDeviation(List<Double> list1, List<Double> list2, int n, Double differenceSum){
        Double t1 = 0.0;
        for (int i=0;i<n;i++){
            Double dm = list1.get(i) - list2.get(i);
            t1 += dm * dm;
        }
        return Math.sqrt( ((n*t1) - (differenceSum*differenceSum))/(n-1) );
    }

    //------------------------------------------------------------------------------------------------------------------

    }
