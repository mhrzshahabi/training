package com.nicico.training.controller;

import com.nicico.training.service.ExportToFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Locale;

@RequiredArgsConstructor
@Controller
@RequestMapping("/reportsToExcel")
public class ReportsToExcelFormController {

    private final ExportToFileService exportToFileService;
    private final MessageSource messageSource;

    @PostMapping(value = {"/areaNeedAssessment"})
    public void exportExcelFromClient(final HttpServletResponse response,
                                      @RequestParam(value = "fields") String fields,
                                      @RequestParam(value = "data") String data,
                                      @RequestParam(value = "titr") String titr,
                                      @RequestParam(value = "pageName") String pageName) throws IOException {

        try {
            exportToFileService.exportToExcel(response, fields, data, titr, pageName);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }
}