package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPersonnelTrainingStatusReportDTO;
import com.nicico.training.iservice.IViewPersonnelTrainingStatusReportService;
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
@RequestMapping(value = "/api/view-personnel-training-status-report")
public class ViewPersonnelTrainingStatusReportRestController {
    private final IViewPersonnelTrainingStatusReportService viewPersonnelTrainingStatusReportService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewPersonnelTrainingStatusReportDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setSortBy("id");
        SearchDTO.SearchRs<ViewPersonnelTrainingStatusReportDTO.Info> searchRs = viewPersonnelTrainingStatusReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
