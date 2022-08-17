package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.IParameterService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.Coordinate;
import com.nicico.training.service.*;
import com.nicico.training.utility.PersianCharachtersUnicode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnalysis")
public class EvaluationAnalysisRestController {
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;
    private final ICategoryService categoryService;
    private final ITclassService tclassService;
    private final IParameterService parameterService;
    private static final DecimalFormat df = new DecimalFormat("0.00");

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

    @Loggable
    @PostMapping(value = {"/printExecutionEvaluation"})
    public void printExecutionEvaluation(HttpServletResponse response,
                                        @RequestParam(value = "code") String code,
                                        @RequestParam(value = "id") String id,
                                         @RequestParam(value = "titleClass") String titleClass,
                                        @RequestParam(value = "term") String term,
                                         @RequestParam(value = "studentCount") String studentCount,
                                        @RequestParam(value = "classStatus") String classStatus,
                                         @RequestParam(value = "teacher") String teacher,
                                        @RequestParam(value = "studentsGradeToTeacher") String studentsGradeToTeacher ,
                                        @RequestParam(value = "numberOfExportedExecutionEvaluationForms") String numberOfExportedExecutionEvaluationForms,
                                        @RequestParam(value = "numberOfFilledExecutionEvaluationForms") String numberOfFilledExecutionEvaluationForms,
                                        @RequestParam(value = "numberOfInCompletedExecutionEvaluationForms") String numberOfInCompletedExecutionEvaluationForms,
                                        @RequestParam(value = "percentOfFilledExecutionEvaluationForms") String percentOfFilledExecutionEvaluationForms,
                                        @RequestParam(value = "FEEGrade") String FEEGrade,
                                       @RequestParam(value = "executionEvaluationStatus") String executionEvaluationStatus,
                                         @RequestParam(value = "z9") String z9,@RequestParam(value = "differ") String differ
                                    ) throws Exception {
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

        params.put("numberOfExportedExecutionEvaluationForms", numberOfExportedExecutionEvaluationForms);
        params.put("numberOfFilledExecutionEvaluationForms", numberOfFilledExecutionEvaluationForms);
        params.put("numberOfInCompletedExecutionEvaluationForms", numberOfInCompletedExecutionEvaluationForms);
        params.put("percentOfFilledExecutionEvaluationForms", percentOfFilledExecutionEvaluationForms);

        params.put("FEEGrade", FEEGrade);

        params.put("executionEvaluationStatus",executionEvaluationStatus);
        params.put("z9",z9);
        params.put("differ",differ);





        if(!studentsGradeToTeacher.equalsIgnoreCase(""))
            params.put("studentsGradeToTeacher", Double.parseDouble(studentsGradeToTeacher));
        else
            params.put("studentsGradeToTeacher", 0.0);

        //zazazaza.


        HashMap<Double,String> doubleArrayList = new HashMap<>();



        doubleArrayList = new HashMap<>();
        if(!studentsGradeToTeacher.equalsIgnoreCase(""))
            doubleArrayList.put(Double.parseDouble(studentsGradeToTeacher),"نمره فراگیران به مدرس");


        TclassDTO.ExecutionEvaluationResult chartData=  tclassService.getExecutionEvaluationResult(Long.valueOf(id));
        List<Coordinate> xyData = new ArrayList<>();
        chartData.getQuestionnaireQuestions().forEach(item->{
            xyData.add(new Coordinate(item.getQuestionOrder().intValue(), item.getAveGradeToQuestion(),"" ,item.getQuestionTitle()));

        });

        final String[] addition = {""};
        xyData.stream().forEach(xy->{
            addition[0] +=  xy.getCourseName()+"<--"+xy.getHorizontal()+"\n";
        });

        params.put("CHART_DATA",xyData);
        xyData.stream().forEach(xy->{
            params.put("horizontal",xy.getHorizontal());
            params.put("vertical",xy.getVertical());
        });
         params.put("chart_caption", addition[0]);
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(xyData) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));


        reportUtil.export("/reports/ExecutionEvaluationResult.jasper", params, jsonDataSource, response);
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
        params.put("learningRate", result.getLearningRate().toString());
        params.put("preTestScore", result.getPreTestMeanScore());
        params.put("ScoreEvaluation",result.getFelgrade());
        if(result.getFelpass() != null && result.getFelpass().equalsIgnoreCase("true"))
        {
            params.put("resault","تایید است");
        }
        else
        {
            params.put("resault","تایید نیست");
        }


        params.put("ScoreEffective", result.getFeclgrade());
        if(result.getFeclpass() != null && result.getFeclpass().equalsIgnoreCase("true"))
            params.put("resultEffective", "تایید است");
        else
            params.put("resultEffective", "تایید نیست");

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

    @Loggable
    @PostMapping(value = {"/printReactionEvaluationReport"})
    public void printReactionEvaluationReport(HttpServletResponse response, @RequestParam(value = "CriteriaStr") String criteriaStr,
                                              @RequestParam(value = "object") String object) throws Exception {

        //////////////////// word ////////////////////
//        String sourceFileName ="C:\\Users\\razmnoosh\\IdeaProjects\\training\\main\\src\\main\\resources\\reports\\reactionEvaluationReport.jasper";
//        Map<String, Object> params = new HashMap();
//        List<List<ChartData>> allchartData = new ArrayList<>();
//
//        List<ChartData> chartData = null;
//        chartData = new ArrayList<>();
//        chartData.add(new ChartData(1, "شاخص 1", 30.0,"table1"));
//        chartData.add(new ChartData(2, "شاخص 2", 40.0,"table1"));
//        chartData.add(new ChartData(3, "شاخص 3", 50.0,"table1"));
//
//        allchartData.add(chartData);
//        chartData = new ArrayList<>();
//        chartData.add(new ChartData(1, "شاخص 1", 25.0,"table2"));
//        chartData.add(new ChartData(2, "شاخص 2", 60.0,"table2"));
//        chartData.add(new ChartData(3, "شاخص 3", 80.0,"table2"));
//
//        allchartData.add(chartData);
//
//        params.put("XYChartDataSource", allchartData);
//        params.put("reportTime","تیر ماه");
//        params.put("todayDate",DateUtil.todayDate());
//        params.put("minFerGrade","75");
//
//        List<TableData> tableData = new ArrayList<>();
//        TableData tableData1 = new TableData("20","دوره 1");
//        TableData tableData2 = new TableData("30","دوره 2");
//        tableData.add(tableData1);
//        tableData.add(tableData2);
//
//        JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(tableData);
//
//        JasperPrint jasperPrint = JasperFillManager.fillReport(sourceFileName, params, beanColDataSource);
//        JRDocxExporter exporter = new JRDocxExporter();
//        exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
//        exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(response.getOutputStream()));
//        response.setHeader("Content-Disposition", "attachment;filename=jasperfile.docx");
//        response.setContentType("application/octet-stream");
//        exporter.exportReport();
        //////////////////// word ////////////////////

        JSONObject reportComments = new JSONObject(object);

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);

            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setValue(null);
            criteriaRq1.setOperator(EOperator.notNull);
            criteriaRq1.setFieldName("evaluationReactionGrade");
            criteriaRq.getCriteria().add(criteriaRq1);

            SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
            criteriaRq2.setValue(0);
            criteriaRq2.setOperator(EOperator.notEqual);
            criteriaRq2.setFieldName("tclassStudentsCount");
            criteriaRq.getCriteria().add(criteriaRq2);

            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        final SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> searchRs = viewEvaluationStaticalReportService.search(searchRq);

        Map<String, Object> params = new HashMap();

        List<List<ChartData>> allchartData = new ArrayList<>();
        List<List<NotPassedChartData>> allNotPassedChartData = new ArrayList<>();
        List<TableData> tableData = new ArrayList<>();
        List<CategoryDTO.Info> categoryList =  categoryService.list();
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FER");
        ParameterValueDTO.Info minFerGrade = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("minScoreER")).findFirst().orElse(null);

        int catCount = 1;
        for (CategoryDTO.Info category : categoryList) {
            List<ViewEvaluationStaticalReportDTO.Info> list =  searchRs.getList().stream().filter(p->p.getCourseCategory().equals(category.getId())).collect(Collectors.toList());
            if(list != null && list.size() != 0){
                List<ChartData> chartData = new ArrayList<>();
                int index = 1;
                if (list.size()>10){
                    int  totalPage = (list.size() / 15)+1;
                    List<List<ViewEvaluationStaticalReportDTO.Info>> subLists=  GetSubList(list,totalPage);

                    for (int m=0 ; m<subLists.size();m++){
                        List<ViewEvaluationStaticalReportDTO.Info> subV2=subLists.get(m);

                        for (int z=0 ; z<subV2.size();z++) {
                            ViewEvaluationStaticalReportDTO.Info info=subV2.get(z);

                            chartData.add(new ChartData(PersianCharachtersUnicode.bidiReorder(info.getCourseTitleFa()) + "/" + info.getTclassCode()+ "("+info.getPercentReaction()+"% )" , z+1 + "" ,
                                    Double.parseDouble(df.format(Double.parseDouble(info.getEvaluationReactionGrade()))), catCount + ". واحد " + category.getTitleFa()+" بخش "+" ( "+(m+1)+" ) ",
                                    Double.parseDouble(minFerGrade.getValue())));

                            if(Double.parseDouble(info.getEvaluationReactionGrade()) < Double.parseDouble(minFerGrade.getValue())){
                                TableData tableData1 = new TableData(df.format(Double.valueOf(info.getEvaluationReactionGrade())),info.getCourseTitleFa() + "/" + info.getTclassCode(),info.getId(),info.getPercentReaction());
                                tableData.add(tableData1);
                            }
                        }
                        allchartData.add(chartData);
                        chartData = new ArrayList<>();
                        catCount++;

                    }




                }else {
                    for (ViewEvaluationStaticalReportDTO.Info info : list) {
                        chartData.add(new ChartData(PersianCharachtersUnicode.bidiReorder(info.getCourseTitleFa()) + "/" + info.getTclassCode()+ "("+info.getPercentReaction()+"% )" , index + "",
                                Double.parseDouble(df.format(Double.parseDouble(info.getEvaluationReactionGrade()))), catCount + ". واحد " + category.getTitleFa(),
                                Double.parseDouble(minFerGrade.getValue())));

                        index++;
                        if (Double.parseDouble(info.getEvaluationReactionGrade()) < Double.parseDouble(minFerGrade.getValue())) {
                            TableData tableData1 = new TableData(df.format(Double.valueOf(info.getEvaluationReactionGrade())), info.getCourseTitleFa() + "/" + info.getTclassCode(), info.getId(),info.getPercentReaction());
                            tableData.add(tableData1);
                        }
                    }
                    allchartData.add(chartData);
                    catCount++;
                }

            }
        }

        for (TableData tableDatum : tableData) {
            List<NotPassedChartData> chartData = new ArrayList<>();
            allNotPassedChartData.add(chartData);
        }

        Iterator iterator = reportComments.keys();
        while(iterator.hasNext()){
            Object key = iterator.next();
            if(key.equals("title"))
                params.put("title", reportComments.getString(key.toString()));
            else if(key.equals("description"))
                params.put("description",reportComments.getString(key.toString()));
            iterator.remove();
        }

        params.put("XYChartDataSource", allchartData);
        params.put("XYNotPassedChartDataSource",allNotPassedChartData);
        params.put("todayDate",DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        params.put("minFerGrade",minFerGrade.getValue());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(tableData) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        reportUtil.export("/reports/reactionEvaluationReport.jasper", params, jsonDataSource, response);
    }

    public static class ChartData{
        private String series;

        private String xCoordinate;

        private Double yCoordinate;

        private Double maxValue;

        private String title;

        public Double getMaxValue() {
            return maxValue;
        }

        public void setMaxValue(Double maxValue) {
            this.maxValue = maxValue;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getTitle() {
            return title;
        }

        public ChartData(String series, String xCoordinate, Double yCoordinate, String title,Double maxValue){
            this.series = series;
            this.xCoordinate = xCoordinate;
            this.yCoordinate = yCoordinate;
            this.title = title;
            this.maxValue = maxValue;
        }

        public String getSeries() {
            return series;
        }

        public String getxCoordinate() {
            return xCoordinate;
        }

        public Double getyCoordinate() {
            return yCoordinate;
        }

        public void setSeries(String series) {
            this.series = series;
        }

        public void setxCoordinate(String xCoordinate) {
            this.xCoordinate = xCoordinate;
        }

        public void setyCoordinate(Double yCoordinate) {
            this.yCoordinate = yCoordinate;
        }
    }

    public static class NotPassedChartData{
        private String seriesNP;

        private String xCoordinateNP;

        private Double yCoordinateNP;

        private Double maxValueNP;

        private String titleNP;

        private String commentsNP;

        public NotPassedChartData() {
        }

        public NotPassedChartData(String seriesNP, String xCoordinateNP, Double yCoordinateNP, Double maxValueNP, String titleNP, String commentsNP) {
            this.seriesNP = seriesNP;
            this.xCoordinateNP = xCoordinateNP;
            this.yCoordinateNP = yCoordinateNP;
            this.maxValueNP = maxValueNP;
            this.titleNP = titleNP;
            this.commentsNP = commentsNP;
        }

        public void setSeriesNP(String seriesNP) {
            this.seriesNP = seriesNP;
        }

        public void setxCoordinateNP(String xCoordinateNP) {
            this.xCoordinateNP = xCoordinateNP;
        }

        public void setyCoordinateNP(Double yCoordinateNP) {
            this.yCoordinateNP = yCoordinateNP;
        }

        public void setMaxValueNP(Double maxValueNP) {
            this.maxValueNP = maxValueNP;
        }

        public void setTitleNP(String titleNP) {
            this.titleNP = titleNP;
        }

        public void setCommentsNP(String commentsNP) {
            this.commentsNP = commentsNP;
        }

        public String getSeriesNP() {
            return seriesNP;
        }

        public String getxCoordinateNP() {
            return xCoordinateNP;
        }

        public Double getyCoordinateNP() {
            return yCoordinateNP;
        }

        public Double getMaxValueNP() {
            return maxValueNP;
        }

        public String getTitleNP() {
            return titleNP;
        }

        public String getCommentsNP() {
            return commentsNP;
        }
    }

    public static class TableData{
        private String courseGrade;
        private String reactionPer;
        private String courseName;
        private Long id;

        public TableData() {
        }

        public TableData(String courseGrade, String courseName,Long id,String reactionPer) {
            this.courseGrade = courseGrade;
            this.courseName = courseName;
            this.reactionPer = reactionPer;
            this.id = id;
        }

        public void setCourseGrade(String courseGrade) {
            this.courseGrade = courseGrade;
        }

        public void setCourseName(String courseName) {
            this.courseName = courseName;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public Long getId() {
            return id;
        }

        public String getCourseGrade() {
            return courseGrade;
        }

        public String getReactionPer() {
            return reactionPer;
        }

        public void setReactionPer(String reactionPer) {
            this.reactionPer = reactionPer;
        }

        public String getCourseName() {
            return courseName;
        }
    }

    @Loggable
    @PostMapping(value = {"/classNotPassedReactionEvaluation"})
    public ResponseEntity<?>  listOfclassNotPassedReactionEvaluation(@RequestBody String request) throws IOException {
        JSONObject jsonObject = new JSONObject(request);
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (jsonObject.toString().equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(jsonObject.toString(), SearchDTO.CriteriaRq.class);

            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setValue(null);
            criteriaRq1.setOperator(EOperator.notNull);
            criteriaRq1.setFieldName("evaluationReactionGrade");
            criteriaRq.getCriteria().add(criteriaRq1);

            SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
            criteriaRq2.setValue(0);
            criteriaRq2.setOperator(EOperator.notEqual);
            criteriaRq2.setFieldName("tclassStudentsCount");
            criteriaRq.getCriteria().add(criteriaRq2);

            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        final SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> searchRs = viewEvaluationStaticalReportService.search(searchRq);

        List<TableData> tableData = new ArrayList<>();
        List<CategoryDTO.Info> categoryList =  categoryService.list();
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("FER");
        ParameterValueDTO.Info minFerGrade = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("minScoreER")).findFirst().orElse(null);

        for (CategoryDTO.Info category : categoryList) {
            List<ViewEvaluationStaticalReportDTO.Info> list =  searchRs.getList().stream().filter(p->p.getCourseCategory().equals(category.getId())).collect(Collectors.toList());
            if(list != null && list.size() != 0){
                for (ViewEvaluationStaticalReportDTO.Info info : list) {
                    if(Double.parseDouble(info.getEvaluationReactionGrade()) < Double.parseDouble(minFerGrade.getValue())){
                        TableData tableData1 = new TableData(info.getEvaluationReactionGrade(),info.getCourseTitleFa() + "/" + info.getTclassCode(),info.getId(),info.getPercentReaction());
                        tableData.add(tableData1);
                    }
                }
            }
        }
        return new ResponseEntity<>(tableData,HttpStatus.OK);
    }
    public List<List<ViewEvaluationStaticalReportDTO.Info>> GetSubList(List<ViewEvaluationStaticalReportDTO.Info> list, final int splitCount) {
        List<List<ViewEvaluationStaticalReportDTO.Info>> parts = new ArrayList<>(splitCount);
        for (int i = 0; i < splitCount; ++i) {
            parts.add(new ArrayList<>());
        }
        final int N = list.size();
        for (int i = 0; i < N; ++i) {
            parts.get(i % splitCount).add(list.get(i));
        }
        return parts;
    }
}
