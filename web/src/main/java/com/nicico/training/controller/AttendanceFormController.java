package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.utility.MakeExcelOutputUtil;
import com.nicico.training.utility.SpecListUtil;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import springfox.documentation.spring.web.json.Json;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.util.*;

@RequiredArgsConstructor
@Controller
@RequestMapping("/attendance")
public class AttendanceFormController {
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final SpecListUtil specListUtil;
//    private final CourseService courseService;

//    @RequestMapping("/show-form")
//    public String showPost() {
//        return "base/course";
//    }

    @PostMapping("/print")
    public void ExportToExcel(HttpServletResponse response, @RequestBody(required = false) HashMap<String, List> data) {
//
        try {
            List<HashMap<String, String>> fields1 = data.get("fields");
            List<HashMap<String, String>> allData = data.get("allRows");
            fields1.remove(0);
            String[] headers = new String[fields1.size()];
            String[] columns = new String[fields1.size()];
            for (int i = 0; i < fields1.size(); i++) {
                headers[i] = fields1.get(i).get("title");
                columns[i] = fields1.get(i).get("name");
            }
            Workbook workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("Export");
//        // Create a Font for styling header cells
//        Font headerFont = workbook.createFont();
//        headerFont.setBold(true);
//        headerFont.setFontHeightInPoints((short) 14);
//        headerFont.setColor(IndexedColors.RED.getIndex());
//        // Create a CellStyle with the font
//        CellStyle headerCellStyle = workbook.createCellStyle();
//        headerCellStyle.setFont(headerFont);
            // Create a Row
            Row headerRow = sheet.createRow(0);
            // Create cells
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
//            cell.setCellStyle(headerCellStyle);
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
            FileOutputStream fileOut = new FileOutputStream("attendance.xlsx");
            workbook.write(fileOut);
            fileOut.close();

            File file = new File("attendance.xlsx");
            InputStream in = new FileInputStream(file);
            String mimeType = new MimetypesFileTypeMap().getContentType(file);
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            response.setContentType("application/vnd.ms-excel");
            response.setContentLength((int) file.length());
            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
            response.setHeader(headerKey, headerValue);
            OutputStream outStream = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead = -1;
            while ((bytesRead = in.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }

            in.close();
            outStream.close();


//        OutputStream outputStream = response.getOutputStream();
//        byte[] buffer = new byte[4096];
//        int bytesRead;
//        while ((bytesRead = inputStream.read(buffer)) != -1) {
//            outputStream.write(buffer, 0, bytesRead);
//        }
//        outputStream.flush();

//        HttpHeaders headersFile = new HttpHeaders();
//        headersFile.add("Cache-Control", "no-cache, no-store, must-revalidate");
//        headersFile.add("Pragma", "no-cache");
//        headersFile.add("Expires", "0");
//        InputStreamResource resource = new InputStreamResource(new FileInputStream("attendance.xlsx"));
//
//        return ResponseEntity.ok()
//                .headers(headersFile)
//                .contentLength(file.length())
//                .contentType(MediaType.parseMediaType("application/octet-stream"))
//                .body(resource);

//        File file = n
//        FileInputStream inputStream = new FileInputStream("attendnce.xlsx");
//        workbook.write(inputStream);
//        inputStream.close();


            // Closing the workbook
//        workbook.close();
//
//        CourseDTO.CourseSpecRs specRs = specListUtil.createSearchRq(0, Integer.MAX_VALUE, null, request.getParameter("criteria"), null, req -> {
//
//            SearchDTO.SearchRs<CourseDTO.Info> resp = courseService.search(req);
//
//            final CourseDTO.SpecRs specResponse = new CourseDTO.SpecRs();
//            specResponse.setData(resp.getList())
//                    .setStartRow(0)
//                    .setEndRow(resp.getTotalCount().intValue())
//                    .setTotalRows(resp.getTotalCount().intValue());
//
//            return new CourseDTO.CourseSpecRs().setResponse(specResponse);
//        });
//
//        byte[] bytes = makeExcelOutputUtil.makeOutput(
//                new ArrayList<>(specRs.getResponse().getData()),
//                CourseDTO.Info.class,
//                fields, headers, false, "");
//
//        makeExcelOutputUtil.makeExcelResponse(bytes, response);
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }

    @PostMapping(value = {"/download"})
    public void getAttach(final HttpServletResponse response, @RequestParam(value = "fields") String fields, @RequestParam(value = "allRows") String allRows) {

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>(){}.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);
        List<HashMap<String, String>> allData = gson.fromJson(allRows, resultType);
        String fileFullPath = "attendance.xlsx";
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
//        Font headerFont = workbook.createFont();
//        headerFont.setBold(true);
//        headerFont.setFontHeightInPoints((short) 14);
//        headerFont.setColor(IndexedColors.RED.getIndex());
//        // Create a CellStyle with the font
//        CellStyle headerCellStyle = workbook.createCellStyle();
//        headerCellStyle.setFont(headerFont);
            // Create a Row
            Row headerRow = sheet.createRow(0);
            // Create cells
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
//            cell.setCellStyle(headerCellStyle);
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
            FileOutputStream fileOut = new FileOutputStream("attendance.xlsx");
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


//        String token = request.getParameter("myToken");
//
//        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("Authorization", "Bearer " + token);
////        headers.add("Authorization", authorization);
//
//        RestTemplate restTemplate = new RestTemplate();
//        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
//        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);
//        return restTemplate.exchange(restApiUrl + "/api/attendance/download" , HttpMethod.GET, entity, byte[].class);
    }

//    @RequestMapping("/print")
//    public void exportPostLevelToExcel(@RequestParam MultiValueMap<String, String> criteria, HttpServletResponse response) throws Exception {
//
//        List<Object> resp = new ArrayList<>();
//        NICICOCriteria nicicoCriteria = specListUtil.provideNICICOCriteria(criteria, CourseDTO.Info.class);
//        List<CourseDTO.Info> data = courseService.search(nicicoCriteria).getResponse().getData();
//        if (data != null) resp.addAll(data);
//
//        String[] fields = criteria.getFirst("fields").split(",");
//        String[] headers = criteria.getFirst("headers").split(",");
//        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, CourseDTO.Info.class, fields, headers, false, "");
//        makeExcelOutputUtil.makeExcelResponse(bytes, response);
//    }
}
