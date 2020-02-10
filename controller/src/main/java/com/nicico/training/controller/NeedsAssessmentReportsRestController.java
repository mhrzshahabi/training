package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.service.NeedsAssessmentReportsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment-reports")
public class NeedsAssessmentReportsRestController {

    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;

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

    @Loggable
    @PostMapping(value = {"/print-course-list-for-a-personnel/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "essentialRecords") String essentialRecords,
                                  @RequestParam(value = "improvingRecords") String improvingRecords,
                                  @RequestParam(value = "developmentalRecords") String developmentalRecords,
                                  @RequestParam(value = "totalHours") List<String> totalHours,
                                  @RequestParam(value = "passedHours") List<String> passedHours,
                                  @RequestParam(value = "passedPercent") List<String> passedPercent,
                                  @RequestParam(value = "personnel") List<String> personnel) throws Exception {

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put("essentialTotal", totalHours.get(1));
        params.put("essentialPassed", passedHours.get(1));
        params.put("essentialPercent", passedPercent.get(1));
        params.put("improvingTotal", totalHours.get(2));
        params.put("improvingPassed", passedHours.get(2));
        params.put("improvingPercent", passedPercent.get(2));
        params.put("developmentalTotal", totalHours.get(3).substring(0, totalHours.get(3).length() - 1));
        params.put("developmentalPassed", passedHours.get(3).substring(0, passedHours.get(3).length() - 1));
        params.put("developmentalPercent", passedPercent.get(3).substring(0, passedPercent.get(3).length() - 1));

        String data = "{" +
                "\"essentialDS\": " + essentialRecords + "," +
                "\"improvingDS\": " + improvingRecords + "," +
                "\"developmentalDS\": " + developmentalRecords + "," +
                "\"dsStudent\": " + personnel +
                "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/personnelNeedsAssessmentReport.jasper", params, jsonDataSource, response);
    }
}
