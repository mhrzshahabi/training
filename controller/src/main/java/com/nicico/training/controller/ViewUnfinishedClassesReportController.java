package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.dto.ViewUnfinishedClassesReportDTO;
import com.nicico.training.service.ViewUnfinishedClassesReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("api/unfinishedClasses")
public class ViewUnfinishedClassesReportController {
    private final ViewUnfinishedClassesReportService viewUnfinishedClassesReportService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewUnfinishedClassesReportDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();

        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setFieldName("nationalCode");
        criteriaRq.setValue(modelMapper.map(SecurityContextHolder.getContext().getAuthentication().getPrincipal(), CustomUserDetails.class).getNationalCode());
        searchRq.setCriteria(criteriaRq);
        searchRq.setSortBy("classId");

        SearchDTO.SearchRs<ViewUnfinishedClassesReportDTO.Grid> searchRs = viewUnfinishedClassesReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

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

//        SearchDTO.SearchRs<ViewUnfinishedClassesReportDTO.Grid> list = viewUnfinishedClassesReportService.search(searchRq);
//
//        String studentName = "";
//        if (list.getList().size() > 0)
//            studentName = "فراگیر : " + list.getList().get(0).getFirstName() + " " + list.getList().get(0).getLastName();
//
//        final Map<String, Object> params = new HashMap<>();
//        params.put("todayDate", dateUtil.todayDate());
//        params.put("studentName", studentName);
//
//        String data = "{" + "\"dsUnfinishedClasses\": " + objectMapper.writeValueAsString(list) + "}";
//
//        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
//
//        params.put(ConstantVARs.REPORT_TYPE, type);
//        reportUtil.export("/reports/UnfinishedClasses.jasper", params, jsonDataSource, response);
    }
}