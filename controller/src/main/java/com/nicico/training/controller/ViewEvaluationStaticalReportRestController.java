package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEvaluationStaticalReportDTO;
import com.nicico.training.service.ViewEvaluationStaticalReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-evaluation-statical-report")
public class ViewEvaluationStaticalReportRestController {

    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewEvaluationStaticalReportDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if(searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null){
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                if(criterion.getValue().get(0).equals("true"))
                    criterion.setValue(true);
                if(criterion.getValue().get(0).equals("false"))
                    criterion.setValue(false);
            }
        }
        SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> searchRs = viewEvaluationStaticalReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
