/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
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

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/job/")
public class JobRestController {

    private final JobService jobService;
    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;


    @GetMapping("list")
    public ResponseEntity<List<JobDTO.Info>> list() {
        return new ResponseEntity<>(jobService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<TotalResponse<JobDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(jobService.search(nicicoCriteria), HttpStatus.OK);
    }

//    @Loggable
//    @PostMapping(value = {"/printWithCriteria/{type}"})
//    public void printWithCriteria(HttpServletResponse response,
//                                  @PathVariable String type,
//                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
//
//        final SearchDTO.CriteriaRq criteriaRq;
//        final SearchDTO.SearchRq searchRq;
//        if (criteriaStr.equalsIgnoreCase("{}")) {
//            searchRq = new SearchDTO.SearchRq();
//        } else {
//            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
//            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
//        }
//
//        final SearchDTO.SearchRs<EducationOrientationDTO.Info> searchRs = educationOrientationService.search(searchRq);
//
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", DateUtil.todayDate());
//
//        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/EducationOrientationByCriteria.jasper", params, jsonDataSource, response);
//    }


//    @Loggable
//    @GetMapping(value = {"/print/{type}"})
//    public void printWithCriteria(HttpServletResponse response,
//                                  @PathVariable String type,
//                                  @RequestParam(value = "CriteriaStr", required = false) String criteriaStr) throws Exception {
//
//        Map<String, Object> params = new HashMap<>();
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/Course.jasper", params, response);
////
////        final SearchDTO.CriteriaRq criteriaRq;
////        final SearchDTO.SearchRq searchRq;
////        if (criteriaStr== null || criteriaStr.equalsIgnoreCase("{}")) {
////            searchRq = new SearchDTO.SearchRq();
////        } else {
////            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
////            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
////        }
////
////        final SearchDTO.SearchRs<CourseDTO.Info> searchRs = courseService.search(searchRq);
////
////        final Map<String, Object> params = new HashMap<>();
////        params.put("todayDate", dateUtil.todayDate());
////
////        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
////        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
////
////        params.put(ConstantVARs.REPORT_TYPE, type);
////        reportUtil.export("/reports/CourseByCriteria.jasper", params, jsonDataSource, response);
//    }
}
