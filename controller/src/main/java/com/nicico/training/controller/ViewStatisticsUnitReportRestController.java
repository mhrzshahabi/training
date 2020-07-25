package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewStatisticsUnitReportDTO;
import com.nicico.training.iservice.IViewStatisticsUnitReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ViewStatisticsUnitReport")
public class ViewStatisticsUnitReportRestController {

    private final IViewStatisticsUnitReportService iViewStatisticsUnitReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewStatisticsUnitReportDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setSortBy("id");
        return new ResponseEntity<>(ISC.convertToIscRs(iViewStatisticsUnitReportService.search(searchRq, o -> modelMapper.map(o, ViewStatisticsUnitReportDTO.Grid.class)), searchRq.getStartIndex()), HttpStatus.OK);
    }

}