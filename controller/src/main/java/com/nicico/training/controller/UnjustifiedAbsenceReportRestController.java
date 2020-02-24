package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.service.UnjustifiedAbsenceReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/unjustifiedAbsenceReport")
public class UnjustifiedAbsenceReportRestController {
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final UnjustifiedAbsenceReportService unjustifiedAbsenceReportService;
    @Loggable
    @PostMapping(value = {"/print"})
    public void print(HttpServletResponse response, @RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate)  throws Exception{

        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);

        Object object= unjustifiedAbsenceReportService.print(startDate,endDate);
        String data = null;
        data = "{" + "\"unjustifiedAbsence\": " + objectMapper.writeValueAsString(object) + "}";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/unjustified_absence.jasper", params, jsonDataSource, response);
    }
}
