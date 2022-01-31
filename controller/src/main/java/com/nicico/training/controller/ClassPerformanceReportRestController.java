package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ClassPerformanceReportDTO;
import com.nicico.training.iservice.IClassPerformanceReportService;
import com.nicico.training.service.ClassPerformanceReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/classPerformance")
public class ClassPerformanceReportRestController {

    private final IClassPerformanceReportService iClassPerformanceReportService;

    //*********************************

    @Loggable
    @GetMapping(value = "/list/{reportParameter}")
    public ResponseEntity<ClassPerformanceReportDTO.ClassPerformanceReportSpecRs> list(HttpServletResponse response, @PathVariable() String reportParameter) throws IOException {

        List<ClassPerformanceReportDTO> list = new ArrayList<>();
        list = iClassPerformanceReportService.classPerformanceList(reportParameter);

        final ClassPerformanceReportDTO.SpecRs specResponse = new ClassPerformanceReportDTO.SpecRs();
        final ClassPerformanceReportDTO.ClassPerformanceReportSpecRs specRs = new ClassPerformanceReportDTO.ClassPerformanceReportSpecRs();

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
