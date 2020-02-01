package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
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
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluation")
public class EvaluationRestController {

    private final OperationalUnitService operationalUnitService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ModelMapper modelMapper;
    private final CourseService courseService;
    private final SkillService skillService;
    private final EvaluationService evaluationService;


    private final TclassService tclassService;
    private final QuestionnaireQuestionService questionnaireQuestionService;

    //*********************************

    @Loggable
    @PostMapping(value = {"/{type}/{classId}"})
    public void printWithCriteria(HttpServletResponse response, @PathVariable String type,
                                  @PathVariable Long classId, @RequestParam(value = "printData") String printData) throws Exception {

        JSONObject jsonObject = new JSONObject(printData);
        Long courseId = Long.parseLong(jsonObject.get("courseId").toString());
        Long studentId = Long.parseLong(jsonObject.get("studentId").toString());
        String evaluationType = jsonObject.get("evaluationType").toString();
        String evaluationReturnDate = jsonObject.get("evaluationReturnDate").toString();
        String evaluationAudience = jsonObject.get("evaluationAudience").toString();


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


//    @Loggable
//    @GetMapping(value = "/iscList")
//    public ResponseEntity<TotalResponse<EvaluationDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
//        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
//        return new ResponseEntity<>(evaluationService.search(nicicoCriteria), HttpStatus.OK);
//    }
//
//    @Loggable
//    @PostMapping
//    public ResponseEntity<EvaluationDTO.Info> create(@RequestBody Object rq) {
//        EvaluationDTO.Create create = modelMapper.map(rq, EvaluationDTO.Create.class);
//        return new ResponseEntity<>(evaluationService.create(create), HttpStatus.OK);
//    }
//
//    @Loggable
//    @PutMapping("/{id}")
//    public ResponseEntity<EvaluationDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
//        EvaluationDTO.Update update = modelMapper.map(rq, EvaluationDTO.Update.class);
//        return new ResponseEntity<>(evaluationService.update(id, update), HttpStatus.OK);
//    }
//
//    @Loggable
//    @DeleteMapping("/{id}")
//    public ResponseEntity delete(@PathVariable Long id) {
//        try {
//            return new ResponseEntity<>(evaluationService.delete(id), HttpStatus.OK);
//        } catch (Exception ex) {
//            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
//        }
//    }

}
