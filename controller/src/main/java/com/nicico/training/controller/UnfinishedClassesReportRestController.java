package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.UnfinishedClassesReportDTO;
import com.nicico.training.service.UnfinishedClassesReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("api/unfinishedClasses")
public class UnfinishedClassesReportRestController {

    private final UnfinishedClassesReportService unfinishedClassesReportService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<UnfinishedClassesReportDTO.UnfinishedClassesSpecRs> list() throws IOException {

        List<UnfinishedClassesReportDTO> list = new ArrayList<>();
        list = unfinishedClassesReportService.UnfinishedClassesList();

        final UnfinishedClassesReportDTO.SpecRs specResponse = new UnfinishedClassesReportDTO.SpecRs();
        final UnfinishedClassesReportDTO.UnfinishedClassesSpecRs specRs = new UnfinishedClassesReportDTO.UnfinishedClassesSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //*********************************

    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

//        final SearchDTO.CriteriaRq criteriaRq;
//        final SearchDTO.SearchRq searchRq;
//        if (criteriaStr.equalsIgnoreCase("{}")) {
//            searchRq = new SearchDTO.SearchRq();
//        } else {
//            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
//            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
//        }
//
//        final SearchDTO.SearchRs<UnfinishedClassesReportDTO.Info> searchRs = unfinishedClassesReportService.search(searchRq);

        List<UnfinishedClassesReportDTO> list = unfinishedClassesReportService.UnfinishedClassesList();


        String studentName = "";
        if (list.size() > 0)
            studentName = "فراگیر : " + list.get(0).getFirstName() + " " + list.get(0).getLastName();

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("studentName", studentName);

        String data = "{" + "\"dsUnfinishedClasses\": " + objectMapper.writeValueAsString(list) + "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/UnfinishedClasses.jasper", params, jsonDataSource, response);
    }

    //*********************************

}
