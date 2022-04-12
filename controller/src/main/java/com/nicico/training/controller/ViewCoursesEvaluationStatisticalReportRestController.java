package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesEvaluationStatisticalReportDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.iservice.IViewCoursesEvaluationStatisticalReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view_courses_evaluation_statistical_report")
public class ViewCoursesEvaluationStatisticalReportRestController {

    private final IViewCoursesEvaluationStatisticalReportService viewCoursesEvaluationStatisticalReportService;
    private final ITclassService tclassService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewCoursesEvaluationStatisticalReportDTO.StatisticalData>> iscList(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewCoursesEvaluationStatisticalReportDTO> searchRs = viewCoursesEvaluationStatisticalReportService.search(searchRq);
        List<ViewCoursesEvaluationStatisticalReportDTO> data = ISC.convertToIscRs(searchRs, searchRq.getStartIndex()).getResponse().getData();

        List<ViewCoursesEvaluationStatisticalReportDTO.StatisticalData> list = new ArrayList<>();
        ViewCoursesEvaluationStatisticalReportDTO.StatisticalData statisticalData = new ViewCoursesEvaluationStatisticalReportDTO.StatisticalData();
        statisticalData.setTotalClasses(0);
        statisticalData.setNumberOfReaction(0);
        statisticalData.setNumberOfLearning(0);
        statisticalData.setNumberOfBehavioral(0);
        statisticalData.setNumberOfResult(0);
        statisticalData.setNumberOfEffective(0);
        statisticalData.setNumberOfInEffective(0);

        data.forEach(item -> {
            Map<String, Object> map = tclassService.getEvaluationStatisticalReport(item.getClassId());
            statisticalData.setTotalClasses(statisticalData.getTotalClasses()+1);
            if (map.get("hasReactionEval").equals(true))
                statisticalData.setNumberOfReaction(statisticalData.getNumberOfReaction()+1);
            if (map.get("hasLearningEval").equals(true))
                statisticalData.setNumberOfLearning(statisticalData.getNumberOfLearning()+1);
            if (map.get("hasBehavioralEval").equals(true))
                statisticalData.setNumberOfBehavioral(statisticalData.getNumberOfBehavioral()+1);
            if (map.get("hasResultEval").equals(true))
                statisticalData.setNumberOfResult(statisticalData.getNumberOfResult()+1);
            if (map.get("effective").equals(true))
                statisticalData.setNumberOfEffective(statisticalData.getNumberOfEffective()+1);
            if (map.get("inEffective").equals(true))
                statisticalData.setNumberOfInEffective(statisticalData.getNumberOfInEffective()+1);
        });

        ISC.Response<ViewCoursesEvaluationStatisticalReportDTO.StatisticalData> response = new ISC.Response<>();
        list.add(statisticalData);
        response.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        ISC<ViewCoursesEvaluationStatisticalReportDTO.StatisticalData> dataISC = new ISC<>(response);
        return new ResponseEntity<>(dataISC, HttpStatus.OK);
    }

}
