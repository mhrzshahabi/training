/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.JobService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/job/")
public class JobRestController {

    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;
    private final JobService jobService;

    @GetMapping("list")
    public ResponseEntity<List<JobDTO.Info>> list() {
        return new ResponseEntity<>(jobService.list(), HttpStatus.OK);
    }

//    @GetMapping(value = "iscList")
//    public ResponseEntity<TotalResponse<JobDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
//        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
//        return new ResponseEntity<>(jobService.search(nicicoCriteria), HttpStatus.OK);
//    }

    @GetMapping(value = "iscList")
    public ResponseEntity<ISC<JobDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<JobDTO.Info> searchRs = jobService.searchWithoutPermission(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
