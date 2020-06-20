package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.AttendanceReportDTO;
import com.nicico.training.service.AttendanceReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/attendanceReport")
public class AttendanceReportController {
    private final AttendanceReportService attendanceReportService;

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<AttendanceReportDTO.AttendanceReportDTOSpecRs> list(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {

        List<AttendanceReportDTO.Info> response = attendanceReportService.getAttendanceList(startDate, endDate);

        final AttendanceReportDTO.SpecRs specResponse = new AttendanceReportDTO.SpecRs();
        final AttendanceReportDTO.AttendanceReportDTOSpecRs specRs = new AttendanceReportDTO.AttendanceReportDTOSpecRs();
        specResponse.setData(response)
                .setStartRow(0)
                .setEndRow(response.size())
                .setTotalRows(response.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
