package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.service.NeedsAssessmentReportsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment-reports")
public class NeedsAssessmentReportsRestController {

    private final NeedsAssessmentReportsService needsAssessmentReportsService;

    @GetMapping(value = "/courses-for-post/{postCode}")
    public ResponseEntity<ISC<NeedsAssessmentReportsDTO.NeedsCourses>> fullList(HttpServletRequest iscRq,
                                                                                @PathVariable String postCode) throws IOException {
        postCode = postCode.replace('.', '/');
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.NeedsCourses> searchRs = needsAssessmentReportsService.search(searchRq, postCode);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
