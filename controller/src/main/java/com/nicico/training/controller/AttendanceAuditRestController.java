package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IAttendanceAuditService;
import com.nicico.training.model.AttendanceAudit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/attendance-audit")
public class AttendanceAuditRestController {
    private final IAttendanceAuditService iAttendanceAuditService;

    @Loggable
    @GetMapping(value = "/change-list/{attendanceId}")
    public ResponseEntity<ISC<AttendanceAudit>> changeList(@PathVariable String attendanceId) throws IOException {
        try {
            Long attendanceLongId = Long.parseLong(attendanceId);
            List<AttendanceAudit> attendanceAuditList = iAttendanceAuditService.getChangeList(attendanceLongId);
            SearchDTO.SearchRs<AttendanceAudit> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(attendanceAuditList);
            searchRs.setTotalCount((long) attendanceAuditList.size());

            ISC<AttendanceAudit> auditISC = ISC.convertToIscRs(searchRs, 0);
            return new ResponseEntity<>(auditISC, HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        }

    }
}
