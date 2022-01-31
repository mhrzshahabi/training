package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.AttendancePerformanceReportDTO;
import com.nicico.training.iservice.IAttendancePerformanceReportService;
import com.nicico.training.service.AttendancePerformanceReportService;
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
@RequestMapping("/api/attendancePerformance")
public class AttendancePerformanceReportRestController {

    private final IAttendancePerformanceReportService iAttendancePerformanceReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/list/{reportParameter}")
    public ResponseEntity<AttendancePerformanceReportDTO.AttendancePerformanceReportSpecRs> list(HttpServletResponse response, @PathVariable() String reportParameter) throws IOException {

        List<AttendancePerformanceReportDTO> list = new ArrayList<>();
        list = iAttendancePerformanceReportService.attendancePerformanceList(reportParameter);

        final AttendancePerformanceReportDTO.SpecRs specResponse = new AttendancePerformanceReportDTO.SpecRs();
        final AttendancePerformanceReportDTO.AttendancePerformanceReportSpecRs specRs = new AttendancePerformanceReportDTO.AttendancePerformanceReportSpecRs();

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
