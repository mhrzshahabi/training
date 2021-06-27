package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.iservice.INeedsAssessmentReportsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RestController
@RequestMapping("/anonymous/bpms")
@RequiredArgsConstructor
public class BpmsController {

    private final INeedsAssessmentReportsService needsAssessmentReportsService;

    @GetMapping
    public ResponseEntity<ISC<NeedsAssessmentReportsDTO.ReportInfo>> fullList(HttpServletRequest iscRq,
                                                            @RequestParam String postCode,
                                                            @RequestParam(required = false) String nationalCode,
                                                            @RequestParam(required = false) String personnelNumber,
                                                            HttpServletResponse response) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo>  list = needsAssessmentReportsService.searchForBpms(searchRq, postCode, "Post", nationalCode,personnelNumber);
            return new ResponseEntity<>(ISC.convertToIscRs(list, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
