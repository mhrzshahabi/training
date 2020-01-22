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
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.service.EvaluationService;
import com.nicico.training.service.OperationalUnitService;
import com.nicico.training.service.QuestionnaireQuestionService;
import com.nicico.training.service.TclassService;
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


    private final TclassService tclassService;
    private final QuestionnaireQuestionService questionnaireQuestionService;

    //*********************************

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}/{classId}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr, @PathVariable Long classId) throws Exception {

//        final SearchDTO.SearchRq searchRq_employmentHistory = new SearchDTO.SearchRq();
//        final SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchRs_employmentHistory = employmentHistoryService.search(searchRq_employmentHistory, Long.valueOf(id));

//        final SearchDTO.SearchRq searchRq_Tclass = new SearchDTO.SearchRq();
//        final SearchDTO.SearchRs<TclassDTO.Info> searchRs_Tclass = iTclassService.searchById(searchRq_Tclass, classId);

        List<QuestionnaireQuestion> teacherQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(53L);

        List<QuestionnaireQuestion> equipmentQuestionnaireQuestion = questionnaireQuestionService.getEvaluationQuestion(54L);

        List<EvaluationQuestionDTO.Info> teacherEvaluationQuestion = new ArrayList<>();
        for (QuestionnaireQuestion questionnaireQuestion : teacherQuestionnaireQuestion) {
            teacherEvaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
        }

        List<EvaluationQuestionDTO.Info> equipmentEvaluationQuestion = new ArrayList<>();
        for (QuestionnaireQuestion questionnaireQuestion : equipmentQuestionnaireQuestion) {
            equipmentEvaluationQuestion.add(modelMapper.map(questionnaireQuestion.getEvaluationQuestion(), EvaluationQuestionDTO.Info.class));
        }


//        List<QuestionnaireQuestionDTO.Info> qqq = modelMapper.map(teacherQuestionnaireQuestion, new TypeToken<List<QuestionnaireQuestionDTO.Info>>() {
//        }.getType());


        TclassDTO.Info classInfo = tclassService.get(classId);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("courseCode", classInfo.getCourse().getCode());
        params.put("courseName", classInfo.getCourse().getTitleFa());
        params.put("classCode", classInfo.getCode());
        params.put("startDate", classInfo.getStartDate());
        params.put("endDate", classInfo.getEndDate());

        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        //final SearchDTO.SearchRs<OperationalUnitDTO.Info> searchRs = evaluationService.search(searchRq);
        final SearchDTO.SearchRs<OperationalUnitDTO.Info> searchRs = operationalUnitService.search(searchRq);


//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";


        String data = "{" + "\"dsStudent\": " + objectMapper.writeValueAsString(classInfo.getClassStudents()) + "," +
                "\"dsTeacherQuestion\": " + objectMapper.writeValueAsString(teacherEvaluationQuestion) + "," +
                "\"dsEquipmentQuestion\": " + objectMapper.writeValueAsString(equipmentEvaluationQuestion) + "}";


        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/EvaluationReaction.jasper", params, jsonDataSource, response);
    }

    //*********************************

}
