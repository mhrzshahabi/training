package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.utility.MakeExcelOutputUtil;
import com.nicico.training.utility.SpecListUtil;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.bouncycastle.asn1.pkcs.PKCSObjectIdentifiers.data;

@RequiredArgsConstructor
@Controller
@RequestMapping("/export-to-excel")
public class ExportToExcelController {
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final SpecListUtil specListUtil;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final NeedsAssessmentService needsAssessmentService;

    @PostMapping(value = {"/download"})
    public void getAttach(final HttpServletResponse response, @RequestParam(value = "fields") String fields, @RequestParam(value = "data") String data) {

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);
        List<HashMap<String, String>> allData = gson.fromJson(data, resultType);
        String fileFullPath = "export.xlsx";
        try {

            String[] headers = new String[fields1.size()];
            String[] columns = new String[fields1.size()];
            for (int i = 0; i < fields1.size(); i++) {
                headers[i] = fields1.get(i).get("title");
                columns[i] = fields1.get(i).get("name");
            }
            Workbook workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("Export");
            sheet.setRightToLeft(true);
//        // Create a Font for styling header cells
            Font headerFont = workbook.createFont();
            headerFont.setFontName("Tahoma");
//        headerFont.setBold(true);
            headerFont.setFontHeightInPoints((short) 12);
            headerFont.setColor(IndexedColors.RED.getIndex());
//        // Create a CellStyle with the font
            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);
            // Create a Row
            Row headerRow = sheet.createRow(0);
            // Create cells
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);
            }
            // Create Cell Style for formatting Date
            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));
            // Create Other rows and cells with employees data
            int rowNum = 1;
            for (HashMap<String, String> map : allData) {
                Row row = sheet.createRow(rowNum++);
                for (int i = 0; i < columns.length; i++) {
                    row.createCell(i)
                            .setCellValue(map.get(columns[i]));
                }
            }
            // Resize all columns to fit the content size
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }
            // Write the output to a file
            FileOutputStream fileOut = new FileOutputStream(fileFullPath);
            workbook.write(fileOut);
            fileOut.close();

            File file = new File(fileFullPath);
            FileInputStream in = new FileInputStream(file);
            String mimeType = new MimetypesFileTypeMap().getContentType(fileFullPath);
            String fileName = URLEncoder.encode("excel.xlsx", "UTF-8").replace("+", "%20");
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            response.setContentLength((int) file.length());
            OutputStream outStream = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
            outStream.flush();
            in.close();

        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    @PostMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "data") String data,
                      @RequestParam(value = "params") String receiveParams
                      ) throws Exception {
        //-------------------------------------
        Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
//        final Map<String, Object> params = new HashMap<>();
        data = "{" + "\"content\": " + data + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE,type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    @PostMapping(value = {"/print-criteria/{type}"})
    public void printWithCriteria (HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "CriteriaStr") String criteriaStr,
                      @RequestParam(value = "params") String receiveParams
                      ) throws Exception {
        //-------------------------------------
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        final SearchDTO.SearchRs<NeedsAssessmentDTO.Info> searchRs = needsAssessmentService.search(searchRq);
        final Gson gson = new Gson();
        final Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE,type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }
}
