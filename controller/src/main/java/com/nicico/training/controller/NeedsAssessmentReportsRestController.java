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
                                  @RequestParam(value = "totalEssentialHours") String totalEssentialHours,
                                  @RequestParam(value = "passedEssentialHours") String passedEssentialHours,
                                  @RequestParam(value = "totalImprovingHours") String totalImprovingHours,
                                  @RequestParam(value = "passedImprovingHours") String passedImprovingHours,
                                  @RequestParam(value = "totalDevelopmentalHours") String totalDevelopmentalHours,
                                  @RequestParam(value = "passedDevelopmentalHours") String passedDevelopmentalHours,
                                  @RequestParam(value = "personnel") List<String> personnel) throws Exception {

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put("essentialTotal", totalEssentialHours);
        params.put("essentialPassed", passedEssentialHours);
        params.put("essentialPercent", totalEssentialHours.equals("0") ? "0" : String.valueOf(Math.round(Float.valueOf(passedEssentialHours) / Float.valueOf(totalEssentialHours) * 100)));
        params.put("improvingTotal", totalImprovingHours);
        params.put("improvingPassed", passedImprovingHours);
        params.put("improvingPercent", totalImprovingHours.equals("0") ? "0" : String.valueOf(Math.round(Float.valueOf(passedImprovingHours) / Float.valueOf(totalImprovingHours) * 100)));
        params.put("developmentalTotal", totalDevelopmentalHours);
        params.put("developmentalPassed", passedDevelopmentalHours);
        params.put("developmentalPercent", totalDevelopmentalHours.equals("0") ? "0" : String.valueOf(Math.round(Float.valueOf(passedDevelopmentalHours) / Float.valueOf(totalDevelopmentalHours) * 100)));

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
