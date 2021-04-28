package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.model.ViewPost;
import com.nicico.training.model.ViewTrainingNeedAssessment;
import com.nicico.training.model.ViewTrainingPostReport;
import com.nicico.training.repository.ViewPostDAO;
import com.nicico.training.repository.ViewTrainingNeedAssessmentDAO;
import com.nicico.training.repository.ViewTrainingPostDAO;
import com.nicico.training.repository.ViewTrainingPostReportDAO;
import com.nicico.training.service.ExportToFileService;
import com.nicico.training.service.ViewTrainingPostReportService;
import com.nicico.training.utility.MakeExcelOutputUtil;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/reportsToExcel")
public class ReportsToExcelFormController {

    private final ModelMapper modelMapper;
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final ViewTrainingPostReportDAO viewTrainingPostReportDAO;
    private final ViewTrainingNeedAssessmentDAO viewTrainingNeedAssessmentDAO;
    private final ViewTrainingPostReportService viewTrainingPostReportService;
    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;

    @PostMapping(value = {"/areaNeedAssessment"})
    public void areaNeedAssessmentExcel(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");

        String[] complexes = Objects.requireNonNull(criteria.getFirst("complex")).split(",");
        String[] assistances = Objects.requireNonNull(criteria.getFirst("assistance")).split(",");
        String[] affairs = Objects.requireNonNull(criteria.getFirst("affairs")).split(",");
        String[] sections = Objects.requireNonNull(criteria.getFirst("section")).split(",");
        String[] units = Objects.requireNonNull(criteria.getFirst("unit")).split(",");


        ////////////////

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//
        SearchDTO.CriteriaRq criteriaRq;
//        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
//            criteria = "[" + criteria + "]";
//            criteriaRq = new SearchDTO.CriteriaRq();
//            criteriaRq.setOperator(EOperator.valueOf(operator)).setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
//            }));
//            request.setCriteria(criteriaRq);
//        }
//
//        if (StringUtils.isNotEmpty(sortBy)) {
//            request.setSortBy(sortBy);
//        }
//
//        request.setStartIndex(startRow).setCount(endRow - startRow);
//
//
        SearchDTO.CriteriaRq tmpCriteria = null;
        List<SearchDTO.CriteriaRq> listCriteria = new ArrayList<>();
//
        SearchDTO.CriteriaRq result = new SearchDTO.CriteriaRq();
        result.setOperator(EOperator.and);
//
//        if (request.getCriteria() != null) {
//            listCriteria.add(request.getCriteria());
//        }
//
        tmpCriteria = new SearchDTO.CriteriaRq();
//
        ArrayList<SearchDTO.CriteriaRq> criteriaRqs = new ArrayList<>();
//
        if (complexes.length != 0) {
            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setOperator(EOperator.inSet);
            criteriaRq1.setFieldName("mojtameTitle");
            criteriaRq1.setValue(complexes);
            criteriaRqs.add(criteriaRq1);
        }

        if (assistances.length != 0) {
            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setOperator(EOperator.inSet);
            criteriaRq1.setFieldName("assistance");
            criteriaRq1.setValue(assistances);
            criteriaRqs.add(criteriaRq1);
        }

        if (affairs.length != 0) {
            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setOperator(EOperator.inSet);
            criteriaRq1.setFieldName("affairs");
            criteriaRq1.setValue(affairs);
            criteriaRqs.add(criteriaRq1);
        }

        if (sections.length != 0) {
            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setOperator(EOperator.inSet);
            criteriaRq1.setFieldName("section");
            criteriaRq1.setValue(sections);
            criteriaRqs.add(criteriaRq1);
        }

        if (units.length != 0) {
            SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
            criteriaRq1.setOperator(EOperator.inSet);
            criteriaRq1.setFieldName("unit");
            criteriaRq1.setValue(units);
            criteriaRqs.add(criteriaRq1);
        }

        SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.equals);
        criteriaRq1.setFieldName("competenceCount");
        criteriaRq1.setValue(0);
        criteriaRqs.add(criteriaRq1);


        tmpCriteria.setCriteria(criteriaRqs);
        tmpCriteria.setOperator(EOperator.and);

        listCriteria.add(tmpCriteria);

        result.setCriteria(listCriteria);

        request.setCriteria(result);
//
//        SearchDTO.SearchRs<QuestionBankTestQuestionDTO.InfoUsed> response = questionBankTestQuestionService.search1(request);
//
//        final QuestionBankTestQuestionDTO.SpecRsUsed specResponse = new QuestionBankTestQuestionDTO.SpecRsUsed();
//        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());
//
//        final QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRsUsed specRs = new QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRsUsed();
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
        ///////////////

        List<ViewTrainingPostReport> viewTrainingPosts = viewTrainingPostReportDAO.findAllByAreaAndCompetenceCount(0, complexes, assistances, affairs, sections, units);
        List<ViewTrainingPostDTO.Report> trainingPostData = viewTrainingPosts.stream().map(item -> modelMapper.map(item, ViewTrainingPostDTO.Report.class)).collect(Collectors.toList());
        resp.addAll(trainingPostData);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewTrainingPostDTO.Report.class, fields, headers, true, "");
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

        List<ViewNeedAssessmentInRangeDTO.Info> viewTrainingNeedAssessments = iViewNeedAssessmentInRangeTimeService.getList(start, end);

        resp.addAll(viewTrainingNeedAssessments);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewNeedAssessmentInRangeDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @PostMapping(value = {"/masterDetail"})
    public void masterDetail(HttpServletResponse response, @RequestParam MultiValueMap<String, Object> req) throws Exception {

        Gson gson = new Gson();
        HashMap masterData = gson.fromJson((String) Objects.requireNonNull(req.getFirst("masterData")), new TypeToken<HashMap<String, String>>() {
        }.getType());
        String[] detailFields = ((String) Objects.requireNonNull(req.getFirst("detailFields"))).split(",");
        String[] detailHeaders = ((String) Objects.requireNonNull(req.getFirst("detailHeaders"))).split(",");
        String detailDto = ((String) Objects.requireNonNull(req.getFirst("detailDto")));
        String title = ((String) Objects.requireNonNull(req.getFirst("title")));
        List<Object> resp = new ArrayList<>(gson.fromJson((String) Objects.requireNonNull(req.getFirst("detailData")), new TypeToken<List<Object>>() {
        }.getType()));
        List list = new ArrayList();
        for (Object obj : resp) {
            String s = gson.toJson(obj);
            list.add(gson.fromJson(s,Class.forName(detailDto)));
        }
        byte[] bytes = makeExcelOutputUtil.makeOutputWithExtraHeader(list, Class.forName(detailDto), detailFields, detailHeaders, true, title, masterData);
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

}

