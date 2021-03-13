package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.TrainingPostDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.model.ViewPost;
import com.nicico.training.model.ViewTrainingNeedAssessment;
import com.nicico.training.model.ViewTrainingPost;
import com.nicico.training.repository.ViewPostDAO;
import com.nicico.training.repository.ViewTrainingNeedAssessmentDAO;
import com.nicico.training.repository.ViewTrainingPostDAO;
import com.nicico.training.service.ExportToFileService;
import com.nicico.training.utility.MakeExcelOutputUtil;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/reportsToExcel")
public class ReportsToExcelFormController {

    private final ModelMapper modelMapper;
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final ViewTrainingPostDAO viewTrainingPostDAO;
    private final ViewTrainingNeedAssessmentDAO viewTrainingNeedAssessmentDAO;
    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;

    @PostMapping(value = {"/areaNeedAssessment"})
    public void areaNeedAssessmentExcel(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");
        String area = criteria.get("area").get(0);

        List<ViewTrainingPost> viewTrainingPosts = viewTrainingPostDAO.findAllByAreaAndCompetenceCount(0, area);

        List<TrainingPostDTO.Info> trainingPostData = viewTrainingPosts.stream().map(item -> modelMapper.map(item, TrainingPostDTO.Info.class)).collect(Collectors.toList());
        resp.addAll(trainingPostData);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, TrainingPostDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @PostMapping(value = {"/courseNeedAssessment"})
    public void courseNeedAssessmentExcel(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");
        Long categoryId = Long.valueOf(criteria.get("category").get(0));

        List<ViewTrainingNeedAssessment> viewTrainingNeedAssessments = viewTrainingNeedAssessmentDAO.findAllByCategoryId(categoryId);

        List<ViewTrainingNeedAssessmentDTO.Info> trainingNeedAssessmentData = viewTrainingNeedAssessments.stream().map(item -> modelMapper.map(item, ViewTrainingNeedAssessmentDTO.Info.class)).collect(Collectors.toList());
        resp.addAll(trainingNeedAssessmentData);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewTrainingNeedAssessmentDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }
    @PostMapping(value = {"/needsAssessmentsPerformed"})
    public void needsAssessmentsPerformed(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");
        String start = String.valueOf(criteria.get("start").get(0));
        String end = String.valueOf(criteria.get("end").get(0));

        List<ViewNeedAssessmentInRangeDTO.Info> viewTrainingNeedAssessments = iViewNeedAssessmentInRangeTimeService.getList(start,end);

        resp.addAll(viewTrainingNeedAssessments);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewNeedAssessmentInRangeDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @PostMapping(value = {"/masterDetail"})
    public void masterDetail(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

    }

}

