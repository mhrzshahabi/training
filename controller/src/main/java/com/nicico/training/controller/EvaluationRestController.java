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
import com.nicico.training.model.ClassStudent;
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
import org.springframework.transaction.annotation.Transactional;
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
@RequestMapping("/api/evaluation")
public class EvaluationRestController {

    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ModelMapper modelMapper;
    private final CourseService courseService;
    private final SkillService skillService;
    private final EvaluationService evaluationService;
    private final ClassStudentService classStudentService;
    private final TclassService tclassService;
    private final QuestionnaireQuestionService questionnaireQuestionService;

    //*********************************

    @Loggable
    @PostMapping(value = {"/{type}/{classId}"})
    @Transactional
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @PathVariable Long classId,
                                  @RequestParam(value = "printData") String printData) throws Exception {

        JSONObject jsonObject = new JSONObject(printData);
        Long courseId = Long.parseLong(jsonObject.get("courseId").toString());
        Long studentId = Long.parseLong(jsonObject.get("studentId").toString());
        String evaluationType = jsonObject.get("evaluationType").toString();
        String evaluationReturnDate = jsonObject.get("evaluationReturnDate").toString();
        String evaluationAudience = jsonObject.get("evaluationAudience").toString();
        String evaluationAudienceType = jsonObject.get("evaluationAudienceType").toString();


        List<QuestionnaireQuestion> teacherQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(53L);
        teacherQuestionnaireQuestion.sort(Comparator.comparing(QuestionnaireQuestion::getOrder));

        List<QuestionnaireQuestion> equipmentQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(54L);
        equipmentQuestionnaireQuestion.sort(Comparator.comparing(QuestionnaireQuestion::getOrder));

        CourseDTO.CourseGoals courseGoals = courseService.getCourseGoals(courseId);

        List<Skill> skillList = skillService.skillList(courseId);

        List<EvaluationQuestionDTO.Info> evaluationQuestion = new ArrayList<>();
        if (!evaluationType.equals("TabPane_Behavior") && !evaluationType.equals("TabPane_Learning"))
            for (QuestionnaireQuestion questionnaireQuestion : teacherQuestionnaireQuestion) {
                evaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
            }

        if (!evaluationType.equals("TabPane_Behavior") && !evaluationType.equals("TabPane_Learning"))
            for (QuestionnaireQuestion questionnaireQuestion : equipmentQuestionnaireQuestion) {
                evaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
            }

        for (Goal goal : courseGoals.getGoalSet()) {

            EvaluationQuestionDTO.Info evaluationQuestionDTO = new EvaluationQuestionDTO.Info();
            evaluationQuestionDTO.setQuestion(goal.getTitleFa());

            ParameterValueDTO.Info domain = new ParameterValueDTO.Info();
            domain.setTitle("اهداف");
            evaluationQuestionDTO.setDomain(domain);
            evaluationQuestion.add(evaluationQuestionDTO);
        }

        for (Skill skill : skillList) {

            EvaluationQuestionDTO.Info evaluationQuestionDTO = new EvaluationQuestionDTO.Info();
            evaluationQuestionDTO.setQuestion(skill.getTitleFa());

            ParameterValueDTO.Info domain = new ParameterValueDTO.Info();
            domain.setTitle("هدف کلی");
            evaluationQuestionDTO.setDomain(domain);
            evaluationQuestion.add(evaluationQuestionDTO);
        }

        TclassDTO.Info classInfo = tclassService.get(classId);

        if (evaluationReturnDate.equals("noDate")) {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(Calendar.MONTH, 1);
            evaluationReturnDate = DateUtil.convertMiToKh(formatter.format(calendar.getTime()));
        }

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("courseCode", classInfo.getCourse().getCode());
        params.put("courseName", classInfo.getCourse().getTitleFa());
        params.put("classCode", classInfo.getCode());
        params.put("startDate", classInfo.getStartDate());
        params.put("endDate", classInfo.getEndDate());
        params.put("evaluationAudience", evaluationAudience.equals("null") ? "" : "مخاطب : " + evaluationAudience);
        params.put("evaluationAudienceType", "("+evaluationAudienceType+")");
        params.put("returnDate", evaluationReturnDate.replace("-", "/"));
        params.put("evaluationType", (evaluationType.equals("TabPane_Reaction") ? "(واکنشی)" :
                evaluationType.equals("TabPane_Learning") ? "(پیش تست)" :
                        evaluationType.equals("TabPane_Behavior") ? "(رفتاری)" : "(نتایج)"));


        Set<ClassStudentDTO.AttendanceInfo> classStudent = classInfo.getClassStudentsForEvaluation(studentId);

        String data = "{" + "\"dsStudent\": " + objectMapper.writeValueAsString(classStudent) + "," +
                "\"dsTeacherQuestion\": " + objectMapper.writeValueAsString(evaluationQuestion) + "}";


        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EvaluationReaction.jasper", params, jsonDataSource, response);
    }

    //*********************************

    // ------------------------------

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
    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<EvaluationDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(evaluationService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{questionnaireTypeId}/{classId}/{evaluatorId}/{evaluatorTypeId}/{evaluatedId}/{evaluatedTypeId}/{evaluationLevelId}")
    public ResponseEntity<EvaluationDTO.Info> getEvaluationByData(@PathVariable Long questionnaireTypeId, @PathVariable Long classId, @PathVariable Long evaluatorId, @PathVariable Long evaluatorTypeId, @PathVariable Long evaluatedId, @PathVariable Long evaluatedTypeId, @PathVariable Long evaluationLevelId) {
        return new ResponseEntity<>(evaluationService.getEvaluationByData(questionnaireTypeId, classId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId, evaluationLevelId), HttpStatus.OK);
    }

    //-------------------------------

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
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
