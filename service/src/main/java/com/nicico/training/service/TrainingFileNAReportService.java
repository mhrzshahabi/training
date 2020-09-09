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
import com.nicico.training.dto.TrainingFileNAReportDTO;
import com.nicico.training.iservice.ITrainingFileNAReportService;
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
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class TrainingFileNAReportService implements ITrainingFileNAReportService {

    private final TrainingFileNAReportDAO trainingFileNAReportDAO;
    private final PersonnelDurationNAReportService personnelDurationNAReportService;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(trainingFileNAReportDAO, request, converter);
    }

    @Override
    public void generateReport(HttpServletResponse response, List<TrainingFileNAReportDTO.Info> data) throws Exception {

        TrainingFileNAReportDTO.GenerateReport generateReport = new TrainingFileNAReportDTO.GenerateReport();
        List<List<TrainingFileNAReportDTO.Cell>> headers = new ArrayList<>();
        List<TrainingFileNAReportDTO.Cell> rowsOfHeader = new ArrayList<>();
        List<TrainingFileNAReportDTO.GenerateReport> result = new ArrayList<>();

        SearchDTO.SearchRq searchRq=new SearchDTO.SearchRq();
        searchRq.setStartIndex(null);
        searchRq.setCriteria(new SearchDTO.CriteriaRq());
        searchRq.getCriteria().setOperator(EOperator.and);
        searchRq.getCriteria().setCriteria(new ArrayList<>());
        searchRq.getCriteria().getCriteria().add(makeNewCriteria("personnelId",data.stream().map(p->p.getPersonnelId()).collect(Collectors.toList()),EOperator.inSet,null));

        List<PersonnelDurationNAReportDTO.Info> personnelDurations = modelMapper.map(personnelDurationNAReportService.search(searchRq, e -> modelMapper.map(e, PersonnelDurationNAReportDTO.Info.class)).getList(), new TypeToken<List<PersonnelDurationNAReportDTO.Info>>() {
        }.getType());


        int cnt = data.size();

        for (int i = 0; i < cnt; i++) {
            TrainingFileNAReportDTO.Info TFNR = data.get(i);


            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(TFNR.getPersonnelFullName()+"("+TFNR.getPersonnelPersonnelNo()+")", false));
            headers.add(rowsOfHeader);

            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell("پست:", true));
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(TFNR.getPersonnelPostTitle()+"("+TFNR.getPersonnelPostCode()+")", false));
            headers.add(rowsOfHeader);


            rowsOfHeader = new ArrayList<>();
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell("امور:", true));
            rowsOfHeader.add(new TrainingFileNAReportDTO.Cell(TFNR.getLocation(), false));
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

            row.add(((Integer)(i+1)).toString());
            row.add(TFNR.getCourseCode());
            row.add(TFNR.getCourseTitleFa());
            row.add(TFNR.getTheoryDuration().toString());
            row.add(TFNR.getTechnicalType().toString());
            row.add(TFNR.getSkillCode());
            row.add(TFNR.getSkillTitleFa());
            row.add(TFNR.getPriorityId().toString());//
            row.add(TFNR.getIsInNA()?"*":"");
            row.add(TFNR.getClassCode());
            row.add(TFNR.getClassStartDate());
            row.add(TFNR.getClassEndDate());
            row.add(TFNR.getLocation());
            row.add(TFNR.getScore().toString());
            row.add(TFNR.getScoreStateId().toString());

            dataOfGrid.add(row);
            generateReport.setDataOfGrid(dataOfGrid);


            titlesOfGrid = new ArrayList<>();
            titlesOfGrid.add("اولویت");
            titlesOfGrid.add("نیازسنجی");
            titlesOfGrid.add("گذرانده");

            generateReport.setTitlesOfSummaryGrid(titlesOfGrid);

            dataOfGrid = new ArrayList<>();
            ///////////////
            List<PersonnelDurationNAReportDTO.Info> filterOfPersonnelDurations = personnelDurations.stream().filter(p->p.getPersonnelId()==TFNR.getPersonnelId()).collect(Collectors.toList());

            if(filterOfPersonnelDurations!=null&&filterOfPersonnelDurations.size()!=0){
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
            }else{
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
            Integer maxCellsOfRows = 0;
            Integer currentRow = 0;
            Short heightRow = (short) 375;

            TrainingFileNAReportDTO.GenerateReport row = null;


            for (int i = 0; i < cnt; i++) {
                row = data.get(i);

                maxCells = row.getDataOfGrid().stream().max((n1, n2) -> n1.size()).orElse(null).size();

                if (maxCellsOfRows < maxCells) {
                    maxCellsOfRows = maxCells;
                }

                //Headers
                cntOfRows = row.getHeaders().size();
                for (int j = 0; j < cntOfRows; j++) {
                    cntOfCells = row.getHeaders().get(j).size();
                    excelRow = sheet.createRow(currentRow);
                    excelRow.setHeight(heightRow);

                    for (int k = 0; k < cntOfCells; k++) {
                        excelCellOfRow = excelRow.createCell(k);
                        if (k == cntOfCells - 1 && k < maxCells - 1) {
                            cellAddress = new CellReference(currentRow, maxCells - 1);
                            sheet.addMergedRegion(CellRangeAddress.valueOf(new CellReference(currentRow, k).formatAsString() + ":" + cellAddress.formatAsString()));
                        }


                        excelCellOfRow.setCellValue(row.getHeaders().get(j).get(k).getTitle());
                        if (row.getHeaders().get(j).get(k).isBold()) {
                            excelCellOfRow.setCellStyle(bodyBoldCellStyle);
                        } else {
                            excelCellOfRow.setCellStyle(bodyCellStyle);
                        }

                    }
                    currentRow++;
                }


                //Grid
                cntOfRows = row.getTitlesOfGrid().size();
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


            for (int i = 0; i < maxCellsOfRows; i++) {
                sheet.autoSizeColumn(i);
            }


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
