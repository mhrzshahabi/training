package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.MonthlyStatisticalReportDTO;
import com.nicico.training.iservice.IMonthlyStatisticalReportService;
import com.nicico.training.service.MonthlyStatisticalReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/monthlyStatistical")
public class MonthlyStatisticalReportRestController {

    private final IMonthlyStatisticalReportService iMonthlyStatisticalReportService;

    //*********************************

    @Loggable
    @GetMapping(value = "/list/{reportParameter}")
    public ResponseEntity<MonthlyStatisticalReportDTO.MonthlyStatisticalSpecRs> list(HttpServletResponse response, @PathVariable() String reportParameter) throws IOException {

        List<MonthlyStatisticalReportDTO> list = new ArrayList<>();
        list = iMonthlyStatisticalReportService.monthlyStatisticalList(reportParameter);

        final MonthlyStatisticalReportDTO.SpecRs specResponse = new MonthlyStatisticalReportDTO.SpecRs();
        final MonthlyStatisticalReportDTO.MonthlyStatisticalSpecRs specRs = new MonthlyStatisticalReportDTO.MonthlyStatisticalSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************
}
