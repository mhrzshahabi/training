package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AttendanceAuditDTO;
import com.nicico.training.iservice.IAttendanceAuditService;
import com.nicico.training.mapper.attendance.AttendanceAuditBeanMapper;
import com.nicico.training.model.AttendanceAudit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.attendance.AuditAttendanceDto;

import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/attendance-audit")
public class AttendanceAuditRestController {
    private final IAttendanceAuditService iAttendanceAuditService;
    private final AttendanceAuditBeanMapper attendanceAuditBeanMapper;

    @Loggable
    @PostMapping(value = "/change-list")
    public ResponseEntity<ISC<AttendanceAuditDTO.Info>> changeList(@RequestBody AuditAttendanceDto auditAttendanceDto) throws IOException {
        try {
            List<AttendanceAudit> attendanceAuditList = iAttendanceAuditService.getChangeList(auditAttendanceDto.getAttendanceIdes(),auditAttendanceDto.getSessionTime());
            List<AttendanceAuditDTO.Info> dtoList = attendanceAuditBeanMapper.toAttendanceAuditInfoDTOList(attendanceAuditList);
            SearchDTO.SearchRs<AttendanceAuditDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(dtoList);
            searchRs.setTotalCount((long) attendanceAuditList.size());

            ISC<AttendanceAuditDTO.Info> auditISC = ISC.convertToIscRs(searchRs, 0);
            return new ResponseEntity<>(auditISC, HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        }

    }
}
