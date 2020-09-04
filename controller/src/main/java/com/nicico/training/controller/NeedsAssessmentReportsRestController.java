package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.service.NeedsAssessmentReportsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
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
import java.util.Locale;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment-reports")
public class NeedsAssessmentReportsRestController {

    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final ReportUtil reportUtil;
    private final MessageSource messageSource;

    @GetMapping
    public ResponseEntity fullList(HttpServletRequest iscRq,
                                   @RequestParam Long objectId,
                                   @RequestParam String objectType,
                                   @RequestParam(required = false) Long personnelId,
                                   HttpServletResponse response) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        try {
            SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchRs = needsAssessmentReportsService.search(searchRq, objectId, objectType, personnelId);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
        } catch (TrainingException e) {
            Locale locale = LocaleContextHolder.getLocale();
            String message = e.getMessage().equals("PostNotFound") ? messageSource.getMessage("needsAssessmentReport.postCode.not.Found", null, locale) : e.getMessage();
            return new ResponseEntity<>(message, HttpStatus.OK);
        }
    }

    @GetMapping(value = "/courseNA")
    public ResponseEntity courseNA(HttpServletRequest iscRq, @RequestParam Long courseId, @RequestParam Boolean passedReport) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity(ISC.convertToIscRs(needsAssessmentReportsService.getCourseNA(searchRq, courseId, passedReport), searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/skillNA")
    public ResponseEntity skillNA(HttpServletRequest iscRq, @RequestParam Long skillId) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity(ISC.convertToIscRs(needsAssessmentReportsService.getSkillNAPostList(searchRq, skillId), searchRq.getStartIndex()), HttpStatus.OK);
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
