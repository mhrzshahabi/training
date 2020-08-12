package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluation")
public class EvaluationRestController {

    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ModelMapper modelMapper;
    private final EvaluationService evaluationService;
    private final ClassStudentService classStudentService;
    private final TclassService tclassService;
    private final EvaluationDAO evaluationDAO;
    private final PersonnelDAO personnelDAO;
    private final ParameterValueDAO parameterValueDAO;
    private final QuestionnaireQuestionDAO questionnaireQuestionDAO;
    private final DynamicQuestionDAO dynamicQuestionDAO;
    private final ClassStudentDAO classStudentDAO;

    @Loggable
    @PostMapping("/printWithCriteria")
    @Transactional
    public void printWithCriteria(HttpServletResponse response,
                                  @RequestParam(value = "printData") String printData) throws Exception {

        JSONObject jsonObject = new JSONObject(printData);
        Long classId = Long.parseLong(jsonObject.get("classId").toString());
        Long evaluatorId = Long.parseLong(jsonObject.get("evaluatorId").toString());
        Long evaluatorTypeId = Long.parseLong(jsonObject.get("evaluatorTypeId").toString());
        Long evaluatedId = Long.parseLong(jsonObject.get("evaluatedId").toString());
        Long evaluatedTypeId = Long.parseLong(jsonObject.get("evaluatedTypeId").toString());
        Long questionnaireTypeId = Long.parseLong(jsonObject.get("questionnaireTypeId").toString());
        Long evaluationLevelId = Long.parseLong(jsonObject.get("evaluationLevelId").toString());

        EvaluationDTO.Info evaluation = evaluationService.getEvaluationByData(questionnaireTypeId, classId, evaluatorId,
                                                        evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);

        TclassDTO.Info classInfo = tclassService.get(classId);

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> result = new ArrayList<>();


        for (EvaluationAnswerDTO.Info evaluationAnswerDTO : evaluation.getEvaluationAnswerList()) {
            EvaluationAnswerDTO.EvaluationAnswerFullData evaluationAnswerFullData = new EvaluationAnswerDTO.EvaluationAnswerFullData();
            evaluationAnswerFullData.setId(evaluationAnswerDTO.getId());
            evaluationAnswerFullData.setEvaluationId(evaluationAnswerDTO.getEvaluationId());
            evaluationAnswerFullData.setEvaluationQuestionId(evaluationAnswerDTO.getEvaluationQuestionId());
            evaluationAnswerFullData.setQuestionSourceId(evaluationAnswerDTO.getQuestionSourceId());
            evaluationAnswerFullData.setAnswerId(evaluationAnswerDTO.getAnswerId());
            evaluationAnswerFullData.setDescription(evaluation.getDescription());

            if(evaluationAnswerFullData.getQuestionSourceId().equals(199L)){
                QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(questionnaireQuestion.getOrder());
                evaluationAnswerFullData.setWeight(questionnaireQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                evaluationAnswerFullData.setDomainId(questionnaireQuestion.getEvaluationQuestion().getDomainId());
            }
            else  if(evaluationAnswerFullData.getQuestionSourceId().equals(200L) || evaluationAnswerFullData.getQuestionSourceId().equals(201L)){
                DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                evaluationAnswerFullData.setOrder(dynamicQuestion.getOrder());
                evaluationAnswerFullData.setWeight(dynamicQuestion.getWeight());
                evaluationAnswerFullData.setQuestion(dynamicQuestion.getQuestion());
            }

            result.add(evaluationAnswerFullData);
        }

//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//        params.put("courseCode", classInfo.getCourse().getCode());
//        params.put("courseName", classInfo.getCourse().getTitleFa());
//        params.put("classCode", classInfo.getCode());
//        params.put("startDate", classInfo.getStartDate());
//        params.put("endDate", classInfo.getEndDate());
//        params.put("evaluationAudience", evaluationAudience.equals("null") ? "" : "مخاطب : " + evaluationAudience);
//        params.put("evaluationAudienceType", "("+evaluationAudienceType+")");
//        params.put("returnDate", evaluation.getReturnDate().replace("-", "/"));
//        params.put("evaluationLevel", (evaluationLevelId.equals(154L) ? "(واکنشی)" :
//                evaluationLevelId.equals(155L) ? "(یادگیری)" :
//                        evaluationLevelId.equals(156L) ? "(رفتاری)" : evaluationLevelId.equals(157L) ? "(نتایج)" : "(متفرقه)"));
//        params.put("questionnaireType", (questionnaireTypeId.equals(140L) ? "(پرسشنامه ارزیابی مدرس از کلاس)" :
//                questionnaireTypeId.equals(230L) ? "(پرسشنامه ارزیابی دیگری از فراگیر)" :
//                        questionnaireTypeId.equals(139L) ? "(پرسشنامه ارزیابی فراگیر از کلاس)" :
//                                questionnaireTypeId.equals(141L) ?  "(پرسشنامه ارزیابی مسئول آموزش از مدرس)" : "متفرقه"));
//
//
//        Set<ClassStudentDTO.AttendanceInfo> classStudent = classInfo.getClassStudentsForEvaluation(studentId);
//
//        String data = "{" + "\"dsStudent\": " + objectMapper.writeValueAsString(classStudent) + "," +
//                "\"dsTeacherQuestion\": " + objectMapper.writeValueAsString(evaluationQuestion) + "}";


//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//
//        params.put(ConstantVARs.REPORT_TYPE, "pdf");
//        reportUtil.export("/reports/EvaluationForm.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<EvaluationDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(evaluationService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<EvaluationDTO.Info>> list() {
        return new ResponseEntity<>(evaluationService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<EvaluationDTO.Info> create(@RequestBody Object req) {
        EvaluationDTO.Create create = modelMapper.map(req, EvaluationDTO.Create.class);
        EvaluationDTO.Info info = evaluationService.create(create);
        return new ResponseEntity<>(info, HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<EvaluationDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
        EvaluationDTO.Update update = modelMapper.map(request, EvaluationDTO.Update.class);
        EvaluationDTO.Info info = evaluationService.update(id, update);
        return new ResponseEntity<>(info, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        evaluationService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity delete(@Validated @RequestBody EvaluationDTO.Delete request) {
        evaluationService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<EvaluationDTO.EvaluationSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                               @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                               @RequestParam(value = "_constructor", required = false) String constructor,
                                                               @RequestParam(value = "operator", required = false) String operator,
                                                               @RequestParam(value = "criteria", required = false) String criteria,
                                                               @RequestParam(value = "id", required = false) Long id,
                                                               @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<EvaluationDTO.Info> response = evaluationService.search(request);
        final EvaluationDTO.SpecRs specResponse = new EvaluationDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final EvaluationDTO.EvaluationSpecRs specRs = new EvaluationDTO.EvaluationSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<EvaluationDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(evaluationService.search(request), HttpStatus.OK);
    }

    private void studentEvaluationRegister(EvaluationDTO.Info evaluation){
        if(evaluation.getQuestionnaireTypeId().equals(139L)){
            Integer x;
            if(evaluation.getEvaluationFull()) {
                x = 2;
            }
            else {
                x = 3;
            }
            ClassStudent classStudent = classStudentService.getClassStudent(evaluation.getEvaluatorId());
            if (evaluation.getEvaluationLevelId() == 154L) {
                classStudentService.update(classStudent.getId(), classStudent.setEvaluationStatusReaction(x), ClassStudentDTO.ClassStudentInfo.class);
            } else if (evaluation.getEvaluationLevelId() == 155L) {
                classStudentService.update(classStudent.getId(), classStudent.setEvaluationStatusLearning(x), ClassStudentDTO.ClassStudentInfo.class);
            } else if (evaluation.getEvaluationLevelId() == 156L) {
                classStudentService.update(classStudent.getId(), classStudent.setEvaluationStatusBehavior(x), ClassStudentDTO.ClassStudentInfo.class);
            } else if (evaluation.getEvaluationLevelId() == 157L) {
                classStudentService.update(classStudent.getId(), classStudent.setEvaluationStatusResults(x), ClassStudentDTO.ClassStudentInfo.class);
            }
        }
    }

    @Loggable
    @GetMapping(value = "/class-spec-list")
    public ResponseEntity<TclassDTO.TclassSpecRs> classList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);

        //*********************************
        //******old code for alarms********
////        for (TclassDTO.Info tclassDTO : response.getList()) {
////            if (classAlarmService.hasAlarm(tclassDTO.getId(), httpResponse).size() > 0)
////                tclassDTO.setHasWarning("alarm");
////           else
////              tclassDTO.setHasWarning("");
////        }
        //*********************************

        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        for (TclassDTO.Info datum : specResponse.getData()) {
            LocalDate todayDate = LocalDate.now();
            String tDate = getPersianDate(todayDate.getYear(),todayDate.getMonthValue(),todayDate.getDayOfMonth());
            datum.setHasWarning("");
            if(datum.getEndDate().equalsIgnoreCase(tDate) && datum.getCourse().getEvaluation().equalsIgnoreCase("1")) {
                datum.setHasWarning("alarm");
            }
            if(datum.getStartDate().equalsIgnoreCase(tDate) && datum.getCourse().getEvaluation().equalsIgnoreCase("2")) {
                datum.setHasWarning("alarm");
            }
        }
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping("/getEvaluationForm")
    public  ResponseEntity<ISC> getEvaluationForm(@RequestBody HashMap req) {
        List<EvaluationAnswerDTO.EvaluationAnswerFullData> result = evaluationService.getEvaluationForm(req);

        if(result != null) {
            ISC.Response<EvaluationAnswerDTO.EvaluationAnswerFullData> response = new ISC.Response<>();
            response.setData(result)
                    .setStartRow(0)
                    .setEndRow(result.size())
                    .setTotalRows(result.size());
            ISC<Object> objectISC = new ISC<>(response);
            return new ResponseEntity<>(objectISC, HttpStatus.OK);
        }
        else
            return new ResponseEntity<>(null, HttpStatus.NOT_ACCEPTABLE);
    }

    @Loggable
    @PostMapping("/deleteEvaluation")
    public  ResponseEntity deleteEvaluation(@RequestBody HashMap req) {
        evaluationService.deleteEvaluation(req);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    //--------------------------------------------- Calender -----------------------------------------------------------
    private static double greg_len = 365.2425;
    private static double greg_origin_from_jalali_base = 629964;
    private static double len = 365.24219879;

    public static String getPersianDate(Date d) {
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(d);
        int year = gc.get(Calendar.YEAR);
        return getPersianDate(year, (gc.get(Calendar.MONTH)) + 1,
                gc.get(Calendar.DAY_OF_MONTH));
    }

    public static String getPersianDate(int gregYear, int gregMonth, int gregDay) {
        // passed days from Greg orig
        double d = Math.ceil((gregYear - 1) * greg_len);
        // passed days from jalali base
        double d_j = d + greg_origin_from_jalali_base
                + getGregDayOfYear(gregYear, gregMonth, gregDay);

        // first result! jalali year
        double j_y = Math.ceil(d_j / len) - 2346;
        // day of the year
        double j_days_of_year = Math
                .floor(((d_j / len) - Math.floor(d_j / len)) * 365) + 1;

        StringBuffer result = new StringBuffer();

        if(month(j_days_of_year) < 10 && dayOfMonth(j_days_of_year) < 10)
            result.append((int) j_y + "/0" + (int) month(j_days_of_year) + "/0"
                    + (int) dayOfMonth(j_days_of_year));
        else if(month(j_days_of_year) >= 10 && dayOfMonth(j_days_of_year) < 10)
            result.append((int) j_y + "/" + (int) month(j_days_of_year) + "/0"
                    + (int) dayOfMonth(j_days_of_year));
        else if(month(j_days_of_year) < 10 && dayOfMonth(j_days_of_year) >= 10)
            result.append((int) j_y + "/0" + (int) month(j_days_of_year) + "/"
                    + (int) dayOfMonth(j_days_of_year));
        else
            result.append((int) j_y + "/" + (int) month(j_days_of_year) + "/"
                    + (int) dayOfMonth(j_days_of_year));

        return result.toString();
    }

    private static double month(double day) {

        if (day < 6 * 31)
            return Math.ceil(day / 31);
        else
            return Math.ceil((day - 6 * 31) / 30) + 6;
    }

    private static double dayOfMonth(double day) {

        double m = month(day);
        if (m <= 6)
            return day - 31 * (m - 1);
        else
            return day - (6 * 31) - (m - 7) * 30;
    }

    private static double getGregDayOfYear(double year, double month, double day) {
        int greg_moneths_len[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
                30, 31};
        boolean leap = false;
        if (((year % 4) == 0) && (((year % 400) != 0)))
            leap = true;
        if (leap)
            greg_moneths_len[2] = 29;
        int sum = 0;
        for (int i = 0; i < month; i++)
            sum += greg_moneths_len[i];
        return sum + day - 2;
    }
    //--------------------------------------------- Calender -----------------------------------------------------------

    @GetMapping(value = "/getBehavioralForms/{stdId}/{classId}")
    @Transactional
    public ResponseEntity<ISC<EvaluationDTO.BehavioralForms>> getBehavioralForms(HttpServletRequest iscRq, @PathVariable Long stdId, @PathVariable Long classId) throws IOException {
        SearchDTO.SearchRs<EvaluationDTO.BehavioralForms> searchRs = new SearchDTO.SearchRs<>();
        List<Evaluation> list =  evaluationDAO.findByClassIdAndEvaluatedIdAndEvaluationLevelIdAndQuestionnaireTypeId(classId,stdId,156L, 230L);
        List<EvaluationDTO.BehavioralForms> finalList = new ArrayList<>();
        for (Evaluation evaluation : list) {
            EvaluationDTO.BehavioralForms behavioralForms = new EvaluationDTO.BehavioralForms();
            behavioralForms.setEvaluatorTypeId(evaluation.getEvaluatorTypeId());
            behavioralForms.setStatus(evaluation.getStatus());
            if(evaluation.getEvaluatorTypeId() == 188) {
                ClassStudent classStudent = classStudentService.getClassStudent(evaluation.getEvaluatorId());
                behavioralForms.setEvaluatorId(classStudent.getId());
                behavioralForms.setEvaluatorName(classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
            }
            else {
                Personnel personnel = personnelDAO.findById(evaluation.getEvaluatorId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                behavioralForms.setEvaluatorId(personnel.getId());
                behavioralForms.setEvaluatorName(personnel.getFirstName() + " " + personnel.getLastName());
            }
            behavioralForms.setId(evaluation.getId());
            behavioralForms.setReturnDate(evaluation.getReturnDate());
            final Optional<ParameterValue> optionalParameterValue = parameterValueDAO.findById(evaluation.getEvaluatorTypeId());
            if(optionalParameterValue.isPresent()) {
                final ParameterValue parameterValue = optionalParameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                behavioralForms.setEvaluatorTypeTitle(parameterValue.getTitle());
            }
            behavioralForms.setStatus(evaluation.getStatus());
            finalList.add(behavioralForms);
        }
        searchRs.setList(finalList);
        searchRs.setTotalCount(Long.parseLong(finalList.size()+""));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/personnelEvaluationForms/{nationalCode}/{personnelId}")
    public ResponseEntity<ISC<EvaluationDTO.EvaluationForm>> personnelEvaluationForms(HttpServletRequest iscRq, @PathVariable String nationalCode, @PathVariable Long personnelId) throws IOException {
        SearchDTO.CriteriaRq  criteria1 = makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null);
        SearchDTO.CriteriaRq  criteria2 = makeNewCriteria("evaluationStatusReaction",1, EOperator.equals, null);
        SearchDTO.CriteriaRq  criteria3 = makeNewCriteria("numberOfSendedBehavioralForms",0, EOperator.greaterThan, null);
        List<SearchDTO.CriteriaRq> criteriaRqList1 = new ArrayList<>();
        criteriaRqList1.add(criteria2);
        criteriaRqList1.add(criteria3);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null,null,EOperator.or,criteriaRqList1);
        List<SearchDTO.CriteriaRq> criteriaRqList2 = new ArrayList<>();
        criteriaRqList2.add(criteriaRq);
        criteriaRqList2.add(criteria1);
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        searchRq.setCriteria(makeNewCriteria(null,null,EOperator.and,criteriaRqList2));
        SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> evaluationResult = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

        List<EvaluationDTO.EvaluationForm> result = new ArrayList<>();
        for (ClassStudentDTO.ClassStudentInfo classStudentInfo : evaluationResult.getList()) {
            if(classStudentInfo.getEvaluationStatusReaction() != null && classStudentInfo.getEvaluationStatusReaction().equals(1)){
                EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                res.setClassId(classStudentInfo.getTclassId());
                res.setEvaluatorId(classStudentInfo.getId());
                res.setEvaluatorName(classStudentInfo.getFullName());
                res.setEvaluatedId(classStudentInfo.getTclassId());
                res.setEvaluatedName(classStudentInfo.getTclass().getCourse().getTitleFa());
                res.setEvaluatedTypeId(504L);
                res.setEvaluatorTypeId(188L);
                res.setClassCode(classStudentInfo.getTclass().getCode());
                res.setCourseCode(classStudentInfo.getTclass().getCourse().getCode());
                res.setCourseTitle(classStudentInfo.getTclass().getCourse().getTitleFa());
                res.setTeacherName(classStudentInfo.getTclass().getTeacher());
                res.setClassStartDate(classStudentInfo.getTclass().getStartDate());
                res.setClassEndDate(classStudentInfo.getTclass().getEndDate());
                res.setClassDuration(classStudentInfo.getTclass().getHDuration());
                res.setClassYear(classStudentInfo.getTclass().getStartDate().substring(0,4));
                final Optional<Personnel> pByID1 = personnelDAO.findById(classStudentInfo.getTclass().getSupervisor());
                final Optional<Personnel> pByID2 = personnelDAO.findById(classStudentInfo.getTclass().getPlanner());
                Personnel personnel1 = null;
                Personnel personnel2 = null;
                if(pByID1.isPresent())
                    personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(pByID2.isPresent())
                    personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(personnel1 != null)
                    res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                if(personnel2 != null)
                    res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                res.setEvaluationLevel(154L);
                res.setQuestionnarieType(139L);
                res.setHasWarning("alarm");
                result.add(res);
            }
            if(classStudentInfo.getNumberOfSendedBehavioralForms() != null && classStudentInfo.getNumberOfSendedBehavioralForms() > 0){
                    Evaluation evaluation = evaluationDAO.findFirstByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                        classStudentInfo.getTclassId(),classStudentInfo.getId(),188L,188L,156L, 230L);
                    if(evaluation != null) {
                        if (evaluation.getStatus() == false || evaluation.getStatus() == null) {
                            EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                            res.setClassId(classStudentInfo.getTclassId());
                            res.setEvaluatorId(classStudentInfo.getId());
                            res.setEvaluatorName(classStudentInfo.getFullName());
                            res.setEvaluatedId(classStudentInfo.getId());
                            res.setEvaluatedName(classStudentInfo.getFullName());
                            res.setEvaluatedTypeId(188L);
                            res.setEvaluatorTypeId(188L);
                            res.setClassCode(classStudentInfo.getTclass().getCode());
                            res.setCourseCode(classStudentInfo.getTclass().getCourse().getCode());
                            res.setCourseTitle(classStudentInfo.getTclass().getCourse().getTitleFa());
                            res.setTeacherName(classStudentInfo.getTclass().getTeacher());
                            res.setClassStartDate(classStudentInfo.getTclass().getStartDate());
                            res.setClassEndDate(classStudentInfo.getTclass().getEndDate());
                            res.setClassDuration(classStudentInfo.getTclass().getHDuration());
                            res.setClassYear(classStudentInfo.getTclass().getStartDate().substring(0,4));
                            final Optional<Personnel> pByID1 = personnelDAO.findById(classStudentInfo.getTclass().getSupervisor());
                            final Optional<Personnel> pByID2 = personnelDAO.findById(classStudentInfo.getTclass().getPlanner());
                            Personnel personnel1 = null;
                            Personnel personnel2 = null;
                            if(pByID1.isPresent())
                                personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                            if(pByID2.isPresent())
                                personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                            if(personnel1 != null)
                                res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                            if(personnel2 != null)
                                res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                            res.setEvaluationLevel(156L);
                            res.setQuestionnarieType(230L);
                            res.setHasWarning("alarm");
                            result.add(res);
                        }
                    }
            }
        }

        final Optional<Personnel> pById = personnelDAO.findById(personnelId);
        final Personnel personnel = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        List<Evaluation> behavioralResultCoWorker = evaluationDAO.findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                personnelId,
                189L,
                156L,
                230L);

        if(behavioralResultCoWorker != null && behavioralResultCoWorker.size() >0){
            for (Evaluation evaluation : behavioralResultCoWorker) {
                EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                TclassDTO.Info tclass = modelMapper.map(tclassService.getTClass(evaluation.getClassId()),TclassDTO.Info.class);
                Optional<ClassStudent> cById = classStudentDAO.findById(evaluation.getEvaluatedId());
                ClassStudent classStudent = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                res.setClassId(tclass.getId());
                res.setEvaluatorId(personnelId);
                res.setEvaluatorName(personnel.getFirstName() + " " + personnel.getLastName());
                res.setEvaluatedId(evaluation.getEvaluatedId());
                res.setEvaluatedName(classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
                res.setEvaluatedTypeId(evaluation.getEvaluatedTypeId());
                res.setEvaluatorTypeId(evaluation.getEvaluatorTypeId());
                res.setClassCode(tclass.getCode());
                res.setCourseCode(tclass.getCourse().getCode());
                res.setCourseTitle(tclass.getCourse().getTitleFa());
                res.setTeacherName(tclass.getTeacher());
                res.setClassStartDate(tclass.getStartDate());
                res.setClassEndDate(tclass.getEndDate());
                res.setClassDuration(tclass.getHDuration());
                res.setClassYear(tclass.getStartDate().substring(0,4));
                final Optional<Personnel> pByID1 = personnelDAO.findById(tclass.getSupervisor());
                final Optional<Personnel> pByID2 = personnelDAO.findById(tclass.getPlanner());
                Personnel personnel1 = null;
                Personnel personnel2 = null;
                if(pByID1.isPresent())
                    personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(pByID2.isPresent())
                    personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(personnel1 != null)
                    res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                if(personnel2 != null)
                    res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                res.setEvaluationLevel(156L);
                res.setQuestionnarieType(230L);
                res.setHasWarning("alarm");
                result.add(res);
            }
        }

        List<Evaluation> behavioralResultSupervisor = evaluationDAO.findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                personnelId,
                190L,
                156L,
                230L);

        if(behavioralResultSupervisor != null && behavioralResultSupervisor.size() >0){
            for (Evaluation evaluation : behavioralResultSupervisor) {
                EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                TclassDTO.Info tclass = modelMapper.map(tclassService.getTClass(evaluation.getClassId()),TclassDTO.Info.class);
                Optional<ClassStudent> cById = classStudentDAO.findById(evaluation.getEvaluatedId());
                ClassStudent classStudent = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                res.setClassId(tclass.getId());
                res.setEvaluatorId(personnelId);
                res.setEvaluatorName(personnel.getFirstName() + " " + personnel.getLastName());
                res.setEvaluatedId(evaluation.getEvaluatedId());
                res.setEvaluatedName(classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
                res.setEvaluatedTypeId(evaluation.getEvaluatedTypeId());
                res.setEvaluatorTypeId(evaluation.getEvaluatorTypeId());
                res.setClassCode(tclass.getCode());
                res.setCourseCode(tclass.getCourse().getCode());
                res.setCourseTitle(tclass.getCourse().getTitleFa());
                res.setTeacherName(tclass.getTeacher());
                res.setClassStartDate(tclass.getStartDate());
                res.setClassEndDate(tclass.getEndDate());
                res.setClassDuration(tclass.getHDuration());
                res.setClassYear(tclass.getStartDate().substring(0,4));
                final Optional<Personnel> pByID1 = personnelDAO.findById(tclass.getSupervisor());
                final Optional<Personnel> pByID2 = personnelDAO.findById(tclass.getPlanner());
                Personnel personnel1 = null;
                Personnel personnel2 = null;
                if(pByID1.isPresent())
                    personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(pByID2.isPresent())
                    personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(personnel1 != null)
                    res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                if(personnel2 != null)
                    res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                res.setEvaluationLevel(156L);
                res.setQuestionnarieType(230L);
                res.setHasWarning("alarm");
                result.add(res);
            }
        }

        List<Evaluation> behavioralResultTraining = evaluationDAO.findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
                personnelId,
                454L,
                156L,
                230L);

        if(behavioralResultTraining != null && behavioralResultTraining.size() >0){
            for (Evaluation evaluation : behavioralResultTraining) {
                EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                TclassDTO.Info tclass = modelMapper.map(tclassService.getTClass(evaluation.getClassId()),TclassDTO.Info.class);
                Optional<ClassStudent> cById = classStudentDAO.findById(evaluation.getEvaluatedId());
                ClassStudent classStudent = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                res.setClassId(tclass.getId());
                res.setEvaluatorId(personnelId);
                res.setEvaluatorName(personnel.getFirstName() + " " + personnel.getLastName());
                res.setEvaluatedId(evaluation.getEvaluatedId());
                res.setEvaluatedName(classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
                res.setEvaluatedTypeId(evaluation.getEvaluatedTypeId());
                res.setEvaluatorTypeId(evaluation.getEvaluatorTypeId());
                res.setClassCode(tclass.getCode());
                res.setCourseCode(tclass.getCourse().getCode());
                res.setCourseTitle(tclass.getCourse().getTitleFa());
                res.setTeacherName(tclass.getTeacher());
                res.setClassStartDate(tclass.getStartDate());
                res.setClassEndDate(tclass.getEndDate());
                res.setClassDuration(tclass.getHDuration());
                res.setClassYear(tclass.getStartDate().substring(0,4));
                final Optional<Personnel> pByID1 = personnelDAO.findById(tclass.getSupervisor());
                final Optional<Personnel> pByID2 = personnelDAO.findById(tclass.getPlanner());
                Personnel personnel1 = null;
                Personnel personnel2 = null;
                if(pByID1.isPresent())
                    personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(pByID2.isPresent())
                    personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(personnel1 != null)
                    res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                if(personnel2 != null)
                    res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                res.setEvaluationLevel(156L);
                res.setQuestionnarieType(230L);
                res.setHasWarning("alarm");
                result.add(res);
            }
        }

        SearchDTO.SearchRs<EvaluationDTO.EvaluationForm> finalResult = new SearchDTO.SearchRs<>();
        finalResult.setList(result);
        finalResult.setTotalCount(new Long(result.size()));
        return new ResponseEntity<>(ISC.convertToIscRs(finalResult, 0), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/teacherEvaluationForms/{teacherId}")
    public ResponseEntity<ISC<EvaluationDTO.EvaluationForm>> teacherEvaluationForms(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException, NoSuchFieldException, IllegalAccessException {
        SearchDTO.CriteriaRq  criteria1 = makeNewCriteria("teacherId", teacherId, EOperator.equals, null);
        SearchDTO.CriteriaRq  criteria2 = makeNewCriteria("evaluationStatusReactionTeacher",1, EOperator.equals, null);
        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        criteriaRqList.add(criteria1);
        criteriaRqList.add(criteria2);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null,null,EOperator.and,criteriaRqList);
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<TclassDTO.Info> evaluationResult = tclassService.search1(searchRq,TclassDTO.Info.class);

        List<EvaluationDTO.EvaluationForm> result = new ArrayList<>();
        for (TclassDTO.Info classInfo : evaluationResult.getList()) {
            if(classInfo.getEvaluationStatusReactionTeacher() != null && classInfo.getEvaluationStatusReactionTeacher().equals(1)){
                EvaluationDTO.EvaluationForm res = new EvaluationDTO.EvaluationForm();
                res.setClassId(classInfo.getId());
                res.setClassCode(classInfo.getCode());
                res.setCourseCode(classInfo.getCourse().getCode());
                res.setCourseTitle(classInfo.getCourse().getTitleFa());
                res.setTeacherName(classInfo.getTeacher());
                res.setClassStartDate(classInfo.getStartDate());
                res.setEvaluationLevel(154L);
                res.setQuestionnarieType(140L);
                res.setHasWarning("alarm");
                res.setEvaluatorName(classInfo.getTeacher());
                res.setEvaluatedName(classInfo.getCourse().getTitleFa());
                res.setEvaluatorId(classInfo.getTeacherId());
                res.setEvaluatedId(classInfo.getId());
                res.setEvaluatedTypeId(504L);
                res.setEvaluatorTypeId(187L);
                res.setClassEndDate(classInfo.getEndDate());
                res.setClassDuration(classInfo.getHDuration());
                res.setClassYear(classInfo.getStartDate().substring(0,4));
                final Optional<Personnel> pByID1 = personnelDAO.findById(classInfo.getSupervisor());
                final Optional<Personnel> pByID2 = personnelDAO.findById(classInfo.getPlanner());
                Personnel personnel1 = null;
                Personnel personnel2 = null;
                if(pByID1.isPresent())
                    personnel1 = pByID1.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(pByID2.isPresent())
                    personnel2 = pByID2.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if(personnel1 != null)
                    res.setSupervisorName(personnel1.getFirstName() +" "+personnel1.getLastName());
                if(personnel2 != null)
                    res.setPlannerName(personnel2.getFirstName() +" "+personnel2.getLastName());
                result.add(res);
            }
        }

        SearchDTO.SearchRs<EvaluationDTO.EvaluationForm> finalResult = new SearchDTO.SearchRs<>();
        finalResult.setList(result);
        finalResult.setTotalCount(new Long(result.size()));
        return new ResponseEntity<>(ISC.convertToIscRs(finalResult, 0), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/printEvaluationForm"})
    @Transactional
    public void printEvaluationForm(HttpServletResponse response, @RequestParam(value = "data") String printData) throws Exception {

        JSONObject jsonObject = new JSONObject(printData);
        Long classId = Long.parseLong(jsonObject.get("classId").toString());
        Long evaluationLevelId = Long.parseLong(jsonObject.get("evaluationLevelId").toString());
        Long questionnarieTypeId = Long.parseLong(jsonObject.get("questionnarieTypeId").toString());
        Long evaluatorId = Long.parseLong(jsonObject.get("evaluatorId").toString());
        Long evaluatorTypeId = Long.parseLong(jsonObject.get("evaluatorTypeId").toString());
        Long evaluatedId = Long.parseLong(jsonObject.get("evaluatedId").toString());
        Long evaluatedTypeId = Long.parseLong(jsonObject.get("evaluatedTypeId").toString());

        TclassDTO.Info classInfo = tclassService.get(classId);
        EvaluationDTO.Info evaluation = evaluationService.getEvaluationByData(questionnarieTypeId, classId,
                evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId);

        List<EvaluationAnswerDTO.EvaluationAnswerFullData> result = new ArrayList<>();

        if(evaluation != null) {

            for (EvaluationAnswerDTO.Info evaluationAnswerDTO : evaluation.getEvaluationAnswerList()) {
                EvaluationAnswerDTO.EvaluationAnswerFullData evaluationAnswerFullData = new EvaluationAnswerDTO.EvaluationAnswerFullData();
                evaluationAnswerFullData.setId(evaluationAnswerDTO.getId());
                evaluationAnswerFullData.setEvaluationId(evaluationAnswerDTO.getEvaluationId());
                evaluationAnswerFullData.setEvaluationQuestionId(evaluationAnswerDTO.getEvaluationQuestionId());
                evaluationAnswerFullData.setQuestionSourceId(evaluationAnswerDTO.getQuestionSourceId());
                evaluationAnswerFullData.setAnswerId(evaluationAnswerDTO.getAnswerId());
                evaluationAnswerFullData.setDescription(evaluation.getDescription());

                if (evaluationAnswerFullData.getQuestionSourceId().equals(199L)) {
                    QuestionnaireQuestion questionnaireQuestion = questionnaireQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                    if(questionnaireQuestion.getEvaluationQuestion().getDomainId().equals(54L))
                        evaluationAnswerFullData.setQuestion("امکانات: "+questionnaireQuestion.getEvaluationQuestion().getQuestion());
                    else if(questionnaireQuestion.getEvaluationQuestion().getDomainId().equals(53L) || questionnaireQuestion.getEvaluationQuestion().getDomainId().equals(1L))
                        evaluationAnswerFullData.setQuestion("مدرس: "+questionnaireQuestion.getEvaluationQuestion().getQuestion());
                    else if(questionnaireQuestion.getEvaluationQuestion().getDomainId().equals(183L))
                        evaluationAnswerFullData.setQuestion("محتوای کلاس: "+questionnaireQuestion.getEvaluationQuestion().getQuestion());
                    else
                        evaluationAnswerFullData.setQuestion(questionnaireQuestion.getEvaluationQuestion().getQuestion());
                } else if (evaluationAnswerFullData.getQuestionSourceId().equals(200L)) {
                    DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setQuestion("هدف اصلی: " + dynamicQuestion.getQuestion());
                }
                else if (evaluationAnswerFullData.getQuestionSourceId().equals(201L)) {
                    DynamicQuestion dynamicQuestion = dynamicQuestionDAO.getOne(evaluationAnswerFullData.getEvaluationQuestionId());
                    evaluationAnswerFullData.setQuestion("هدف: " + dynamicQuestion.getQuestion());
                }

                result.add(evaluationAnswerFullData);
            }
        }

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("courseCode", classInfo.getCourse().getCode());
        params.put("courseName", classInfo.getCourse().getTitleFa());
        params.put("classCode", classInfo.getCode());
        params.put("startDate", classInfo.getStartDate());
        params.put("endDate", classInfo.getEndDate());
        if(evaluation.getReturnDate() != null)
            params.put("returnDate", evaluation.getReturnDate().replace("-", "/"));
        params.put("teacher", classInfo.getTeacher());
        if(questionnarieTypeId.equals(140L)) {
            params.put("evaluationType", "واکنشی-ارزیابی مدرس از کلاس");
            params.put("evaluatorName",classInfo.getTeacher());
            params.put("evaluatedName","کلاس " + classInfo.getCourse().getTitleFa());
        }
        else if(questionnarieTypeId.equals(141L)) {
            params.put("evaluationType", "واکنشی-ارزیابی مسئول آموزش از مدرس");
            Optional<Personnel> tById = personnelDAO.findById(evaluatorId);
            if(tById.isPresent()){
                Personnel personnel = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                params.put("evaluatorName",personnel.getFirstName() + " " + personnel.getLastName());
            }
            params.put("evaluatedName",classInfo.getTeacher());
        }
        else if(questionnarieTypeId.equals(139L)) {
            params.put("evaluationType", "واکنشی-ارزیابی فراگیر از کلاس");
            Optional<ClassStudent> tById = classStudentDAO.findById(evaluatorId);
            if(tById.isPresent()){
                ClassStudent classStudent = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                params.put("evaluatorName",classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
            }
            params.put("evaluatedName","کلاس " + classInfo.getCourse().getTitleFa());
        }
        else if(questionnarieTypeId.equals(230L)) {
            params.put("evaluationType","رفتاری-ارزیابی " + jsonObject.get("audienceType").toString() + " از فراگیر");
            Optional<ClassStudent> tById = classStudentDAO.findById(evaluatedId);
            if(tById.isPresent()){
                ClassStudent classStudent = tById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                params.put("evaluatedName",classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
            }
            params.put("evaluatorName",jsonObject.get("audienceName").toString());
        }


        String data = "{" + "\"ds\": " + objectMapper.writeValueAsString(result) + "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/EvaluationForm.jasper", params, jsonDataSource, response);
    }

    @Transactional
    @GetMapping(value = "/getBehavioralEvaluationResult/{classId}")
    public EvaluationDTO.BehavioralResult getBehavioralEvaluationResult(@PathVariable Long classId) {
        Tclass tclass = tclassService.getTClass(classId);
        EvaluationDTO.BehavioralResult evaluationResult = new EvaluationDTO.BehavioralResult();

        Double[] studentGrade = new Double[tclass.getClassStudents().size()];
        Double[] supervisorGrade = new Double[tclass.getClassStudents().size()];
        Double[] trainingGrade = new Double[tclass.getClassStudents().size()];
        Double[] coWorkersGrade = new Double[tclass.getClassStudents().size()];
        String[] classStudentsName = new String[tclass.getClassStudents().size()];

        Double studentGradeMean = 0.0;
        Double supervisorGradeMean = 0.0;
        Double trainingGradeMean = 0.0;
        Double coWorkersGradeMean = 0.0;

        Integer studentGradeMeanNum = 0;
        Integer supervisorGradeMeanNum = 0;
        Integer trainingGradeMeanNum = 0;
        Integer coWorkersGradeMeanNum = 0;

        int index = 0;
        for (ClassStudent classStudent : tclass.getClassStudents()) {
            List<Evaluation> evaluations = evaluationDAO.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndStatus(
                    classId,
                    156L,
                    230L,
                    classStudent.getId(),
                    188L,
                    true);
            studentGrade[index] = 0.0 ;
            supervisorGrade[index] = 0.0;
            trainingGrade[index] = 0.0;
            coWorkersGrade[index] = 0.0;

            Integer studentGradeNum = 0 ;
            Integer supervisorGradeNum = 0;
            Integer trainingGradeNum = 0;
            Integer coWorkersGradeNum = 0;

            for (Evaluation evaluation : evaluations) {
                    double res = evaluationService.getEvaluationFormGrade(evaluation);
                    if(evaluation.getEvaluatorTypeId().equals(189L)) {
                        coWorkersGradeNum++;
                        coWorkersGradeMeanNum++;
                        coWorkersGradeMean += res;
                        coWorkersGrade[index] += res;
                    }
                    else if(evaluation.getEvaluatorTypeId().equals(190L)) {
                        supervisorGradeNum++;
                        supervisorGradeMeanNum++;
                        supervisorGradeMean += res;
                        supervisorGrade[index] += res;
                    }
                    else if(evaluation.getEvaluatorTypeId().equals(188L)) {
                        studentGradeNum++;
                        studentGradeMeanNum++;
                        studentGradeMean += res;
                        studentGrade[index] += res;
                    }
                    else if(evaluation.getEvaluatorTypeId().equals(454L)) {
                        trainingGradeNum++;
                        trainingGradeMeanNum++;
                        trainingGradeMean += res;
                        trainingGrade[index] += res;
                    }
            }
            if(!studentGradeNum.equals(new Integer(0)))
                studentGrade[index] = studentGrade[index]/studentGradeNum;
            if(!supervisorGradeNum.equals(new Integer(0)))
                supervisorGrade[index] = supervisorGrade[index]/supervisorGradeNum;
            if(!trainingGradeNum.equals(new Integer(0)))
                trainingGrade[index] = trainingGrade[index]/trainingGradeNum;
            if(!coWorkersGradeNum.equals(new Integer(0)))
                coWorkersGrade[index] = coWorkersGrade[index]/coWorkersGradeNum;
            classStudentsName[index] = classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName();
            index++;
        }

        if(!studentGradeMeanNum.equals(0))
            studentGradeMean = studentGradeMean/studentGradeMeanNum;
        if(!supervisorGradeMeanNum.equals(0))
            supervisorGradeMean = supervisorGradeMean/supervisorGradeMeanNum;
        if(!trainingGradeMeanNum.equals(0))
            trainingGradeMean = trainingGradeMean/trainingGradeMeanNum;
        if(!coWorkersGradeMeanNum.equals(0))
            coWorkersGradeMean = coWorkersGradeMean/coWorkersGradeMeanNum;


        evaluationResult.setClassStudentsName(classStudentsName);
        evaluationResult.setCoWorkersGrade(coWorkersGrade);
        evaluationResult.setStudentGrade(studentGrade);
        evaluationResult.setSupervisorGrade(supervisorGrade);
        evaluationResult.setTrainingGrade(trainingGrade);

        evaluationResult.setCoWorkersGradeMean(coWorkersGradeMean);
        evaluationResult.setTrainingGradeMean(trainingGradeMean);
        evaluationResult.setStudentGradeMean(studentGradeMean);
        evaluationResult.setSupervisorGradeMean(supervisorGradeMean);

        return evaluationResult;
    }
}
