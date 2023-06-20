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
import com.nicico.training.iservice.IPersonnelCoursePassedOrNotPaseedNAReportViewService;
import com.nicico.training.iservice.IViewTrainingFileService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.controller.utility.WordUtil.SetValueWithCheckData;

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
    private final ViewReactionEvaluationFormulaReportDAO viewReactionEvaluationFormulaReportDAO;
    private final ViewLearningEvaluationCourseReportDAO courseReportDAO;
    private final ViewLearningEvaluationStudentReportDAO studentReportDAO;
    private final IPersonnelCoursePassedOrNotPaseedNAReportViewService personnelCoursePassedOrNotPaseedNAReportViewService;
    private final ViewReactionEvaluationFormulaReportForCourseDAO daoForCourse;
    private final ViewBehavioralEvaluationFormulaReportDAO viewBehavioralEvaluationFormulaReportDAO;
    private final IViewTrainingFileService viewTrainingFileService;

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
             SetValueWithCheckData(titr,cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (HashMap<String, String> map : allData) {
                Row row = sheet.createRow(++rowNum);
                for (int i = 0; i < columns.length; i++) {
                    SetValueWithCheckData(map.get(columns[i]),row.createCell(i));
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
        String start = "";
        String end = "";
        List<Object> categoryList = new ArrayList<>();
        List<Object> subCategoryList = new ArrayList<>();
        for (int f = 0; f < criteriaRq.getCriteria().get(0).getCriteria().size(); f++) {
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classStartDate"))
                start = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classEndDate"))
                end = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("categoryTitleFa")) {
                categoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("subCategoryId")) {
                subCategoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();
            }

        }

        List<ViewReactionEvaluationFormulaReport> firstData = viewReactionEvaluationFormulaReportDAO.getAll(start, end);
        List<Object> finalCategoryList = categoryList;
        List<Object> finalSubCategoryList = subCategoryList;
        List<ViewReactionEvaluationFormulaReport> secondData;
        List<ViewReactionEvaluationFormulaReport> data;
        if (categoryList.size() > 0) {
            secondData = firstData.stream()
                    .filter(first -> finalCategoryList.stream()
                            .anyMatch(category -> first.getCategory_titlefa().equals(category)))
                    .collect(Collectors.toList());
        } else {
            secondData = firstData;
        }
        if (subCategoryList.size() > 0) {
            data = secondData.stream()
                    .filter(sec -> finalSubCategoryList.stream()
                            .anyMatch(sub -> sec.getSub_category_id().equals(Long.valueOf(sub.toString()))))
                    .collect(Collectors.toList());
        } else {
            data = secondData;
        }

        data.forEach(item -> {
            if (item.getFinal_teacher() != null) {
                item.setFinal_teacher(
                        String.valueOf(Math.round(Float.parseFloat(item.getFinal_teacher())))
                );
            }
            if (item.getReactione_evaluation_grade() != null) {
                item.setReactione_evaluation_grade(
                        String.valueOf(Math.round(Float.parseFloat(item.getReactione_evaluation_grade())))
                );
            }
            if (item.getTeacher_grade_to_class() != null) {
                item.setTeacher_grade_to_class(
                        String.valueOf(Math.round(Float.parseFloat(item.getTeacher_grade_to_class())))
                );
            }
            if (item.getTraining_grade_to_teacher() != null) {
                item.setTraining_grade_to_teacher(
                        String.valueOf(Math.round(Float.parseFloat(item.getTraining_grade_to_teacher())))
                );
            }
            if (item.getStudentEvaluation() != null) {
                item.setStudentEvaluation(
                        String.valueOf(Math.round(Float.parseFloat(item.getStudentEvaluation())))
                );
            }
        });

        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[29];
            String[] columns = new String[29];


            for (int z = 0; z < 29; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "نام فراگیر";
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
                        headers[z] = "نمره ارزیابی واکنشی فراگیر";
                        columns[z] = "student_evaluation";
                        break;
                    }
                    case 23: {
                        headers[z] = "نمره ارزیابی نهایی استاد در کلاس";
                        columns[z] = "final_teacher";
                        break;
                    }
                    case 24: {
                        headers[z] = "تعداد دانشجویان جواب داده به ارزیابی این کلاس";
                        columns[z] = "tedadJavabDade";
                        break;
                    }
                    case 25: {
                        headers[z] = "درصد مشارکت فراگیران در ارزیابی";
                        columns[z] = "percent_reaction";
                        break;
                    }
                    case 26: {
                        headers[z] = "مدرس کلاس";
                        columns[z] = "class_teacher";
                        break;
                    }
                    case 27: {
                        headers[z] = "امکانات و تجهیزات";
                        columns[z] = "facilities_equipment";
                        break;
                    }
                    case 28: {
                        headers[z] = "محتوای کلاس";
                        columns[z] = "class_content";
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
             SetValueWithCheckData("گزارش ارزیابی واکنشی",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
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
                             SetValueWithCheckData(map.getClass_code(),row.createCell(i));
                            break;
                        }
                        case "complex": {
                             SetValueWithCheckData(map.getComplex(),row.createCell(i));
                            break;
                        }
                        case "teacher_national_code": {
                             SetValueWithCheckData(map.getTeacher_national_code(),row.createCell(i));
                            break;
                        }
                        case "teacher": {
                             SetValueWithCheckData(map.getTeacher(),row.createCell(i));
                            break;
                        }
                        case "is_personnel": {
                             SetValueWithCheckData(map.getIs_personnel(),row.createCell(i));
                            break;
                        }
                        case "class_start_date": {
                             SetValueWithCheckData(map.getClass_start_date(),row.createCell(i));
                            break;
                        }
                        case "class_end_date": {
                             SetValueWithCheckData(map.getClass_end_date(),row.createCell(i));
                            break;
                        }
                        case "course_code": {
                             SetValueWithCheckData(map.getCourse_code(),row.createCell(i));
                            break;
                        }
                        case "course_titlefa": {
                             SetValueWithCheckData(map.getCourse_titlefa(),row.createCell(i));
                            break;
                        }
                        case "category_titlefa": {
                             SetValueWithCheckData(map.getCategory_titlefa(),row.createCell(i));
                            break;
                        }
                        case "sub_category_titlefa": {
                             SetValueWithCheckData(map.getSub_category_titlefa(),row.createCell(i));
                            break;
                        }
                        case "student": {
                             SetValueWithCheckData(map.getStudent(),row.createCell(i));
                            break;
                        }
                        case "class_status": {
                             SetValueWithCheckData(map.getClass_status(),row.createCell(i));
                            break;
                        }
                        case "student_evaluation": {
                             SetValueWithCheckData(map.getStudentEvaluation(),row.createCell(i));
                            break;
                        }
                        case "student_per_number": {
                             SetValueWithCheckData(map.getStudent_per_number(),row.createCell(i));
                            break;
                        }
                        case "student_post_title": {
                             SetValueWithCheckData(map.getStudent_post_title(),row.createCell(i));
                            break;
                        }
                        case "student_post_code": {
                             SetValueWithCheckData(map.getStudent_post_code(),row.createCell(i));
                            break;
                        }
                        case "student_hoze": {
                             SetValueWithCheckData(map.getStudent_hoze(),row.createCell(i));
                            break;
                        }
                        case "student_omor": {
                             SetValueWithCheckData(map.getStudent_omor(),row.createCell(i));
                            break;
                        }
                        case "total_std": {
                             SetValueWithCheckData(map.getTotal_std(),row.createCell(i));
                            break;
                        }
                        case "training_grade_to_teacher": {
                             SetValueWithCheckData(map.getTraining_grade_to_teacher(),row.createCell(i));
                            break;
                        }
                        case "teacher_grade_to_class": {
                             SetValueWithCheckData(map.getTeacher_grade_to_class(),row.createCell(i));
                            break;
                        }
                        case "reactione_evaluation_grade": {
                             SetValueWithCheckData(map.getReactione_evaluation_grade(),row.createCell(i));
                            break;
                        }
                        case "final_teacher": {
                             SetValueWithCheckData(map.getFinal_teacher(),row.createCell(i));
                            break;
                        }
                        case "tedadJavabDade": {
                             SetValueWithCheckData(map.getJavab_dade(),row.createCell(i));
                            break;
                        }
                        case "percent_reaction": {
                             SetValueWithCheckData(map.getPercent_reaction(),row.createCell(i));
                            break;
                        }
                        case "class_teacher": {
                             SetValueWithCheckData(map.getClassTeacher(),row.createCell(i));
                            break;
                        }
                        case "facilities_equipment": {
                             SetValueWithCheckData(map.getFacilitiesEquipment(),row.createCell(i));
                            break;
                        }
                        case "class_content": {
                             SetValueWithCheckData(map.getClassContent(),row.createCell(i));
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
    public void getExcelDataForUnPassedReport(final HttpServletResponse response, @RequestParam(value = "passedOrUnPassed") String passedOrUnPassed
            , @RequestParam(value = "courseCategory") String courseCategory
    ) {

        String isPassed = passedOrUnPassed.replace("\"", "");
        String catgories = courseCategory.replace("\"", "").replace("[", "").replace("]", "");
        List<Long> catIds = new ArrayList<>();
        final String[] discagem = catgories.split(",");
        for (int i = 0; i < discagem.length; i++) {
            catIds.add(Long.valueOf(discagem[i]));
        }

        List<PersonnelCoursePassedOrNotPaseedNAReportView> data = personnelCoursePassedOrNotPaseedNAReportViewService.getPassedOrUnPassed(catIds, isPassed);


        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[17];
            String[] columns = new String[17];


            for (int z = 0; z < 25; z++) {

                switch (z) {

                    case 0: {
                        headers[z] = " کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 1: {
                        headers[z] = "عنوان دوره";
                        columns[z] = "course_title_fa";
                        break;
                    }
                    case 2: {
                        headers[z] = "پرسنلی فراگیر";
                        columns[z] = "personnel_personnel_no";
                        break;
                    }
                    case 3: {
                        headers[z] = " امور فراگیر";
                        columns[z] = "personnel_cpp_affairs";
                        break;
                    }
                    case 4: {
                        headers[z] = " حوزه فراگیر";
                        columns[z] = "personnel_cpp_area";
                        break;
                    }
                    case 5: {
                        headers[z] = " معاونت فراگیر";
                        columns[z] = "personnel_cpp_assistant";

                        break;
                    }
                    case 6: {
                        headers[z] = "قسمت فراگیر";
                        columns[z] = "personnel_cpp_section";
                        break;
                    }
                    case 7: {
                        headers[z] = "عنوان دپارتمان فراگیر";
                        columns[z] = "personnel_cpp_title";
                        break;
                    }
                    case 8: {
                        headers[z] = "شرکت فراگیر";
                        columns[z] = "personnel_company_name";
                        break;
                    }
                    case 9: {
                        headers[z] = "مجتمع";
                        columns[z] = "personnel_complex_title";
                        break;
                    }
                    case 10: {
                        headers[z] = "مدرک فراگیر";
                        columns[z] = "personnel_education_level_title";
                        break;
                    }
                    case 11: {
                        headers[z] = " نام فراگیر";
                        columns[z] = "personnel_first_name";
                        break;
                    }
                    case 12: {
                        headers[z] = " نام خانوادگی فراگیر";
                        columns[z] = "personnel_last_name";
                        break;
                    }
                    case 13: {
                        headers[z] = " کد ملی فراگیر";
                        columns[z] = "personnel_national_code";
                        break;
                    }
                    case 14: {
                        headers[z] = " شماره پرسنلی 6 رقمی فراگیر";
                        columns[z] = "personnel_emp_no";
                        break;
                    }
                    case 15: {
                        headers[z] = " کد پست فراگیر";
                        columns[z] = "personnel_post_code";
                        break;
                    }
                    case 16: {
                        headers[z] = " عنوان پست فراگیر";
                        columns[z] = "personnel_post_title";
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
            if (isPassed.equals("unPassed"))
                 SetValueWithCheckData("گزارش دوره های نگذرانده پرسنل",cell2);
            else
                 SetValueWithCheckData("گزارش دوره های گذرانده پرسنل",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (PersonnelCoursePassedOrNotPaseedNAReportView map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {

                        case "course_code": {
                             SetValueWithCheckData(map.getCourseCode(),row.createCell(i));
                            break;
                        }
                        case "course_title_fa": {
                             SetValueWithCheckData(map.getCourseTitleFa(),row.createCell(i));
                            break;
                        }
                        case "personnel_personnel_no": {
                             SetValueWithCheckData(map.getPersonnelPersonnelNo(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_affairs": {
                             SetValueWithCheckData(map.getPersonnelCcpAffairs(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_area": {
                             SetValueWithCheckData(map.getPersonnelCcpArea(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_assistant": {
                             SetValueWithCheckData(map.getPersonnelCcpAssistant(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_section": {
                             SetValueWithCheckData(map.getPersonnelCcpSection(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_title": {
                             SetValueWithCheckData(map.getPersonnelCcpTitle(),row.createCell(i));
                            break;
                        }
                        case "personnel_cpp_unit": {
                             SetValueWithCheckData(map.getPersonnelCcpUnit(),row.createCell(i));
                            break;
                        }
                        case "personnel_company_name": {
                             SetValueWithCheckData(map.getPersonnelCompanyName(),row.createCell(i));
                            break;
                        }
                        case "personnel_complex_title": {
                             SetValueWithCheckData(map.getPersonnelComplexTitle(),row.createCell(i));
                            break;
                        }
                        case "personnel_education_level_title": {
                             SetValueWithCheckData(map.getPersonnelEducationLevelTitle(),row.createCell(i));
                            break;
                        }

                        case "personnel_first_name": {
                             SetValueWithCheckData(map.getPersonnelFirstName(),row.createCell(i));
                            break;
                        }
                        case "personnel_last_name": {
                             SetValueWithCheckData(map.getPersonnelLastName(),row.createCell(i));
                            break;
                        }
                        case "personnel_national_code": {
                             SetValueWithCheckData(map.getPersonnelNationalCode(),row.createCell(i));
                            break;
                        }
                        case "personnel_emp_no": {
                             SetValueWithCheckData(map.getPersonnelPersonnelNo2(),row.createCell(i));
                            break;
                        }
                        case "personnel_post_code": {
                             SetValueWithCheckData(map.getPersonnelPostCode(),row.createCell(i));
                            break;
                        }
                        case "personnel_post_title": {
                             SetValueWithCheckData(map.getPersonnelPostTitle(),row.createCell(i));
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

    @PostMapping(value = {"/excel/formula2"})
    public void getExcelDataForFormulaReport2(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {


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
        String start = "";
        String end = "";
        List<Object> categoryList = new ArrayList<>();
        List<Object> subCategoryList = new ArrayList<>();
        for (int f = 0; f < criteriaRq.getCriteria().get(0).getCriteria().size(); f++) {
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classStartDate"))
                start = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("classEndDate"))
                end = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("categoryTitleFa")) {
                categoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("subCategoryId")) {
                subCategoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue();
            }

        }

        List<ViewReactionEvaluationFormulaReportForCourse> firstData = daoForCourse.getAllForCourse(start, end);


        List<Object> finalCategoryList = categoryList;
        List<Object> finalSubCategoryList = subCategoryList;
        List<ViewReactionEvaluationFormulaReportForCourse> secondData;
        List<ViewReactionEvaluationFormulaReportForCourse> data;
        if (categoryList.size() > 0) {
            secondData = firstData.stream()
                    .filter(first -> finalCategoryList.stream()
                            .anyMatch(category -> first.getCategory_titlefa().equals(category)))
                    .collect(Collectors.toList());
        } else {
            secondData = firstData;
        }
        if (subCategoryList.size() > 0) {
            data = secondData.stream()
                    .filter(sec -> finalSubCategoryList.stream()
                            .anyMatch(sub -> sec.getSub_category_id().equals(Long.valueOf(sub.toString()))))
                    .collect(Collectors.toList());
        } else {
            data = secondData;
        }

        data.forEach(item -> {
            if (item.getFinal_teacher() != null) {
                item.setFinal_teacher(
                        String.valueOf(Math.round(Float.parseFloat(item.getFinal_teacher())))
                );
            }
            if (item.getReactione_evaluation_grade() != null) {
                item.setReactione_evaluation_grade(
                        String.valueOf(Math.round(Float.parseFloat(item.getReactione_evaluation_grade())))
                );
            }
            if (item.getTeacher_grade_to_class() != null) {
                item.setTeacher_grade_to_class(
                        String.valueOf(Math.round(Float.parseFloat(item.getTeacher_grade_to_class())))
                );
            }
            if (item.getTraining_grade_to_teacher() != null) {
                item.setTraining_grade_to_teacher(
                        String.valueOf(Math.round(Float.parseFloat(item.getTraining_grade_to_teacher())))
                );
            }
        });

        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[22];
            String[] columns = new String[22];


            for (int z = 0; z < 22; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = " کد کلاس";
                        columns[z] = "class_code";

                        break;
                    }
                    case 1: {
                        headers[z] = "مجتمع کلاس";
                        columns[z] = "complex";
                        break;
                    }
                    case 2: {
                        headers[z] = "تاریخ شروع کلاس";
                        columns[z] = "class_start_date";
                        break;
                    }
                    case 3: {
                        headers[z] = "تاریخ انتهای کلاس";
                        columns[z] = "class_end_date";
                        break;
                    }
                    case 4: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "class_status";
                        break;
                    }
                    case 5: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 6: {
                        headers[z] = "کد ملی استاد";
                        columns[z] = "teacher_national_code";
                        break;
                    }
                    case 7: {
                        headers[z] = "نوع استاد";
                        columns[z] = "is_personnel";
                        break;
                    }
                    case 8: {
                        headers[z] = "کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 9: {
                        headers[z] = "عنوان دوره";
                        columns[z] = "course_titlefa";
                        break;
                    }
                    case 10: {
                        headers[z] = "گروه";
                        columns[z] = "category_titlefa";
                        break;
                    }
                    case 11: {
                        headers[z] = "زیرگروه";
                        columns[z] = "sub_category_titlefa";
                        break;
                    }
                    case 12: {
                        headers[z] = "تعداد فراگیر این کلاس";
                        columns[z] = "total_std";
                        break;
                    }
                    case 13: {
                        headers[z] = "ارزیابی مسئول آموزش از استاد";
                        columns[z] = "training_grade_to_teacher";
                        break;
                    }
                    case 14: {
                        headers[z] = "ارزیابی استاد از کلاس";
                        columns[z] = "teacher_grade_to_class";
                        break;
                    }
                    case 15: {
                        headers[z] = "میانگین ارزیابی واکنشی فراگیران کلاس";
                        columns[z] = "reactione_evaluation_grade";
                        break;
                    }
                    case 16: {
                        headers[z] = "نمره ارزیابی نهایی استاد در کلاس";
                        columns[z] = "final_teacher";
                        break;
                    }
                    case 17: {
                        headers[z] = "تعداد دانشجویان جواب داده به ارزیابی این کلاس";
                        columns[z] = "tedadJavabDade";
                        break;
                    }
                    case 18: {
                        headers[z] = "درصد مشارکت فراگیران در ارزیابی";
                        columns[z] = "percent_reaction";
                        break;
                    }
                    case 19: {
                        headers[z] = "مدرس کلاس";
                        columns[z] = "class_teacher";
                        break;
                    }
                    case 20: {
                        headers[z] = "امکانات و تجهیزات";
                        columns[z] = "facilities_equipment";
                        break;
                    }
                    case 21: {
                        headers[z] = "محتوای کلاس";
                        columns[z] = "class_content";
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
             SetValueWithCheckData("گزارش ارزیابی واکنشی",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (ViewReactionEvaluationFormulaReportForCourse map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {
                        case "class_code": {
                             SetValueWithCheckData(map.getClass_code(),row.createCell(i));
                            break;
                        }
                        case "complex": {
                             SetValueWithCheckData(map.getComplex(),row.createCell(i));
                            break;
                        }
                        case "teacher_national_code": {
                             SetValueWithCheckData(map.getTeacher_national_code(),row.createCell(i));
                            break;
                        }
                        case "teacher": {
                             SetValueWithCheckData(map.getTeacher(),row.createCell(i));
                            break;
                        }
                        case "is_personnel": {
                             SetValueWithCheckData(map.getIs_personnel(),row.createCell(i));
                            break;
                        }
                        case "class_start_date": {
                             SetValueWithCheckData(map.getClass_start_date(),row.createCell(i));
                            break;
                        }
                        case "class_end_date": {
                             SetValueWithCheckData(map.getClass_end_date(),row.createCell(i));
                            break;
                        }
                        case "course_code": {
                             SetValueWithCheckData(map.getCourse_code(),row.createCell(i));
                            break;
                        }
                        case "course_titlefa": {
                             SetValueWithCheckData(map.getCourse_titlefa(),row.createCell(i));
                            break;
                        }
                        case "category_titlefa": {
                             SetValueWithCheckData(map.getCategory_titlefa(),row.createCell(i));
                            break;
                        }
                        case "sub_category_titlefa": {
                             SetValueWithCheckData(map.getSub_category_titlefa(),row.createCell(i));
                            break;
                        }

                        case "class_status": {
                             SetValueWithCheckData(map.getClass_status(),row.createCell(i));
                            break;
                        }

                        case "total_std": {
                             SetValueWithCheckData(map.getTotal_std(),row.createCell(i));
                            break;
                        }
                        case "training_grade_to_teacher": {
                             SetValueWithCheckData(map.getTraining_grade_to_teacher(),row.createCell(i));
                            break;
                        }
                        case "teacher_grade_to_class": {
                             SetValueWithCheckData(map.getTeacher_grade_to_class(),row.createCell(i));
                            break;
                        }
                        case "reactione_evaluation_grade": {
                             SetValueWithCheckData(map.getReactione_evaluation_grade(),row.createCell(i));
                            break;
                        }
                        case "final_teacher": {
                             SetValueWithCheckData(map.getFinal_teacher(),row.createCell(i));
                            break;
                        }
                        case "tedadJavabDade": {
                             SetValueWithCheckData(map.getJavab_dade(),row.createCell(i));
                            break;
                        }
                        case "percent_reaction": {
                             SetValueWithCheckData(map.getPercent_reaction(),row.createCell(i));
                            break;
                        }
                        case "class_teacher": {
                             SetValueWithCheckData(map.getClassTeacher(),row.createCell(i));
                            break;
                        }
                        case "facilities_equipment": {
                             SetValueWithCheckData(map.getFacilitiesEquipment(),row.createCell(i));
                            break;
                        }
                        case "class_content": {
                             SetValueWithCheckData(map.getClassContent(),row.createCell(i));
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

    @PostMapping(value = {"/excel/formula2/learning"})
    public void getExcelDataForFormulaReportLearning(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {


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

        String startFrom = null;
        String startTo = null;
        String endFrom = null;
        String endTo = null;
        String classYear = null;
        String teachingMethod = null;
        String institute = null;
        Long teacherId = null;

        List<String> classCodeList = null;
        List<String> complexList = null;
        List<String> assistantList = null;
        List<String> affairList = null;
        List<Long> categoryList = null;
        List<Long> subCategoryList = null;
        List<Long> termIds = null;

        for (int f = 0; f < criteriaRq.getCriteria().get(0).getCriteria().size(); f++) {
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerComplex")) {
                complexList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerAssistant")) {
                assistantList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerAffairs")) {
                affairList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }

            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassCode")) {
                classCodeList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("startDate1")) {
                startFrom = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("startDate2")) {
                startTo = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("endDate1")) {
                endFrom = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("endDate2")) {
                endTo = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("categoryId")) {
                categoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
                ;
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("subCategoryId")) {
                subCategoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
                ;
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassYear")) {
                classYear = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("termId")) {
                termIds = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("teacherId")) {
                teacherId = Long.parseLong(criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassOrganizerId")) {
                institute = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassTeachingType")) {
                teachingMethod = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }

        }

        int complexNullCheck = (complexList == null) ? 1 : 0;
        int moavenatNullCheck = (assistantList == null) ? 1 : 0;
        int omorNullCheck = (affairList == null) ? 1 : 0;
        int classCodeNullCheck = (classCodeList == null) ? 1 : 0;
        int categoryNullCheck = (categoryList == null) ? 1 : 0;
        int subCategoryNullCheck = (subCategoryList == null) ? 1 : 0;
        int termIdNullCheck = (termIds == null) ? 1 : 0;
        int teacherIdNullCheck = (teacherId == null) ? 1 : 0;

        if (complexList == null) {
            complexList = new ArrayList<>();
            complexList.add("");
        }

        if (assistantList == null) {
            assistantList = new ArrayList<>();
            assistantList.add("");
        }

        if (affairList == null) {
            affairList = new ArrayList<>();
            affairList.add("");
        }


        if (classCodeList == null) {
            classCodeList = new ArrayList<>();
            classCodeList.add("");
        }

        if (termIds == null) {
            termIds = new ArrayList<>();
            termIds.add(-1L);
        }

        if (categoryList == null) {
            categoryList = new ArrayList<>();
            categoryList.add(-1L);
        }

        if (subCategoryList == null) {
            subCategoryList = new ArrayList<>();
            subCategoryList.add(-1L);
        }

        if (teacherId == null) {
            teacherId = -1L;
        }

        List<ViewLearningEvaluationCourseReport> data = courseReportDAO.findAllByFilters(
                complexList,
                complexNullCheck,
                assistantList,
                moavenatNullCheck,
                affairList,
                omorNullCheck,
                classCodeList,
                classCodeNullCheck,
                startFrom, startTo, endFrom, endTo,
                categoryList,
                categoryNullCheck,
                subCategoryList,
                subCategoryNullCheck,
                classYear,
                termIds,
                termIdNullCheck,
                teacherId,
                teacherIdNullCheck,
                institute,
                teachingMethod
        );

        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[25];
            String[] columns = new String[25];


            for (int z = 0; z < 25; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "کد درس";
                        columns[z] = "class_code";
                        break;
                    }
                    case 1: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "class_status";
                        break;
                    }
                    case 2: {
                        headers[z] = "شروع کلاس";
                        columns[z] = "class_start_date";
                        break;
                    }
                    case 3: {
                        headers[z] = "انتهای کلاس";
                        columns[z] = "class_end_date";
                        break;
                    }
                    case 4: {
                        headers[z] = " کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 5: {
                        headers[z] = " عنوان دوره";
                        columns[z] = "course_titlefa";
                        break;
                    }
                    case 6: {
                        headers[z] = " گروه";
                        columns[z] = "category_titlefa";

                        break;
                    }
                    case 7: {
                        headers[z] = " زیر گروه";
                        columns[z] = "sub_category_titlefa";
                        break;
                    }
                    case 8: {
                        headers[z] = "مجتمع کلاس";
                        columns[z] = "complex";
                        break;
                    }
                    case 9: {
                        headers[z] = "نوع استاد";
                        columns[z] = "is_personnel";
                        break;
                    }
                    case 10: {
                        headers[z] = "کد ملی استاد";
                        columns[z] = "teacher_national_code";
                        break;
                    }
                    case 11: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 12: {
                        headers[z] = "تعداد دانشجویان کلاس";
                        columns[z] = "total_std";
                        break;
                    }
                    case 13: {
                        headers[z] = "میانگین پیش تست";
                        columns[z] = "miangin_pretest";
                        break;
                    }
                    case 14: {
                        headers[z] = "میانگین  تست اصلی";
                        columns[z] = "miangin_asli";
                        break;
                    }
                    case 15: {
                        headers[z] = "نرخ یادگیری";
                        columns[z] = "nerkh";
                        break;
                    }
                    case 16: {
                        headers[z] = "درصد جواب داده به آزمون اصلی";
                        columns[z] = "darsad_javab_dade_asli";
                        break;
                    }
                    case 17: {
                        headers[z] = "درصد جواب داده به پیش تست";
                        columns[z] = "darsad_javab_dade_pre";
                        break;
                    }
                    case 18: {
                        headers[z] = "درصد قبول شده";
                        columns[z] = "darsad_ghabol";
                        break;
                    }
                    case 19: {
                        headers[z] = "درصد قبول نشده";
                        columns[z] = "darsad_noghabol";
                        break;
                    }
                    case 20: {
                        headers[z] = "نمره یادگیری کلاس";
                        columns[z] = "learning";
                        break;
                    }
                    case 21: {
                        headers[z] = "بیشترین نمره آزمون نهایی";
                        columns[z] = "max_nahaii";
                        break;
                    }
                    case 22: {
                        headers[z] = "کمترین نمره آزمون پیش تست";
                        columns[z] = "min_pre";
                        break;
                    }
                    case 23: {
                        headers[z] = "درصد پیشرفت";
                        columns[z] = "pishraft";
                        break;
                    }
                    case 24: {
                        headers[z] = "فرم های تکمیلی ارزیابی واکنشی(%)";
                        columns[z] = "percent_reaction";
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
             SetValueWithCheckData("گزارش ارزیابی یادگیری",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (ViewLearningEvaluationCourseReport map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {
                        case "class_code": {
                             SetValueWithCheckData(map.getClass_code(),row.createCell(i));
                            break;
                        }
                        case "complex": {
                             SetValueWithCheckData(map.getComplex(),row.createCell(i));
                            break;
                        }
                        case "teacher_national_code": {
                             SetValueWithCheckData(map.getTeacher_national_code(),row.createCell(i));
                            break;
                        }
                        case "teacher": {
                             SetValueWithCheckData(map.getTeacher(),row.createCell(i));
                            break;
                        }
                        case "is_personnel": {
                             SetValueWithCheckData(map.getIs_personnel(),row.createCell(i));
                            break;
                        }
                        case "class_start_date": {
                             SetValueWithCheckData(map.getStartDate(),row.createCell(i));
                            break;
                        }
                        case "class_end_date": {
                             SetValueWithCheckData(map.getEndDate(),row.createCell(i));
                            break;
                        }
                        case "course_code": {
                             SetValueWithCheckData(map.getCourse_code(),row.createCell(i));
                            break;
                        }
                        case "course_titlefa": {
                             SetValueWithCheckData(map.getCourse_titlefa(),row.createCell(i));
                            break;
                        }
                        case "category_titlefa": {
                             SetValueWithCheckData(map.getCategory_titlefa(),row.createCell(i));
                            break;
                        }
                        case "sub_category_titlefa": {
                             SetValueWithCheckData(map.getSub_category_titlefa(),row.createCell(i));
                            break;
                        }

                        case "class_status": {
                             SetValueWithCheckData(map.getClass_status(),row.createCell(i));
                            break;
                        }

                        case "total_std": {
                             SetValueWithCheckData(map.getTotal_std(),row.createCell(i));
                            break;
                        }
                        case "miangin_pretest": {
                            String pish = "0";
                            if (map.getMiangin_pretest() != null)
                                pish = map.getMiangin_pretest();
                             SetValueWithCheckData(pish,row.createCell(i));
                            break;
                        }
                        case "miangin_asli": {
                             SetValueWithCheckData(map.getMiangin_asli(),row.createCell(i));
                            break;
                        }
                        case "nerkh": {
                             SetValueWithCheckData(map.getNerkh(),row.createCell(i));
                            break;
                        }
                        case "darsad_javab_dade_asli": {
                             SetValueWithCheckData(map.getDarsad_javab_dade_asli(),row.createCell(i));
                            break;
                        }
                        case "darsad_javab_dade_pre": {
                             SetValueWithCheckData(map.getDarsad_javab_dade_pre(),row.createCell(i));
                            break;
                        }
                        case "darsad_ghabol": {
                             SetValueWithCheckData(map.getDarsad_ghabol(),row.createCell(i));
                            break;
                        }
                        case "darsad_noghabol": {
                             SetValueWithCheckData(map.getDarsad_noghabol(),row.createCell(i));
                            break;
                        }
                        case "learning": {
                             SetValueWithCheckData(map.getLearning(),row.createCell(i));
                            break;
                        }
                        case "max_nahaii": {
                             SetValueWithCheckData(map.getMax_nahaii(),row.createCell(i));
                            break;
                        }
                        case "min_pre": {
                             SetValueWithCheckData(map.getMin_pre(),row.createCell(i));
                            break;
                        }
                        case "pishraft": {
                             SetValueWithCheckData(map.getPishraft(),row.createCell(i));
                            break;
                        }
                        case "percent_reaction": {
                             SetValueWithCheckData(map.getPercent_reaction(),row.createCell(i));
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


    @PostMapping(value = {"/excel/formula/learning"})
    public void getExcelDataForFormula2ReportLearning(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {
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

        String startFrom = null;
        String startTo = null;
        String endFrom = null;
        String endTo = null;
        String classYear = null;
        String teachingMethod = null;
        String institute = null;
        Long teacherId = null;

        List<String> classCodeList = null;
        List<String> complexList = null;
        List<String> assistantList = null;
        List<String> affairList = null;
        List<String> plannerUnitList = null;
        List<String> plannerSectionList = null;
        List<Long> categoryList = null;
        List<Long> subCategoryList = null;
        List<Long> termIds = null;

        for (int f = 0; f < criteriaRq.getCriteria().get(0).getCriteria().size(); f++) {
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerComplex")) {
                complexList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerAssistant")) {
                assistantList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerAffairs")) {
                affairList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerSection")) {
                plannerSectionList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("plannerUnit")) {
                plannerUnitList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassCode")) {
                classCodeList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(Objects::toString).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("startDate1")) {
                startFrom = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("startDate2")) {
                startTo = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("endDate1")) {
                endFrom = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("endDate2")) {
                endTo = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("categoryId")) {
                categoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
                ;
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("subCategoryId")) {
                subCategoryList = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
                ;
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassYear")) {
                classYear = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("termId")) {
                termIds = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("teacherId")) {
                teacherId = Long.parseLong(criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassOrganizerId")) {
                institute = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(f).getFieldName().equals("tclassTeachingType")) {
                teachingMethod = criteriaRq.getCriteria().get(0).getCriteria().get(f).getValue().get(0).toString();
            }

        }

        int complexNullCheck = (complexList == null) ? 1 : 0;
        int moavenatNullCheck = (assistantList == null) ? 1 : 0;
        int omorNullCheck = (affairList == null) ? 1 : 0;
        int ghesmatNullCheck = (plannerSectionList == null) ? 1 : 0;
        int vahedNullCheck = (plannerUnitList == null) ? 1 : 0;
        int classCodeNullCheck = (classCodeList == null) ? 1 : 0;
        int categoryNullCheck = (categoryList == null) ? 1 : 0;
        int subCategoryNullCheck = (subCategoryList == null) ? 1 : 0;
        int termIdNullCheck = (termIds == null) ? 1 : 0;
        int teacherIdNullCheck = (teacherId == null) ? 1 : 0;

        if (complexList == null) {
            complexList = new ArrayList<>();
            complexList.add("");
        }

        if (assistantList == null) {
            assistantList = new ArrayList<>();
            assistantList.add("");
        }

        if (affairList == null) {
            affairList = new ArrayList<>();
            affairList.add("");
        }

        if (plannerSectionList == null) {
            plannerSectionList = new ArrayList<>();
            plannerSectionList.add("");
        }

        if (plannerUnitList == null) {
            plannerUnitList = new ArrayList<>();
            plannerUnitList.add("");
        }

        if (classCodeList == null) {
            classCodeList = new ArrayList<>();
            classCodeList.add("");
        }

        if (termIds == null) {
            termIds = new ArrayList<>();
            termIds.add(-1L);
        }

        if (categoryList == null) {
            categoryList = new ArrayList<>();
            categoryList.add(-1L);
        }

        if (subCategoryList == null) {
            subCategoryList = new ArrayList<>();
            subCategoryList.add(-1L);
        }

        if (teacherId == null) {
            teacherId = -1L;
        }

        List<ViewLearningEvaluationStudentReport> data = studentReportDAO.findAllByFilters(
                complexList,
                complexNullCheck,
                assistantList,
                moavenatNullCheck,
                affairList,
                omorNullCheck,
                plannerSectionList,
                ghesmatNullCheck,
                plannerUnitList,
                vahedNullCheck,
                classCodeList,
                classCodeNullCheck,
                startFrom, startTo, endFrom, endTo,
                categoryList,
                categoryNullCheck,
                subCategoryList,
                subCategoryNullCheck,
                classYear,
                termIds,
                termIdNullCheck,
                teacherId,
                teacherIdNullCheck,
                institute,
                teachingMethod
        );

        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {

            String[] headers = new String[25];
            String[] columns = new String[25];


            for (int z = 0; z < 25; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "کد درس";
                        columns[z] = "class_code";
                        break;
                    }
                    case 1: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "class_status";
                        break;
                    }
                    case 2: {
                        headers[z] = "شروع کلاس";
                        columns[z] = "class_start_date";
                        break;
                    }
                    case 3: {
                        headers[z] = "انتهای کلاس";
                        columns[z] = "class_end_date";
                        break;
                    }
                    case 4: {
                        headers[z] = " کد دوره";
                        columns[z] = "course_code";
                        break;
                    }
                    case 5: {
                        headers[z] = " عنوان دوره";
                        columns[z] = "course_titlefa";
                        break;
                    }
                    case 6: {
                        headers[z] = " گروه";
                        columns[z] = "category_titlefa";

                        break;
                    }
                    case 7: {
                        headers[z] = " زیر گروه";
                        columns[z] = "sub_category_titlefa";
                        break;
                    }
                    case 8: {
                        headers[z] = "مجتمع کلاس";
                        columns[z] = "complex";
                        break;
                    }
                    case 9: {
                        headers[z] = "نوع استاد";
                        columns[z] = "is_personnel";
                        break;
                    }
                    case 10: {
                        headers[z] = "کد ملی استاد";
                        columns[z] = "teacher_national_code";
                        break;
                    }
                    case 11: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 12: {
                        headers[z] = "تعداد دانشجویان کلاس";
                        columns[z] = "total_std";
                        break;
                    }


                    case 13: {
                        headers[z] = "فراگیر";
                        columns[z] = "student";
                        break;
                    }
                    case 14: {
                        headers[z] = "کد ملی فراگیر";
                        columns[z] = "student_national_code";
                        break;
                    }
                    case 15: {
                        headers[z] = "۶ رقمی فراگیر";
                        columns[z] = "emp_no";
                        break;
                    }
                    case 16: {
                        headers[z] = "پرسنلی فراگیر";
                        columns[z] = "personnel_no";
                        break;
                    }
                    case 17: {
                        headers[z] = "حوزه فراگیر";
                        columns[z] = "student_hoze";
                        break;
                    }
                    case 18: {
                        headers[z] = "امور فراگیر";
                        columns[z] = "student_omor";
                        break;
                    }
                    case 19: {
                        headers[z] = "کد پست فراگیر";
                        columns[z] = "student_post_code";
                        break;
                    }
                    case 20: {
                        headers[z] = "پست فراگیر";
                        columns[z] = "student_post_title";
                        break;
                    }
                    case 21: {
                        headers[z] = "نمره پیش تست";
                        columns[z] = "nore_pish";
                        break;
                    }
                    case 22: {
                        headers[z] = "نمره نهایی";
                        columns[z] = "nore_nahaii";
                        break;
                    }
                    case 23: {
                        headers[z] = "نمره یادگیری ";
                        columns[z] = "learning";
                        break;
                    }
                    case 24: {
                        headers[z] = "فرم های تکمیلی ارزیابی واکنشی(%)";
                        columns[z] = "percent_reaction";
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
             SetValueWithCheckData("گزارش ارزیابی یادگیری",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (ViewLearningEvaluationStudentReport map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {
                        case "class_code": {
                             SetValueWithCheckData(map.getClass_code(),row.createCell(i));
                            break;
                        }
                        case "complex": {
                             SetValueWithCheckData(map.getComplex(),row.createCell(i));
                            break;
                        }
                        case "teacher_national_code": {
                             SetValueWithCheckData(map.getTeacher_national_code(),row.createCell(i));
                            break;
                        }
                        case "teacher": {
                             SetValueWithCheckData(map.getTeacher(),row.createCell(i));
                            break;
                        }
                        case "is_personnel": {
                             SetValueWithCheckData(map.getIs_personnel(),row.createCell(i));
                            break;
                        }
                        case "class_start_date": {
                             SetValueWithCheckData(map.getStartDate(),row.createCell(i));
                            break;
                        }
                        case "class_end_date": {
                             SetValueWithCheckData(map.getEndDate(),row.createCell(i));
                            break;
                        }
                        case "course_code": {
                             SetValueWithCheckData(map.getCourse_code(),row.createCell(i));
                            break;
                        }
                        case "course_titlefa": {
                             SetValueWithCheckData(map.getCourse_titlefa(),row.createCell(i));
                            break;
                        }
                        case "category_titlefa": {
                             SetValueWithCheckData(map.getCategory_titlefa(),row.createCell(i));
                            break;
                        }
                        case "sub_category_titlefa": {
                             SetValueWithCheckData(map.getSub_category_titlefa(),row.createCell(i));
                            break;
                        }

                        case "class_status": {
                             SetValueWithCheckData(map.getClass_status(),row.createCell(i));
                            break;
                        }

                        case "total_std": {
                             SetValueWithCheckData(map.getTotal_std(),row.createCell(i));
                            break;
                        }
                        case "student": {
                             SetValueWithCheckData(map.getStudent(),row.createCell(i));
                            break;
                        }
                        case "student_national_code": {
                             SetValueWithCheckData(map.getStudent_per_number(),row.createCell(i));
                            break;
                        }
                        case "emp_no": {
                             SetValueWithCheckData(map.getEmp_no(),row.createCell(i));
                            break;
                        }
                        case "personnel_no": {
                             SetValueWithCheckData(map.getPersonnel_no(),row.createCell(i));
                            break;
                        }
                        case "student_hoze": {
                             SetValueWithCheckData(map.getStudent_hoze(),row.createCell(i));
                            break;
                        }
                        case "student_omor": {
                             SetValueWithCheckData(map.getStudent_omor(),row.createCell(i));
                            break;
                        }
                        case "student_post_code": {
                             SetValueWithCheckData(map.getStudent_post_code(),row.createCell(i));
                            break;
                        }
                        case "student_post_title": {
                             SetValueWithCheckData(map.getStudent_post_title(),row.createCell(i));
                            break;
                        }
                        case "nore_pish": {
                            String pish = "0";
                            if (map.getNore_pish() != null)
                                pish = map.getNore_pish();
                             SetValueWithCheckData(pish,row.createCell(i));
                            break;
                        }
                        case "nore_nahaii": {
                             SetValueWithCheckData(map.getNore_nahaii(),row.createCell(i));
                            break;
                        }
                        case "learning": {
                             SetValueWithCheckData(map.getLearning(),row.createCell(i));
                            break;
                        }
                        case "percent_reaction": {
                             SetValueWithCheckData(map.getPercent_reaction(),row.createCell(i));
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

    @PostMapping(value = {"/formula/behavioral/{type}"})
    public void getExcelDataForCourseBehavioralFormulaReport(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria, @PathVariable String type) throws Exception {
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

        String startDate = null;
        String endDate = null;
        String classCode = null;
        List<Long> categoryList = null;
        List<Long> subCategoryList = null;

        for (int i = 0; i < criteriaRq.getCriteria().get(0).getCriteria().size(); i++) {
            if (criteriaRq.getCriteria().get(0).getCriteria().get(i).getFieldName().equals("classStartDate"))
                startDate = criteriaRq.getCriteria().get(0).getCriteria().get(i).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(i).getFieldName().equals("classEndDate"))
                endDate = criteriaRq.getCriteria().get(0).getCriteria().get(i).getValue().get(0).toString();
            if (criteriaRq.getCriteria().get(0).getCriteria().get(i).getFieldName().equals("categoryId")) {
                categoryList = criteriaRq.getCriteria().get(0).getCriteria().get(i).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(i).getFieldName().equals("subCategoryId")) {
                subCategoryList = criteriaRq.getCriteria().get(0).getCriteria().get(i).getValue().stream().map(o -> Long.parseLong(o.toString())).collect(Collectors.toList());
            }
            if (criteriaRq.getCriteria().get(0).getCriteria().get(i).getFieldName().equals("classCode")) {
                classCode = criteriaRq.getCriteria().get(0).getCriteria().get(i).getValue().get(0).toString();
            }

        }

        int catsNullCheck = categoryList == null ? 1 : 0;
        int subCatsNullCheck = subCategoryList == null ? 1 : 0;
        int classCodeNullCheck = classCode == null ? 1 : 0;

        if (categoryList == null) {
            categoryList = new ArrayList<>();
            categoryList.add(-1L);
        }

        if (subCategoryList == null) {
            subCategoryList = new ArrayList<>();
            subCategoryList.add(-1L);
        }

        List<ViewBehavioralEvaluationFormulaReport> list = viewBehavioralEvaluationFormulaReportDAO
                .getAllByAllParams(startDate, endDate, categoryList, catsNullCheck, subCategoryList, subCatsNullCheck, classCode, classCodeNullCheck);

        if (type.equals("excel")) {
            String fileFullPath = "export.xlsx";
            Workbook workbook = null;
            FileInputStream in = null;
            try {
                String[] headers = new String[32];
                String[] columns = new String[32];

                for (int z = 0; z < 32; z++) {
                    switch (z) {
                        case 0 -> {
                            headers[z] = "شماره پرسنلی فراگیر(ارزیابی شونده)";
                            columns[z] = "student_per_number";
                        }
                        case 1 -> {
                            headers[z] = "شماره پرسنلی ارزیابی کننده";
                            columns[z] = "evaluator_per_number";
                        }
                        case 2 -> {
                            headers[z] = "فراگیر(ارزیابی شونده)";
                            columns[z] = "student";
                        }
                        case 3 -> {
                            headers[z] = "کد ملی فراگیر(ارزیابی شونده)";
                            columns[z] = "student_national_code";
                        }
                        case 4 -> {
                            headers[z] = "ارزیابی کننده";
                            columns[z] = "evaluator_name";
                        }
                        case 5 -> {
                            headers[z] = "کد ملی ارزیابی کننده";
                            columns[z] = "evaluator_national_code";
                        }
                        case 6 -> {
                            headers[z] = "نوع ارزیاب";
                            columns[z] = "evaluator_type";
                        }
                        case 7 -> {
                            headers[z] = "کد پست فراگیر(ارزیابی شونده)";
                            columns[z] = "student_post_code";
                        }
                        case 8 -> {
                            headers[z] = "کد پست ارزیابی کننده";
                            columns[z] = "evaluator_post_code";
                        }
                        case 9 -> {
                            headers[z] = "عنوان پست فراگیر(ارزیابی شونده)";
                            columns[z] = "student_post_title";
                        }
                        case 10 -> {
                            headers[z] = "عنوان پست ارزیابی کننده";
                            columns[z] = "evaluator_post_title";
                        }
                        case 11 -> {
                            headers[z] = "حوزه فراگیر(ارزیابی شونده)";
                            columns[z] = "student_hoze";
                        }
                        case 12 -> {
                            headers[z] = "حوزه ارزیابی کننده";
                            columns[z] = "evaluator_hoze";
                        }
                        case 13 -> {
                            headers[z] = "امور فراگیر(ارزیابی شونده)";
                            columns[z] = "student_omor";
                        }
                        case 14 -> {
                            headers[z] = "امور ارزیابی کننده";
                            columns[z] = "evaluator_omor";
                        }
                        case 15 -> {
                            headers[z] = "کد کلاس";
                            columns[z] = "class_code";
                        }
                        case 16 -> {
                            headers[z] = "مجتمع کلاس";
                            columns[z] = "complex";
                        }
                        case 17 -> {
                            headers[z] = "مسئول اجرای کلاس";
                            columns[z] = "class_supervisor";
                        }
                        case 18 -> {
                            headers[z] = "تاریخ شروع کلاس";
                            columns[z] = "class_start_date";
                        }
                        case 19 -> {
                            headers[z] = "تاریخ انتهای کلاس";
                            columns[z] = "class_end_date";
                        }
                        case 20 -> {
                            headers[z] = "وضعیت کلاس";
                            columns[z] = "class_status";
                        }
                        case 21 -> {
                            headers[z] = "استاد";
                            columns[z] = "teacher";
                        }
                        case 22 -> {
                            headers[z] = "کد ملی استاد";
                            columns[z] = "teacher_national_code";
                        }
                        case 23 -> {
                            headers[z] = "نوع استاد";
                            columns[z] = "is_personnel";
                        }
                        case 24 -> {
                            headers[z] = "کد دوره";
                            columns[z] = "course_code";
                        }
                        case 25 -> {
                            headers[z] = "عنوان دوره";
                            columns[z] = "course_titlefa";
                        }
                        case 26 -> {
                            headers[z] = "گروه";
                            columns[z] = "category_titlefa";
                        }
                        case 27 -> {
                            headers[z] = "زیرگروه";
                            columns[z] = "sub_category_titlefa";
                        }
                        case 28 -> {
                            headers[z] = "تعداد فراگیر این کلاس";
                            columns[z] = "total_std";
                        }
                        case 29 -> {
                            headers[z] = "نمره ارزیابی داده شده به فراگیر";
                            columns[z] = "std_score";
                        }
                        case 30 -> {
                            headers[z] = "میانگین نمرات داده شده به فراگیر";
                            columns[z] = "std_avg_score";
                        }
                        case 31 -> {
                            headers[z] = "حد قابل قبول ارزیابی رفتاری";
                            columns[z] = "acc_score_limit";
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
                 SetValueWithCheckData("گزارش ارزیابی رفتاری",cell2);

                sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

                Row headerRow = sheet.createRow(1);

                for (int i = 0; i < columns.length; i++) {
                    Cell cell = headerRow.createCell(i);
                     SetValueWithCheckData(headers[i],cell);
                    cell.setCellStyle(headerCellStyle);
                }

                CellStyle dateCellStyle = workbook.createCellStyle();
                dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

                int rowNum = 1;
                for (ViewBehavioralEvaluationFormulaReport map : list) {
                    Row row = sheet.createRow(++rowNum);

                    for (int i = 0; i < columns.length; i++) {
                        switch (columns[i]) {
                            case "student_per_number" ->  SetValueWithCheckData(map.getEvaluatedPersonnelNo(),row.createCell(i));
                            case "evaluator_per_number" ->  SetValueWithCheckData(map.getEvaluatorPersonnelNo(),row.createCell(i));
                            case "student" ->  SetValueWithCheckData(map.getEvaluatedName(),row.createCell(i));
                            case "student_national_code" ->  SetValueWithCheckData(map.getEvaluatedNationalCode(),row.createCell(i));
                            case "evaluator_name" ->  SetValueWithCheckData(map.getEvaluatorName(),row.createCell(i));
                            case "evaluator_national_code" ->  SetValueWithCheckData(map.getEvaluatorNationalCode(),row.createCell(i));
                            case "evaluator_type" ->  SetValueWithCheckData(map.getEvaluatorType(),row.createCell(i));
                            case "student_post_code" ->  SetValueWithCheckData(map.getEvaluatedPostCode(),row.createCell(i));
                            case "evaluator_post_code" ->  SetValueWithCheckData(map.getEvaluatorPostCode(),row.createCell(i));
                            case "student_post_title" ->  SetValueWithCheckData(map.getEvaluatedPostTitle(),row.createCell(i));
                            case "evaluator_post_title" ->  SetValueWithCheckData(map.getEvaluatorPostTitle(),row.createCell(i));
                            case "student_hoze" ->  SetValueWithCheckData(map.getEvaluatedArea(),row.createCell(i));
                            case "evaluator_hoze" ->  SetValueWithCheckData(map.getEvaluatorArea(),row.createCell(i));
                            case "student_omor" ->  SetValueWithCheckData(map.getEvaluatedAffairs(),row.createCell(i));
                            case "evaluator_omor" ->  SetValueWithCheckData(map.getEvaluatorAffairs(),row.createCell(i));
                            case "class_code" ->  SetValueWithCheckData(map.getClassCode(),row.createCell(i));
                            case "complex" ->  SetValueWithCheckData(map.getComplexTitle(),row.createCell(i));
                            case "class_supervisor" ->  SetValueWithCheckData(map.getClassSupervisor(),row.createCell(i));
                            case "class_start_date" ->  SetValueWithCheckData(map.getClassStartDate(),row.createCell(i));
                            case "class_end_date" ->  SetValueWithCheckData(map.getClassEndDate(),row.createCell(i));
                            case "class_status" ->  SetValueWithCheckData(map.getClassStatus(),row.createCell(i));
                            case "teacher" ->  SetValueWithCheckData(map.getTeacherName(),row.createCell(i));
                            case "teacher_national_code" ->  SetValueWithCheckData(map.getTeacherNationalCode(),row.createCell(i));
                            case "is_personnel" ->  SetValueWithCheckData(map.getTeacherType(),row.createCell(i));
                            case "course_code" ->  SetValueWithCheckData(map.getCourseCode(),row.createCell(i));
                            case "course_titlefa" ->  SetValueWithCheckData(map.getCourseTitle(),row.createCell(i));
                            case "category_titlefa" ->  SetValueWithCheckData(map.getCourseCategoryTitle(),row.createCell(i));
                            case "sub_category_titlefa" ->  SetValueWithCheckData(map.getCourseSubCategoryTitle(),row.createCell(i));
                            case "total_std" ->  SetValueWithCheckData(map.getStudentsCount().toString(),row.createCell(i));
                            case "std_score" ->  SetValueWithCheckData(map.getEvaluationScore() != null ? map.getEvaluationScore().toString() : "0",row.createCell(i));
                            case "std_avg_score" ->  SetValueWithCheckData(map.getEvaluationAverage() != null ? map.getEvaluationAverage().toString() : "0",row.createCell(i));
                            case "acc_score_limit" ->  SetValueWithCheckData(map.getAcceptanceScoreLimit().toString(),row.createCell(i));
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
                ex.printStackTrace();
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
        } else {
            // type is pdf
            List<Map<String, Object>> persons = new ArrayList<>();

            list.forEach(listItem -> {
                Map<String, Object> person = new HashMap<>();
                person.put("studentPersonnelNo", listItem.getEvaluatedPersonnelNo());
                person.put("evaluatorPersonnelNo", listItem.getEvaluatorPersonnelNo());
                person.put("studentName", listItem.getEvaluatedName());
                person.put("studentNationalCode", listItem.getEvaluatedNationalCode());
                person.put("evaluatorName", listItem.getEvaluatorName());
                person.put("evaluatorNationalCode", listItem.getEvaluatorNationalCode());
                person.put("evaluatorType", listItem.getEvaluatorType());
                person.put("evaluatorPostCode", listItem.getEvaluatorPostCode());
                person.put("studentArea", listItem.getEvaluatedArea());
                person.put("evaluatorArea", listItem.getEvaluatorArea());
                person.put("studentAffairs", listItem.getEvaluatedAffairs());
                person.put("evaluatorAffairs", listItem.getEvaluatorAffairs());
                person.put("classCode", listItem.getClassCode());
                person.put("complex", listItem.getComplexTitle());
                person.put("supervisor", listItem.getClassSupervisor());
                person.put("classStartDate", listItem.getClassStartDate());
                person.put("classEndDate", listItem.getClassEndDate());
                person.put("classStatus", listItem.getClassStatus());
                person.put("teacher", listItem.getTeacherName());
                person.put("teacherNationalCode", listItem.getTeacherNationalCode());
                person.put("teacherType", listItem.getTeacherType());
                person.put("courseCode", listItem.getCourseCode());
                person.put("courseTitle", listItem.getCourseTitle());
                person.put("category", listItem.getCourseCategoryTitle());
                person.put("subcategory", listItem.getCourseSubCategoryTitle());
                person.put("studentsCount", listItem.getStudentsCount());
                person.put("studentScore", listItem.getEvaluationScore());
                person.put("studentAvgScour", listItem.getEvaluationAverage());
                person.put("acceptanceLimit", listItem.getAcceptanceScoreLimit());

                persons.add(person);
            });

            String data = "{" + "\"content\": " + objectMapper.writeValueAsString(persons) + "}";
            JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

            HashMap<String, Object> params = new HashMap<>();
            params.put(ConstantVARs.REPORT_TYPE, type);

            reportUtil.export("/reports/behavioralEvaluation.jasper", params, jsonDataSource, response);
        }
    }


    @PostMapping(value = {"/excel/group/training-file"})
    public void getGroupTrainingFile(final HttpServletResponse response, @RequestParam(value = "criteria") String criteria) {
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

        Set<String> nationalCodes = new HashSet<>();
        if (criteriaRq.getCriteria() != null)
            for (int i = 0; i < criteriaRq.getCriteria().size(); i++) {
                if (criteriaRq.getCriteria().get(0) != null)
                    for (int z = 0; z < criteriaRq.getCriteria().get(0).getValue().size(); z++) {
                        String nationalCode = criteriaRq.getCriteria().get(0).getValue().get(z).toString();
                        if (nationalCode.matches("[0-9]+") && nationalCode.length() == 10)
                            nationalCodes.add(nationalCode);
                    }


            }

        List<ViewLmsTrainingFileDTO> data = new ArrayList<>();
        nationalCodes.forEach(nationalCode -> data.addAll(viewTrainingFileService.getDtoListByNationalCode(nationalCode)));
        String fileFullPath = "export.xlsx";
        Workbook workbook = null;
        FileInputStream in = null;
        try {
            String[] headers = new String[23];
            String[] columns = new String[23];


            for (int z = 0; z < 25; z++) {

                switch (z) {
                    case 0: {
                        headers[z] = "نام";
                        columns[z] = "firstName";
                        break;
                    }
                    case 1: {
                        headers[z] = "نام خانوادگی";
                        columns[z] = "lastName";
                        break;
                    }
                    case 2: {
                        headers[z] = "کد ملی";
                        columns[z] = "nationalCode";
                        break;
                    }
                    case 3: {
                        headers[z] = "شماره پرسنلی";
                        columns[z] = "empNo";
                        break;
                    }
                    case 4: {
                        headers[z] = "پست";
                        columns[z] = "postTitle";
                        break;
                    }
                    case 5: {
                        headers[z] = " کد پست";
                        columns[z] = "postCode";
                        break;
                    }
                    case 6: {
                        headers[z] = " شغل";
                        columns[z] = "jobTitle";

                        break;
                    }
                    case 7: {
                        headers[z] = " رده پستی";
                        columns[z] = "postGradeTitle";
                        break;
                    }
                    case 8: {
                        headers[z] = "مجتمع ";
                        columns[z] = "complex";
                        break;
                    }
                    case 9: {
                        headers[z] = "معاونت";
                        columns[z] = "assistant";
                        break;
                    }
                    case 10: {
                        headers[z] = "امور";
                        columns[z] = "affairs";
                        break;
                    }
                    case 11: {
                        headers[z] = "ترم";
                        columns[z] = "termTitleFa";
                        break;
                    }
                    case 12: {
                        headers[z] = " وضعیت قبولی ";
                        columns[z] = "scoresState";
                        break;
                    }


                    case 13: {
                        headers[z] = "نمره";
                        columns[z] = "score";
                        break;
                    }
                    case 14: {
                        headers[z] = "وضعیت کلاس";
                        columns[z] = "classStatus";
                        break;
                    }
                    case 15: {
                        headers[z] = "کد کلاس";
                        columns[z] = "classCode";
                        break;
                    }
                    case 16: {
                        headers[z] = "تاریخ شروع";
                        columns[z] = "startDate";
                        break;
                    }
                    case 17: {
                        headers[z] = "تاریخ پایان";
                        columns[z] = "endDate";
                        break;
                    }
                    case 18: {
                        headers[z] = "کد دوره";
                        columns[z] = "courseCode";
                        break;
                    }
                    case 19: {
                        headers[z] = "دوره";
                        columns[z] = "courseTitle";
                        break;
                    }
                    case 20: {
                        headers[z] = "استاد";
                        columns[z] = "teacher";
                        break;
                    }
                    case 21: {
                        headers[z] = "نوع پرسنل";
                        columns[z] = "personType";
                        break;
                    }
                    case 22: {
                        headers[z] = "مدت دوره";
                        columns[z] = "duration";
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
             SetValueWithCheckData("گزارش گروهی پرونده آموزشی",cell2);

            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:Z1"));

            Row headerRow = sheet.createRow(1);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                 SetValueWithCheckData(headers[i],cell);
                cell.setCellStyle(headerCellStyle);
            }

            CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));

            int rowNum = 1;
            for (ViewLmsTrainingFileDTO map : data) {
                Row row = sheet.createRow(++rowNum);

                for (int i = 0; i < columns.length; i++) {

                    switch (columns[i]) {
                        case "firstName": {
                             SetValueWithCheckData(map.getFirstName() != null ? map.getFirstName() : null,row.createCell(i));
                            break;
                        }
                        case "lastName": {
                             SetValueWithCheckData(map.getLastName() != null ? map.getLastName() : null,row.createCell(i));
                            break;
                        }
                        case "nationalCode": {
                             SetValueWithCheckData(map.getNationalCode() != null ? map.getNationalCode() : null,row.createCell(i));
                            break;
                        }
                        case "empNo": {
                             SetValueWithCheckData(map.getEmpNo() != null ? map.getEmpNo() : null,row.createCell(i));
                            break;
                        }
                        case "postTitle": {
                             SetValueWithCheckData(map.getPostTitle() != null ? map.getPostTitle() : null,row.createCell(i));
                            break;
                        }
                        case "postCode": {
                             SetValueWithCheckData(map.getPostCode() != null ? map.getPostCode() : null,row.createCell(i));
                            break;
                        }
                        case "jobTitle": {
                             SetValueWithCheckData(map.getJobTitle() != null ? map.getJobTitle() : null,row.createCell(i));
                            break;
                        }
                        case "postGradeTitle": {
                             SetValueWithCheckData(map.getPostGradeTitle() != null ? map.getPostGradeTitle() : null,row.createCell(i));
                            break;
                        }
                        case "complex": {
                             SetValueWithCheckData(map.getComplex() != null ? map.getComplex() : null,row.createCell(i));
                            break;
                        }
                        case "assistant": {
                             SetValueWithCheckData(map.getAssistant() != null ? map.getAssistant() : " ",row.createCell(i));
                            break;
                        }
                        case "affairs": {
                             SetValueWithCheckData(map.getAffairs() != null ? map.getAffairs() : " ",row.createCell(i));
                            break;
                        }

                        case "termTitleFa": {
                             SetValueWithCheckData(map.getTermTitleFa() != null ? map.getTermTitleFa() : " ",row.createCell(i));
                            break;
                        }

                        case "scoresState": {
                             SetValueWithCheckData(map.getScoresState() != null ? map.getScoresState() : " ",row.createCell(i));
                            break;
                        }
                        case "score": {
                             SetValueWithCheckData(map.getScore() != null ? map.getScore().toString() : " ",row.createCell(i));
                            break;
                        }
                        case "classStatus": {
                             SetValueWithCheckData(map.getClassStatus() != null ? map.getClassStatus() : " ",row.createCell(i));
                            break;
                        }
                        case "classCode": {
                             SetValueWithCheckData(map.getClassCode() != null ? map.getClassCode() : " ",row.createCell(i));
                            break;
                        }
                        case "startDate": {
                             SetValueWithCheckData(map.getStartDate() != null ? map.getStartDate() : " ",row.createCell(i));
                            break;
                        }
                        case "endDate": {
                             SetValueWithCheckData(map.getEndDate() != null ? map.getEndDate() : " ",row.createCell(i));
                            break;
                        }
                        case "courseCode": {
                             SetValueWithCheckData(map.getCourseCode() != null ? map.getCourseCode() : " ",row.createCell(i));
                            break;
                        }
                        case "courseTitle": {
                             SetValueWithCheckData(map.getCourseTitle() != null ? map.getCourseTitle() : " ",row.createCell(i));
                            break;
                        }
                        case "teacher": {
                             SetValueWithCheckData(map.getTeacher() != null ? map.getTeacher() : " ",row.createCell(i));
                            break;
                        }
                        case "personType": {
                             SetValueWithCheckData(map.getPersonType() != null ? map.getPersonType() : " ",row.createCell(i));

                            break;
                        }
                        case "duration": {
                             SetValueWithCheckData(map.getDuration() != null ? map.getDuration().toString() : " ",row.createCell(i));
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

}
