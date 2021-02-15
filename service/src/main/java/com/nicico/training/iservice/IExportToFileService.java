package com.nicico.training.iservice;

import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;

public interface IExportToFileService {

    void exportToExcel(final HttpServletResponse response, String fields, String data, String titr, String pageName) throws Exception;

    void exportToWord(final HttpServletResponse response, String fields, String data, String titr, String pageName) throws Exception;
}
