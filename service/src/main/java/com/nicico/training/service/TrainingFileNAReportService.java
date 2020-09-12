/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDurationNAReportDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.TrainingFileNAReportDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.ITrainingFileNAReportService;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.TrainingFileNAReportDAO;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.*;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class TrainingFileNAReportService implements ITrainingFileNAReportService {

    private final TrainingFileNAReportDAO trainingFileNAReportDAO;
    private final PersonnelDurationNAReportService personnelDurationNAReportService;
    private final PostDAO postDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(trainingFileNAReportDAO, request, converter);
    }

    @Override
    public void generateReport(HttpServletResponse response, List<ViewActivePersonnelDTO.Info> data) throws Exception {
        TrainingFileNAReportDTO.GenerateReport generateReport = null;
        List<List<TrainingFileNAReportDTO.Cell>> headers = null;
        List<TrainingFileNAReportDTO.Cell> rowsOfHeader = null;
        List<TrainingFileNAReportDTO.GenerateReport> result = new ArrayList<>();

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        searchRq.setStartIndex(null);
        searchRq.setCriteria(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().setOperator(EOperator.and);
        searchRq.getCriteria().setCriteria(new ArrayList<>());
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("personnelId", data.stream().map(p -> p.getId()).collect(Collectors.toList()), EOperator.inSet, null));


        List<PersonnelDurationNAReportDTO.Info> personnelDurations = modelMapper.map(personnelDurationNAReportService.search(searchRq, e -> modelMapper.map(e, PersonnelDurationNAReportDTO.Info.class)).getList(), new TypeToken<List<PersonnelDurationNAReportDTO.Info>>() {
        }.getType());

        List<String> sortBy = new ArrayList<>();
        sortBy.add("-isInNA");
        sortBy.add("-classCode");
        sortBy.add("priorityId");
        searchRq.setSortBy(sortBy);

        List<TrainingFileNAReportDTO.Info> ListOfTFNR = modelMapper.map(search(searchRq, e -> modelMapper.map(e, TrainingFileNAReportDTO.Info.class)).getList(), new TypeToken<List<TrainingFileNAReportDTO.Info>>() {
        }.getType());

        searchRq = new SearchDTO.SearchRq();
        searchRq.setStartIndex(null);
        searchRq.setCriteria(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().setOperator(EOperator.and);
        searchRq.getCriteria().setCriteria(new ArrayList<>());
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("id", data.stream().map(p -> p.getPostId()).collect(Collectors.toList()), EOperator.inSet, null));

        List<PostDTO.TupleInfo> posts = modelMapper.map(SearchUtil.search(postDAO, searchRq, post -> modelMapper.map(post, PostDTO.TupleInfo.class)).getList(), new TypeToken<List<PostDTO.TupleInfo>>() {
        }.getType());


        int cnt = data.size();

        for (int i = 0; i < cnt; i++) {
            generateReport = new TrainingFileNAReportDTO.GenerateReport();
            ViewActivePersonnelDTO.Info VAPD = data.get(i);

            List<TrainingFileNAReportDTO.Info> TFNR = ListOfTFNR.stream().filter(p -> p.getPersonnelId() == VAPD.getId()).collect(Collectors.toList());

            headers = new ArrayList<>();
            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(VAPD.getFullName() + "(" + VAPD.getPersonnelNo() + ")", false));
            headers.add(rowsOfHeader);

            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell("پست:", true));

            List<PostDTO.TupleInfo> post = posts.stream().filter(p -> p.getId().equals(VAPD.getPostId())).collect(Collectors.toList());

            if (post != null && post.size() > 0) {
                rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(post.get(0).getTitleFa() + "(" + post.get(0).getCode() + ")", false));
            } else {
                rowsOfHeader.add(new TrainingFileNAReportDTO.Cell("", false));
            }

            headers.add(rowsOfHeader);


            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell("امور:", true));
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(VAPD.getCcpAffairs(), false));
            headers.add(rowsOfHeader);

            generateReport.setHeaders(headers);

            List<String> titlesOfGrid = new ArrayList<>();
            titlesOfGrid.add("رديف");
            titlesOfGrid.add("كد دوره");
            titlesOfGrid.add("نام دوره");
            titlesOfGrid.add("مدت دوره");
            titlesOfGrid.add("نوع تخصص");
            titlesOfGrid.add("کد مهارت");
            titlesOfGrid.add("نام مهارت");
            titlesOfGrid.add("اولویت");
            titlesOfGrid.add("نیازسنجی");
            titlesOfGrid.add("کد کلاس");
            titlesOfGrid.add("شروع کلاس");
            titlesOfGrid.add("پایان کلاس");
            titlesOfGrid.add("محل برگزاری");
            titlesOfGrid.add("نمره");
            titlesOfGrid.add("وضعیت نمره");

            generateReport.setTitlesOfGrid(titlesOfGrid);

            List<List<String>> dataOfGrid = new ArrayList<>();
            List<String> row = new ArrayList<>();

            int cnt2 = TFNR.size();

            for (int j = 0; j < cnt2; j++) {
                row = new ArrayList<>();
                final TrainingFileNAReportDTO.Info tmpTFNR = TFNR.get(j);

                row.add(((Integer) (j + 1)).toString());
                row.add(tmpTFNR.getCourseCode());
                row.add(tmpTFNR.getCourseTitleFa());
                row.add(tmpTFNR.getTheoryDuration().toString());
                row.add(tmpTFNR.getTechnicalType() == null ? "" : ((ETechnicalType) Arrays.asList(ETechnicalType.values()).stream().filter(p -> p.getId().equals(tmpTFNR.getTechnicalType())).toArray()[0]).getTitleFa());
                row.add(tmpTFNR.getSkillCode());
                row.add(tmpTFNR.getSkillTitleFa());
                row.add(tmpTFNR.getPriority());
                row.add(tmpTFNR.getIsInNA() ? "*" : "");
                row.add(tmpTFNR.getClassCode());
                row.add(tmpTFNR.getClassStartDate());
                row.add(tmpTFNR.getClassEndDate());
                row.add(tmpTFNR.getLocation());
                row.add(tmpTFNR.getScore() == null ? "" : tmpTFNR.getScore().toString());
                row.add(tmpTFNR.getScoreState());

                dataOfGrid.add(row);
            }

            generateReport.setDataOfGrid(dataOfGrid);


            titlesOfGrid = new ArrayList<>();
            titlesOfGrid.add("اولویت");
            titlesOfGrid.add("نیازسنجی");
            titlesOfGrid.add("گذرانده");

            generateReport.setTitlesOfSummaryGrid(titlesOfGrid);

            dataOfGrid = new ArrayList<>();
            ///////////////
            List<PersonnelDurationNAReportDTO.Info> filterOfPersonnelDurations = personnelDurations.stream().filter(p -> p.getPersonnelId() == VAPD.getId()).collect(Collectors.toList());

            if (filterOfPersonnelDurations != null && filterOfPersonnelDurations.size() != 0) {
                ///////////////
                row = new ArrayList<>();

                row.add("عملکردی ضروری");
                row.add(filterOfPersonnelDurations.get(0).getEssential().toString());
                row.add(filterOfPersonnelDurations.get(0).getEssentialPassed().toString());

                dataOfGrid.add(row);
                ///////////////
                row = new ArrayList<>();

                row.add("عملکردی بهبودی");
                row.add(filterOfPersonnelDurations.get(0).getImproving().toString());
                row.add(filterOfPersonnelDurations.get(0).getImprovingPassed().toString());

                dataOfGrid.add(row);
                row = new ArrayList<>();

                row.add("توسعه ای");
                row.add(filterOfPersonnelDurations.get(0).getDevelopmental().toString());
                row.add(filterOfPersonnelDurations.get(0).getDevelopmentalPassed().toString());

                dataOfGrid.add(row);
                ///////////////
                row = new ArrayList<>();

                row.add("جمع");
                row.add(filterOfPersonnelDurations.get(0).getDuration().toString());
                row.add(filterOfPersonnelDurations.get(0).getPassed().toString());

                dataOfGrid.add(row);
                ///////////////
            } else {
                ///////////////
                row = new ArrayList<>();

                row.add("عملکردی ضروری");
                row.add("0");
                row.add("0");

                dataOfGrid.add(row);
                ///////////////
                row = new ArrayList<>();

                row.add("عملکردی بهبودی");
                row.add("0");
                row.add("0");

                dataOfGrid.add(row);
                row = new ArrayList<>();

                row.add("توسعه ای");
                row.add("0");
                row.add("0");

                dataOfGrid.add(row);
                ///////////////
                row = new ArrayList<>();

                row.add("جمع");
                row.add("0");
                row.add("0");

                dataOfGrid.add(row);
                ///////////////
            }

            generateReport.setDataOfSummaryGrid(dataOfGrid);

            result.add(generateReport);
        }

        exportExcel(response, result);

    }

    @Override
    public void exportExcel(HttpServletResponse response, List<TrainingFileNAReportDTO.GenerateReport> data) throws Exception {

        try {

            XSSFWorkbook workbook = new XSSFWorkbook();
            XSSFSheet sheet = workbook.createSheet("گزارش");
            sheet.setRightToLeft(true);

            XSSFCellStyle headerCellStyle = setCellStyle(workbook, "Tahoma", (short) 14, null, new Color(226, 121, 0), VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
            XSSFCellStyle headerBoldCellStyle = setCellStyle(workbook, "Tahoma", (short) 14, null, new Color(226, 121, 0), VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
            headerBoldCellStyle.getFont().setBold(true);

            XSSFCellStyle bodyCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, null, null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
            XSSFCellStyle bodyBoldCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, null, null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
            bodyBoldCellStyle.getFont().setBold(true);

            XSSFRow excelRow = null;
            XSSFCell excelCellOfRow = null;
            CellReference cellAddress = null;

            Integer cnt = data.size();
            Integer cntOfRows = 0;
            Integer cntOfCells = 0;
            Integer maxCells = 0;
            //Integer maxCellsOfRows = 0;
            Integer currentRow = 0;
            Short heightRow = (short) 375;

            TrainingFileNAReportDTO.GenerateReport row = null;


            for (int i = 0; i < cnt; i++) {
                row = data.get(i);

                maxCells = row.getTitlesOfGrid().size();

                /*if (maxCellsOfRows < maxCells) {
                    maxCellsOfRows = maxCells;
                }*/

                //Headers
                cntOfRows = row.getHeaders().size();
                for (int j = 0; j < cntOfRows; j++) {
                    cntOfCells = row.getHeaders().get(j).size();
                    excelRow = sheet.createRow(currentRow);
                    excelRow.setHeight((short) (heightRow * 1.5));

                    for (int k = 0; k < cntOfCells; k++) {
                        excelCellOfRow = excelRow.createCell(k);
                        if (k == cntOfCells - 1 && k < maxCells - 1) {
                            cellAddress = new CellReference(currentRow, maxCells - 1);
                            sheet.addMergedRegion(CellRangeAddress.valueOf(new CellReference(currentRow, k).formatAsString() + ":" + cellAddress.formatAsString()));
                        }


                        excelCellOfRow.setCellValue(row.getHeaders().get(j).get(k).getTitle());
                        if (row.getHeaders().get(j).get(k).isBold()) {
                            excelCellOfRow.setCellStyle(headerBoldCellStyle);
                        } else {
                            excelCellOfRow.setCellStyle(headerCellStyle);
                        }

                    }
                    currentRow++;
                }


                //Grid
                cntOfRows = row.getTitlesOfGrid().size();

                excelRow = sheet.createRow(currentRow);
                excelRow.setHeight(heightRow);

                excelCellOfRow = excelRow.createCell(1);
                sheet.addMergedRegion(CellRangeAddress.valueOf(new CellReference(currentRow, 1).formatAsString() + ":" + new CellReference(currentRow, 4).formatAsString()));
                excelCellOfRow.setCellValue("مشخصات دوره");
                excelCellOfRow.setCellStyle(bodyBoldCellStyle);

                excelCellOfRow = excelRow.createCell(5);
                sheet.addMergedRegion(CellRangeAddress.valueOf(new CellReference(currentRow, 5).formatAsString() + ":" + new CellReference(currentRow, 8).formatAsString()));
                excelCellOfRow.setCellValue("نیازسنجی");
                excelCellOfRow.setCellStyle(bodyBoldCellStyle);

                excelCellOfRow = excelRow.createCell(9);
                sheet.addMergedRegion(CellRangeAddress.valueOf(new CellReference(currentRow, 9).formatAsString() + ":" + new CellReference(currentRow, 14).formatAsString()));
                excelCellOfRow.setCellValue("پرونده آموزشی");
                excelCellOfRow.setCellStyle(bodyBoldCellStyle);
                currentRow++;


                excelRow = sheet.createRow(currentRow);
                excelRow.setHeight(heightRow);

                for (int j = 0; j < cntOfRows; j++) {
                    excelCellOfRow = excelRow.createCell(j);

                    excelCellOfRow.setCellValue(row.getTitlesOfGrid().get(j));
                    excelCellOfRow.setCellStyle(bodyBoldCellStyle);
                }
                currentRow++;

                cntOfRows = row.getDataOfGrid().size();

                for (int j = 0; j < cntOfRows; j++) {
                    cntOfCells = row.getDataOfGrid().get(j).size();
                    excelRow = sheet.createRow(currentRow);
                    excelRow.setHeight(heightRow);

                    for (int k = 0; k < cntOfCells; k++) {
                        excelCellOfRow = excelRow.createCell(k);

                        excelCellOfRow.setCellValue(row.getDataOfGrid().get(j).get(k));
                        excelCellOfRow.setCellStyle(bodyCellStyle);
                    }
                    currentRow++;
                }

                currentRow++;

                //Summary
                cntOfCells = row.getTitlesOfSummaryGrid().size();
                excelRow = sheet.createRow(currentRow);
                excelRow.setHeight(heightRow);


                for (int j = 0; j < cntOfCells; j++) {

                    excelCellOfRow = excelRow.createCell(j + 2);

                    XSSFCellStyle tmpCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, null, null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
                    tmpCellStyle.getFont().setBold(true);

                    tmpCellStyle.setBorderTop(BorderStyle.DOUBLE);

                    tmpCellStyle.setBorderLeft(BorderStyle.MEDIUM);
                    tmpCellStyle.setBorderRight(BorderStyle.MEDIUM);

                    if (j == 0) {
                        tmpCellStyle.setBorderLeft(BorderStyle.DOUBLE);
                    } else if (j == cntOfCells - 1) {
                        tmpCellStyle.setBorderRight(BorderStyle.DOUBLE);
                    }

                    excelCellOfRow.setCellStyle(tmpCellStyle);

                    excelCellOfRow.setCellValue(row.getTitlesOfSummaryGrid().get(j));
                }
                currentRow++;

                cntOfRows = row.getDataOfSummaryGrid().size();


                for (int j = 0; j < cntOfRows; j++) {
                    cntOfCells = row.getDataOfSummaryGrid().get(j).size();
                    excelRow = sheet.createRow(currentRow);
                    excelRow.setHeight(heightRow);

                    for (int k = 0; k < cntOfCells; k++) {
                        excelCellOfRow = excelRow.createCell(k + 2);

                        XSSFCellStyle tmpCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, null, null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);

                        tmpCellStyle.setBorderTop(BorderStyle.MEDIUM);
                        tmpCellStyle.setBorderBottom(BorderStyle.MEDIUM);
                        tmpCellStyle.setBorderLeft(BorderStyle.MEDIUM);
                        tmpCellStyle.setBorderRight(BorderStyle.MEDIUM);

                        if (j == cntOfRows - 1) {
                            tmpCellStyle.setBorderBottom(BorderStyle.DOUBLE);
                        }

                        if (k == 0) {
                            tmpCellStyle.setBorderLeft(BorderStyle.DOUBLE);
                        } else if (k == cntOfCells - 1) {
                            tmpCellStyle.setBorderRight(BorderStyle.DOUBLE);
                        }

                        excelCellOfRow.setCellStyle(tmpCellStyle);

                        excelCellOfRow.setCellValue(row.getDataOfSummaryGrid().get(j).get(k));
                    }
                    currentRow++;
                }


                currentRow += 4;

            }

            sheet.setColumnWidth(1, 2800);
            sheet.setColumnWidth(2, 18250);
            sheet.setColumnWidth(3, 2500);
            sheet.setColumnWidth(4, 3000);
            sheet.setColumnWidth(5, 2800);
            sheet.setColumnWidth(6, 18250);
            sheet.setColumnWidth(7, 4500);
            sheet.setColumnWidth(8, 2800);
            sheet.setColumnWidth(9, 4500);
            sheet.setColumnWidth(10, 3000);
            sheet.setColumnWidth(11, 3000);
            sheet.setColumnWidth(12, 8000);
            sheet.setColumnWidth(14, 9625);


            String mimeType = "application/octet-stream";
            String fileName = URLEncoder.encode("TrainingFileNAReport.xlsx", "UTF-8");
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            workbook.write(response.getOutputStream());

            workbook.close();

        } catch (Exception ex) {
            throw new Exception("خطا در سرور");
        }
    }


    private XSSFFont setFont(XSSFWorkbook workbook, String fontFamily, Short size, Color color) {

        XSSFFont font = workbook.createFont();
        font.setFontHeightInPoints(size);
        font.setFontName(fontFamily);

        if (color != null) {
            font.setColor(new XSSFColor(color));
        }

        return font;
    }

    private XSSFCellStyle setCellStyle(XSSFWorkbook workbook, String fontFamily, Short size, Color color, Color foregroundColor, VerticalAlignment verticalAlignment, HorizontalAlignment horizontalAlignment) {

        XSSFFont font = setFont(workbook, fontFamily, size, color);

        XSSFCellStyle cellStyle = workbook.createCellStyle();
        cellStyle.setFont(font);

        if (foregroundColor != null) {
            cellStyle.setFillForegroundColor(new XSSFColor(foregroundColor));
            cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        }

        if (verticalAlignment != null) {
            cellStyle.setVerticalAlignment(verticalAlignment);
        }

        if (horizontalAlignment != null) {
            cellStyle.setAlignment(horizontalAlignment);
        }

        return cellStyle;
    }
}
