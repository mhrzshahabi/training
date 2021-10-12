package com.nicico.training.controller;

import com.google.gson.Gson;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.ViewTrainingNeedAssessment;
import com.nicico.training.repository.ViewTrainingNeedAssessmentDAO;
import com.nicico.training.utility.MakeExcelOutputUtil;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/reportsToExcel")
public class ReportsToExcelFormController {

    private final ModelMapper modelMapper;
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final ViewTrainingNeedAssessmentDAO viewTrainingNeedAssessmentDAO;
    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;

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
            list.add(gson.fromJson(s, Class.forName(detailDto)));
        }
        byte[] bytes = makeExcelOutputUtil.makeOutputWithExtraHeader(list, Class.forName(detailDto), detailFields, detailHeaders, true, title, masterData);
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @RequestMapping("/export")
    public void exportExcel(@RequestParam("headers") String[] headers, @RequestParam("fieldNames") String[] fieldNames, HttpServletResponse response) throws Exception {

        byte[] bytes = makeExcelOutputUtil.makeOutput(new ArrayList<>(), RequestItem.class, fieldNames, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

//    @PostMapping("/import-data")
//    public ResponseEntity<List<Map<String, Object>>> importFromExcel(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("recordLimit") Integer recordLimit,
//            @RequestParam("fieldNames") List<String> fieldNames) throws IOException {
//
//        if (file.isEmpty()) throw new SalesException2(ErrorType.NotFound, "file", "Excel file not found.");
//
//        List<Map<String, Object>> data = excelInputUtil.getData(0, recordLimit, file.getInputStream(), fieldNames);
//        return new ResponseEntity<>(data, HttpStatus.OK);
//    }

}

