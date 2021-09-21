package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.minio.MinIoClient;
import com.nicico.training.dto.NeedAssessmentGroupJobPromotionResponse;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.iservice.IExportToFileService;
import com.nicico.training.service.NeedsAssessmentReportsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.http.HttpMessageConverters;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import request.needsassessment.NeedAssessmentGroupJobPromotionRequestDto;
import response.minio.UploadFmsRes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment-reports")
public class NeedsAssessmentReportsRestController {

    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final ReportUtil reportUtil;
    private final MessageSource messageSource;
    private final IExportToFileService iExportToFileService;
    private final MinIoClient minIoClient;
    @Value("${nicico.minioUrl}")
    private String minioUrl;
    @Value("${nicico.minioQuestionsGroup}")
    private String groupId;
    private final ObjectFactory<HttpMessageConverters> messageConverters;
    private final MinIoClient client;
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

    @Loggable
    @PostMapping(value = "/getGroupJobPromotions")
    public ResponseEntity groupJobPromotionReport(@RequestBody NeedAssessmentGroupJobPromotionRequestDto requestDto, @RequestHeader("Authorization") String token) throws IOException {

        List<NeedAssessmentGroupJobPromotionResponse> needAssessmentResultGroup = needsAssessmentReportsService.createNeedAssessmentResultGroup(requestDto);

        Map < Integer, Object[] > finalInfosToExcelMap = new TreeMap < Integer, Object[] >();
        finalInfosToExcelMap.put( 1, new Object[] {
                "ردیف",  "کد پست",  "نام", "نام خانوادگی", "امور", "شایستگی", "نوع شایستگی", "حیطه", "کد مهارت", "مهارت", "کد دوره", "دوره", "مدت", "وضعیت", "وضعیت نمره"} );
        int rowNum = 1;
        for (int i = 0 ; i < needAssessmentResultGroup.size() ; i++){
            rowNum++;
            finalInfosToExcelMap.put( rowNum, new Object[] {
                    Integer.toString(i+1),
                    needAssessmentResultGroup.get(i).getTrainingPostCode(),
                    needAssessmentResultGroup.get(i).getFirstName(),
                    needAssessmentResultGroup.get(i).getLastName(),
                    needAssessmentResultGroup.get(i).getPersonnelCcpAffairs(),
                    needAssessmentResultGroup.get(i).getCompetence().getTitle(),
                    needAssessmentResultGroup.get(i).getCompetenceTypeTitle()/*"نوع شایستگی"*/,
                    needAssessmentResultGroup.get(i).getNeedsAssessmentPriorityTitle()/*"حیطه"*/,
                    needAssessmentResultGroup.get(i).getSkill().getCode()/*"کد مهارت"*/,
                    needAssessmentResultGroup.get(i).getSkill().getTitleFa()/*"مهارت"*/,
                    needAssessmentResultGroup.get(i).getSkill().getCourse().getCode()/*"کد دوره"*/,
                    needAssessmentResultGroup.get(i).getSkill().getCourse().getTitleFa()/*"دوره"*/,
                    needAssessmentResultGroup.get(i).getSkill().getCourse().getTheoryDuration().toString()/*"مدت"*/,
                    needAssessmentResultGroup.get(i).getScoresStateTitle() /*"وضعیت"*/,
                    needAssessmentResultGroup.get(i).getSkill().getCourse().getScoresStatus()/*"وضعیت نمره"*/
            } );
        }

        //minIoClient.uploadFile(token,is,groupId);

        String fileName = iExportToFileService.exportToExcel(finalInfosToExcelMap);
        byte[] bytes = Files.readAllBytes(Paths.get(fileName));
        MultipartFile multipartFile = new MockMultipartFile(fileName,
                fileName,"multipart/form-data", bytes);

//        UploadFmsRes key = minIoClient.uploadFile(token,multipartFile,groupId);
        return null;

    }

    @GetMapping(value = "/courseNA")
    public ResponseEntity courseNA(HttpServletRequest iscRq, @RequestParam Long courseId, @RequestParam Boolean passedReport) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity(ISC.convertToIscRs(needsAssessmentReportsService.getCourseNA(searchRq, courseId, passedReport), searchRq.getStartIndex()), HttpStatus.OK);
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
