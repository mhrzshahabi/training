package com.nicico.training.controller;

import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.Charset;
import java.util.HashMap;

@RequiredArgsConstructor
@Controller
@RequestMapping("/needsAssessment-reports")
public class NeedsAssessmentReportsFormController {

    private final ReportUtil reportUtil;

    @PostMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "reportType") String reportType,
                      @RequestParam(value = "essentialServiceRecords") String essentialServiceRecords,
                      @RequestParam(value = "essentialAppointmentRecords") String essentialAppointmentRecords,
                      @RequestParam(value = "improvingRecords") String improvingRecords,
                      @RequestParam(value = "developmentalRecords") String developmentalRecords,
                      @RequestParam(value = "params") String receiveParams
    ) throws Exception {
        //-------------------------------------

        if (receiveParams.endsWith(","))
            receiveParams = receiveParams.substring(0, receiveParams.length() - 1);
        Gson gson = new Gson();
        HashMap<String, Object> params = gson.fromJson(receiveParams, new TypeToken<HashMap<String, Object>>() {
        }.getType());
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);

        String data = "{" +
                "\"essentialServiceDS\": " + essentialServiceRecords + "," +
                "\"essentialAppointmentDS\": " + essentialAppointmentRecords + "," +
                "\"improvingDS\": " + improvingRecords + "," +
                "\"developmentalDS\": " + developmentalRecords +
                "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/personnelNeedsAssessmentReport" + reportType + ".jasper", params, jsonDataSource, response);
    }
}
