package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GenericStatisticalIndexReportDTO;
import com.nicico.training.iservice.IGenericStatisticalIndexReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/generic_statistical_index_report")
public class GenericStatisticalIndexReportRestController {

    private final IGenericStatisticalIndexReportService genericStatisticalIndexReportService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<GenericStatisticalIndexReportDTO>> iscList(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        List<GenericStatisticalIndexReportDTO> reportDTOList = genericStatisticalIndexReportService.getQueryResult("", "", "");

        ISC.Response<GenericStatisticalIndexReportDTO> response = new ISC.Response<>();
        response.setData(reportDTOList)
                .setStartRow(0)
                .setEndRow(reportDTOList.size())
                .setTotalRows(reportDTOList.size());
        ISC<GenericStatisticalIndexReportDTO> dataISC = new ISC<>(response);
        return new ResponseEntity<>(dataISC, HttpStatus.OK);
    }

}
