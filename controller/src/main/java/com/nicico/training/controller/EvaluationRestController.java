package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.EvaluationQuestion;
import com.nicico.training.model.Goal;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
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


    private final TclassService tclassService;
    private final QuestionnaireQuestionService questionnaireQuestionService;

    //*********************************

    @Loggable
    @PostMapping(value = {"/{type}/{classId}"})
    public void printWithCriteria(HttpServletResponse response, @PathVariable String type, @PathVariable Long classId) throws Exception {

        List<QuestionnaireQuestion> teacherQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(53L);
        teacherQuestionnaireQuestion.sort(Comparator.comparing(QuestionnaireQuestion::getOrder));

        List<QuestionnaireQuestion> equipmentQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(54L);
        equipmentQuestionnaireQuestion.sort(Comparator.comparing(QuestionnaireQuestion::getOrder));

        CourseDTO.CourseGoals courseGoals = courseService.getCourseGoals(1L);

        List<EvaluationQuestionDTO.Info> evaluationQuestion = new ArrayList<>();
        for (QuestionnaireQuestion questionnaireQuestion : teacherQuestionnaireQuestion) {
            evaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
        }

        for (QuestionnaireQuestion questionnaireQuestion : equipmentQuestionnaireQuestion) {
            evaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
        }

        List<GoalDTO.Info> goals = new ArrayList<>();
        for (Goal goal : courseGoals.getGoalSet()) {
            goals.add(modelMapper.map(goal, GoalDTO.Info.class));

            EvaluationQuestionDTO.Info evaluationQuestionDTO = new EvaluationQuestionDTO.Info();
            evaluationQuestionDTO.setQuestion(goal.getTitleFa());

            ParameterValueDTO.Info domain = new ParameterValueDTO.Info();
            domain.setTitle("اهداف");
            evaluationQuestionDTO.setDomain(domain);
            evaluationQuestion.add(evaluationQuestionDTO);
        }

        TclassDTO.Info classInfo = tclassService.get(classId);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("courseCode", classInfo.getCourse().getCode());
        params.put("courseName", classInfo.getCourse().getTitleFa());
        params.put("classCode", classInfo.getCode());
        params.put("startDate", classInfo.getStartDate());
        params.put("endDate", classInfo.getEndDate());

        String data = "{" + "\"dsStudent\": " + objectMapper.writeValueAsString(classInfo.getClassStudents()) + "," +
                "\"dsTeacherQuestion\": " + objectMapper.writeValueAsString(evaluationQuestion) + "}";


        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EvaluationReaction.jasper", params, jsonDataSource, response);
    }

    //*********************************

}
