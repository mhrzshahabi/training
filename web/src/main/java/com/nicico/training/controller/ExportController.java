package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.model.ViewReactionEvaluationFormulaReport;
import com.nicico.training.repository.ViewReactionEvaluationFormulaReportDAO;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/export")
public class ExportController {
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final NeedsAssessmentService needsAssessmentService;
    private final StudentClassReportViewService studentClassReportViewService;
    private final TclassService tclassService;
    private final SkillService skillService;
    private final CourseService courseService;
    private final WorkGroupService workGroupService;
    private final ViewReactionEvaluationFormulaReportDAO dao;

    @PostMapping(value = {"/excel"})
    public void getAttach(final HttpServletResponse response, @RequestParam(value = "fields") String fields,
                          @RequestParam(value = "data") String data,
                          @RequestParam(value = "titr") String titr) {

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);
        List<HashMap<String, String>> allData = gson.fromJson(data, resultType);
        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[fields1.size()];
            String[] columns = new String[fields1.size()];
            for (int i = 0; i < fields1.size(); i++) {
                headers[i] = fields1.get(i).get("title");
                columns[i] = fields1.get(i).get("name");
            }
            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("گزارش excel");
            sheet.setRightToLeft(true);

            Font headerFont = workbook.createFont();
            headerFont.setFontHeightInPoints((short) 12);
            headerFont.setColor(IndexedColors.BLUE_GREY.getIndex());

            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);

            Row headerRow2 = sheet.createRow(0);
            Cell cell2 = headerRow2.createCell(0);
            cell2.setCellValue(titr);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (HashMap<String, String> map : allData) {
                Row row = sheet.createRow(++rowNum);
                for (int i = 0; i < columns.length; i++) {
                    row.createCell(i)
                            .setCellValue(map.get(columns[i]));
                }
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            CellStyle mine = workbook.createCellStyle();
            mine.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
            mine.setFillBackgroundColor(IndexedColors.BLUE_GREY.getIndex());
            sheet.getRow(0).setRowStyle(mine);


            FileOutputStream fileOut = new FileOutputStream(fileFullPath);
            workbook.write(fileOut);
            fileOut.close();

            File file = new File(fileFullPath);
            in = new FileInputStream(file);
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
        } finally {
            if (workbook != null) {
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @PostMapping(value = {"/excel/formula"})
    public void getExcelDataForFormulaReport(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {



        SearchDTO.CriteriaRq criteriaRq;

            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
        try {
            criteriaRq.setOperator(EOperator.valueOf("and"))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
        } catch (IOException e) {
            e.printStackTrace();
        }
        String start="";
        String end="";
        List<Object> categoryList=new ArrayList<>();
        List<Object> subCategoryList=new ArrayList<>();
         for (int f=0 ; f<criteriaRq.getCriteria().get(0).getCriteria().size();f++){
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classStartDate"))
            start=criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classEndDate"))
                end=criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("categoryTitleFa")){
          categoryList=criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();}
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("subCategoryTitleFa")){
               subCategoryList=criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();
            }

        }

        List<ViewReactionEvaluationFormulaReport>    firstData=  dao.getAll(start,end);
        List<Object> finalCategoryList = categoryList;
        List<Object> finalSubCategoryList = subCategoryList;
        List<ViewReactionEvaluationFormulaReport> secondData;
        List<ViewReactionEvaluationFormulaReport> data;
       if (categoryList.size()>0){
           secondData  =firstData.stream()
                   .filter(first -> finalCategoryList.stream()
                           .anyMatch(category -> first.getCategory_titlefa().equals(category)))
                   .collect(Collectors.toList());
       }else{
            secondData=firstData;
       }
       if (subCategoryList.size()>0){
           data =secondData.stream()
                   .filter(sec -> finalSubCategoryList.stream()
                           .anyMatch(sub -> sec.getSub_category_titlefa().equals(sub)))
                   .collect(Collectors.toList());
       }else {
           data=secondData;
       }


        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[23];
            String[] columns = new String[23];


            for (int z = 0; z < 23; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "کد ملی فراگیر";
                        columns[z] = "student";
                        break;
                    }
                    case 1: {
                        headers[z] = " شماره پرسنلی فراگیر";
                        columns[z] = "student_per_number";
                        break;
                    }
                    case 2: {
                        headers[z] = " کد پست فراگیر";
                        columns[z] = "student_post_code";
                        break;
                    }
                    case 3: {
                        headers[z] = " عنوان پست فراگیر";
                        columns[z] = "student_post_title";
                        break;
                    }
                    case 4: {
                        headers[z] = " حوزه فراگیر";
                        columns[z] = "student_hoze";
                        break;
                    }
                    case 5: {
                        headers[z] = " امور فراگیر";
                        columns[z] = "student_omor";
                        break;
                    }
                    case 6: {
                        headers[z] = " کد کلاس";
                        columns[z] = "class_code";

                        break;
                    }
                    case 7: {
                        headers[z] = "مجتمع کلاس";
                        columns[z] = "complex";
                        break;
                    }
                    case 8: {
                        headers[z] = "تاریخ شروع کلاس";
                        columns[z] = "class_start_date";
                        break;
                    }
                    case 9: {
                        headers[z] = "تاریخ انتهای کلاس";
                        columns[z] = "class_end_date";
                        break;
                    }
                    case 10: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "class_status";
                        break;
                    }
                    case 11: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 12: {
                        headers[z] = "کد ملی استاد";
                        columns[z] = "teacher_national_code";
                        break;
                    }
                    case 13: {
                        headers[z] = "نوع استاد";
                        columns[z] = "is_personnel";
                        break;
                    }
                    case 14: {
                        headers[z] = "کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 15: {
                        headers[z] = "عنوان دوره";
                        columns[z] = "course_titlefa";
                        break;
                    }
                    case 16: {
                        headers[z] = "گروه";
                        columns[z] = "category_titlefa";
                        break;
                    }
                    case 17: {
                        headers[z] = "زیرگروه";
                        columns[z] = "sub_category_titlefa";
                        break;
                    }
                    case 18: {
                        headers[z] = "تعداد فراگیر این کلاس";
                        columns[z] = "total_std";
                        break;
                    }
                    case 19: {
                        headers[z] = "ارزیابی مسئول آموزش از استاد";
                        columns[z] = "training_grade_to_teacher";
                        break;
                    }
                    case 20: {
                        headers[z] = "ارزیابی استاد از کلاس";
                        columns[z] = "teacher_grade_to_class";
                        break;
                    }
                    case 21: {
                        headers[z] = "میانگین ارزیابی واکنشی فراگیران کلاس";
                        columns[z] = "reactione_evaluation_grade";
                        break;
                    }
                    case 22: {
                        headers[z] = "ارزیابی نهایی استاد در کلاس";
                        columns[z] = "final_teacher";
                        break;
                    }
                }
            }

            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("گزارش excel");
            sheet.setRightToLeft(true);

            Font headerFont = workbook.createFont();
            headerFont.setFontHeightInPoints((short) 12);
            headerFont.setColor(IndexedColors.BLUE_GREY.getIndex());

            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);

            Row headerRow2 = sheet.createRow(0);
            Cell cell2 = headerRow2.createCell(0);
            cell2.setCellValue("گزارش ارزیابی واکنشی");

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (ViewReactionEvaluationFormulaReport map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {
                        case "class_code": {
                            row.createCell(i).setCellValue(map.getClass_code());
                            break;
                        }
                        case "complex": {
                            row.createCell(i).setCellValue(map.getComplex());
                            break;
                        }
                        case "teacher_national_code": {
                            row.createCell(i).setCellValue(map.getTeacher_national_code());
                            break;
                        }
                        case "teacher": {
                            row.createCell(i).setCellValue(map.getTeacher());
                            break;
                        }
                        case "is_personnel": {
                            row.createCell(i).setCellValue(map.getIs_personnel());
                            break;
                        }
                        case "class_start_date": {
                            row.createCell(i).setCellValue(map.getClass_start_date());
                            break;
                        }
                        case "class_end_date": {
                            row.createCell(i).setCellValue(map.getClass_end_date());
                            break;
                        }
                        case "course_code": {
                            row.createCell(i).setCellValue(map.getCourse_code());
                            break;
                        }
                        case "course_titlefa": {
                            row.createCell(i).setCellValue(map.getCourse_titlefa());
                            break;
                        }
                        case "category_titlefa": {
                            row.createCell(i).setCellValue(map.getCategory_titlefa());
                            break;
                        }
                        case "sub_category_titlefa": {
                            row.createCell(i).setCellValue(map.getSub_category_titlefa());
                            break;
                        }
                        case "student": {
                            row.createCell(i).setCellValue(map.getStudent());
                            break;
                        }
                        case "class_status": {
                            row.createCell(i).setCellValue(map.getClass_status());
                            break;
                        }

                        case "student_per_number": {
                            row.createCell(i).setCellValue(map.getStudent_per_number());
                            break;
                        } case "student_post_title": {
                            row.createCell(i).setCellValue(map.getStudent_post_title());
                            break;
                        } case "student_post_code": {
                            row.createCell(i).setCellValue(map.getStudent_post_code());
                            break;
                        } case "student_hoze": {
                            row.createCell(i).setCellValue(map.getStudent_hoze());
                            break;
                        } case "student_omor": {
                            row.createCell(i).setCellValue(map.getStudent_omor());
                            break;
                        } case "total_std": {
                            row.createCell(i).setCellValue(map.getTotal_std());
                            break;
                        } case "training_grade_to_teacher": {
                            row.createCell(i).setCellValue(map.getTraining_grade_to_teacher());
                            break;
                        } case "teacher_grade_to_class": {
                            row.createCell(i).setCellValue(map.getTeacher_grade_to_class());
                            break;
                        } case "reactione_evaluation_grade": {
                            row.createCell(i).setCellValue(map.getReactione_evaluation_grade());
                            break;
                        } case "final_teacher": {
                            row.createCell(i).setCellValue(map.getFinal_teacher());
                            break;
                        }
                    }

                }
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            CellStyle mine = workbook.createCellStyle();
            mine.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
            mine.setFillBackgroundColor(IndexedColors.BLUE_GREY.getIndex());
            sheet.getRow(0).setRowStyle(mine);


            FileOutputStream fileOut = new FileOutputStream(fileFullPath);
            workbook.write(fileOut);
            fileOut.close();

            File file = new File(fileFullPath);
            in = new FileInputStream(file);
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
        } finally {
            if (workbook != null) {
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
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
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
        data = "{" + "\"content\": " + data + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }

    @PostMapping(value = {"/print-criteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "fileName") String fileName,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr,
                                  @RequestParam(value = "sortBy") String sortBy,
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
        List list = null;
        switch (fileName) {
            case "oneNeedsAssessment.jasper":
                final SearchDTO.SearchRs<NeedsAssessmentDTO.Info> searchNAS = needsAssessmentService.fullSearch(searchRq);
                list = searchNAS.getList();
                break;
            case "personnelCourses.jasper":
                SearchDTO.SearchRs<StudentClassReportViewDTO.Info> searchSCRVS = studentClassReportViewService.search(searchRq);
                list = searchSCRVS.getList();
                break;
            case "ClassByCriteria.jasper":
                searchRq.setSortBy(sortBy);
                SearchDTO.SearchRs<TclassDTO.Info> searchTC = tclassService.mainSearch(searchRq);
                list = searchTC.getList();
                break;
            case "Skill_Report.jasper":
                searchRq.setCriteria(workGroupService.addPermissionToCriteria("categoryId", searchRq.getCriteria()));
                SearchDTO.SearchRs<SkillDTO.Info> searchSkill = skillService.searchWithoutPermission(searchRq);
                list = searchSkill.getList();
                break;
            case "CourseByCriteria.jasper":
                searchRq.setSortBy(sortBy);
                searchRq.setCriteria(workGroupService.addPermissionToCriteria("categoryId", searchRq.getCriteria()));
                SearchDTO.SearchRs<CourseDTO.Info> searchCourse = courseService.search(searchRq);
                list = searchCourse.getList();
                break;
        }
        final Gson gson = new Gson();
        final Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(list) + "}";
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }


    @PostMapping(value = {"/excel/un-passed"})
    public void getExcelDataForUnPassedReport(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {

        List<Object>    data=  dao.getAllUnPassedNa();



        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[23];
            String[] columns = new String[23];


            for (int z = 0; z < 23; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "کد ملی فراگیر";
                        columns[z] = "student";
                        break;
                    }
                    case 1: {
                        headers[z] = " شماره پرسنلی فراگیر";
                        columns[z] = "student_per_number";
                        break;
                    }
                    case 2: {
                        headers[z] = " کد پست فراگیر";
                        columns[z] = "student_post_code";
                        break;
                    }
                    case 3: {
                        headers[z] = " عنوان پست فراگیر";
                        columns[z] = "student_post_title";
                        break;
                    }
                    case 4: {
                        headers[z] = " حوزه فراگیر";
                        columns[z] = "student_hoze";
                        break;
                    }
                    case 5: {
                        headers[z] = " امور فراگیر";
                        columns[z] = "student_omor";
                        break;
                    }
                    case 6: {
                        headers[z] = " کد کلاس";
                        columns[z] = "class_code";

                        break;
                    }
                    case 7: {
                        headers[z] = "مجتمع کلاس";
                        columns[z] = "complex";
                        break;
                    }
                    case 8: {
                        headers[z] = "تاریخ شروع کلاس";
                        columns[z] = "class_start_date";
                        break;
                    }
                    case 9: {
                        headers[z] = "تاریخ انتهای کلاس";
                        columns[z] = "class_end_date";
                        break;
                    }
                    case 10: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "class_status";
                        break;
                    }
                    case 11: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 12: {
                        headers[z] = "کد ملی استاد";
                        columns[z] = "teacher_national_code";
                        break;
                    }
                    case 13: {
                        headers[z] = "نوع استاد";
                        columns[z] = "is_personnel";
                        break;
                    }
                    case 14: {
                        headers[z] = "کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 15: {
                        headers[z] = "عنوان دوره";
                        columns[z] = "course_titlefa";
                        break;
                    }
                    case 16: {
                        headers[z] = "گروه";
                        columns[z] = "category_titlefa";
                        break;
                    }
                    case 17: {
                        headers[z] = "زیرگروه";
                        columns[z] = "sub_category_titlefa";
                        break;
                    }
                    case 18: {
                        headers[z] = "تعداد فراگیر این کلاس";
                        columns[z] = "total_std";
                        break;
                    }
                    case 19: {
                        headers[z] = "ارزیابی مسئول آموزش از استاد";
                        columns[z] = "training_grade_to_teacher";
                        break;
                    }
                    case 20: {
                        headers[z] = "ارزیابی استاد از کلاس";
                        columns[z] = "teacher_grade_to_class";
                        break;
                    }
                    case 21: {
                        headers[z] = "میانگین ارزیابی واکنشی فراگیران کلاس";
                        columns[z] = "reactione_evaluation_grade";
                        break;
                    }
                    case 22: {
                        headers[z] = "ارزیابی نهایی استاد در کلاس";
                        columns[z] = "final_teacher";
                        break;
                    }
                }
            }

            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("گزارش excel");
            sheet.setRightToLeft(true);

            Font headerFont = workbook.createFont();
            headerFont.setFontHeightInPoints((short) 12);
            headerFont.setColor(IndexedColors.BLUE_GREY.getIndex());

            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);

            Row headerRow2 = sheet.createRow(0);
            Cell cell2 = headerRow2.createCell(0);
            cell2.setCellValue("گزارش ارزیابی واکنشی");

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
//            for (Object map : data) {
//                Row row = sheet.createRow(++rowNum);
//
//                for (int i = 0; i < columns.length; i++) {
//
//                    switch (columns[i]) {
//                        case "class_code": {
//                            row.createCell(i).setCellValue(map.getClass_code());
//                            break;
//                        }
//                        case "complex": {
//                            row.createCell(i).setCellValue(map.getComplex());
//                            break;
//                        }
//                        case "teacher_national_code": {
//                            row.createCell(i).setCellValue(map.getTeacher_national_code());
//                            break;
//                        }
//                        case "teacher": {
//                            row.createCell(i).setCellValue(map.getTeacher());
//                            break;
//                        }
//                        case "is_personnel": {
//                            row.createCell(i).setCellValue(map.getIs_personnel());
//                            break;
//                        }
//                        case "class_start_date": {
//                            row.createCell(i).setCellValue(map.getClass_start_date());
//                            break;
//                        }
//                        case "class_end_date": {
//                            row.createCell(i).setCellValue(map.getClass_end_date());
//                            break;
//                        }
//                        case "course_code": {
//                            row.createCell(i).setCellValue(map.getCourse_code());
//                            break;
//                        }
//                        case "course_titlefa": {
//                            row.createCell(i).setCellValue(map.getCourse_titlefa());
//                            break;
//                        }
//                        case "category_titlefa": {
//                            row.createCell(i).setCellValue(map.getCategory_titlefa());
//                            break;
//                        }
//                        case "sub_category_titlefa": {
//                            row.createCell(i).setCellValue(map.getSub_category_titlefa());
//                            break;
//                        }
//                        case "student": {
//                            row.createCell(i).setCellValue(map.getStudent());
//                            break;
//                        }
//                        case "class_status": {
//                            row.createCell(i).setCellValue(map.getClass_status());
//                            break;
//                        }
//
//                        case "student_per_number": {
//                            row.createCell(i).setCellValue(map.getStudent_per_number());
//                            break;
//                        } case "student_post_title": {
//                            row.createCell(i).setCellValue(map.getStudent_post_title());
//                            break;
//                        } case "student_post_code": {
//                            row.createCell(i).setCellValue(map.getStudent_post_code());
//                            break;
//                        } case "student_hoze": {
//                            row.createCell(i).setCellValue(map.getStudent_hoze());
//                            break;
//                        } case "student_omor": {
//                            row.createCell(i).setCellValue(map.getStudent_omor());
//                            break;
//                        } case "total_std": {
//                            row.createCell(i).setCellValue(map.getTotal_std());
//                            break;
//                        } case "training_grade_to_teacher": {
//                            row.createCell(i).setCellValue(map.getTraining_grade_to_teacher());
//                            break;
//                        } case "teacher_grade_to_class": {
//                            row.createCell(i).setCellValue(map.getTeacher_grade_to_class());
//                            break;
//                        } case "reactione_evaluation_grade": {
//                            row.createCell(i).setCellValue(map.getReactione_evaluation_grade());
//                            break;
//                        } case "final_teacher": {
//                            row.createCell(i).setCellValue(map.getFinal_teacher());
//                            break;
//                        }
//                    }
//
//                }
//            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            CellStyle mine = workbook.createCellStyle();
            mine.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());
            mine.setFillBackgroundColor(IndexedColors.BLUE_GREY.getIndex());
            sheet.getRow(0).setRowStyle(mine);


            FileOutputStream fileOut = new FileOutputStream(fileFullPath);
            workbook.write(fileOut);
            fileOut.close();

            File file = new File(fileFullPath);
            in = new FileInputStream(file);
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
        } finally {
            if (workbook != null) {
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
