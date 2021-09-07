package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.dto.LoginLogDTO;
import com.nicico.training.dto.ViewAssigneeNeedsAssessmentsReportDTO;
import com.nicico.training.iservice.ILoginLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/log/")
public class LogController {
    private final ILoginLogService iLoginLogService;

    @Loggable
    @GetMapping(value = "/user/list")
    public ResponseEntity<ISC<LoginLogDTO>> loginLog(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<LoginLogDTO> result = iLoginLogService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
