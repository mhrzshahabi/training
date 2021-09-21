package com.nicico.training.iservice;


import javax.servlet.http.HttpServletResponse;
import java.util.Map;

public interface IExportToFileService {

    void exportToExcel(final HttpServletResponse response, String fields, String data, String titr, String pageName) throws Exception;

    void exportToWord(final HttpServletResponse response, String fields, String data, String titr, String pageName, Map<String,String> titles) throws Exception;

    String exportToExcel(Map < Integer, Object[] >  dataMap);
}
