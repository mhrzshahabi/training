package com.nicico.training.service;

import com.nicico.training.dto.StudentDTO;
import com.nicico.training.model.ClassSession;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ControlReportService {

    public void exportToExcelAttendance(HttpServletResponse response, List<Map<String, String>> masterHeader, List<List<ClassSession>> sessionList,
                              List<List<StudentDTO.clearAttendanceWithState>> students)
            throws Exception {
        String[] headersTable={"ردیف","نام و نام خانوادگی","شماره کار","امور","مدرک","شغل"};

        try {
            Workbook workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("گزارش حضور و غیاب");
            sheet.setColumnWidth(0,1000);
            sheet.setColumnWidth(1,5200);
            sheet.setColumnWidth(2,3000);
            sheet.setColumnWidth(3,3500);
            sheet.setColumnWidth(4,5200);
            sheet.setColumnWidth(5,5200);

            for (int i=6;i<2000;i++)
                sheet.setColumnWidth(i, 480);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            Font rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

            Font rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);


            int cnt=0;
            for (int m=0;m<masterHeader.size();m++) {
                //first row
                CellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                Row row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt+1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C"+(cnt+3)+":D"+(cnt+3));

                XSSFCellStyle rCellStyle2 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt+2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerRight .setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerRight.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerRight.setBorderLeft(CellStyle.BORDER_MEDIUM);

                XSSFCellStyle rCellStyleCornerTop= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerTop .setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleBottom .setFont(rFont2);
                rCellStyleBottom.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleBottom.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerBottomRight .setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerBottomLeft .setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt+3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleRight .setFont(rFont2);
                rCellStyleRight.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyleRight.setBorderLeft(CellStyle.BORDER_MEDIUM);
                rCellStyleRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyleLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleLeft.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C"+(cnt+5)+":D"+(cnt+5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt+4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C"+(cnt+6)+":D"+(cnt+6));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt+5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6+cnt);
                Row rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleBottom2 .setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleBottom2.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyleBottom2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                CellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle( rCellStyleCornerBottomLeft );
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 = (XSSFCellStyle) workbook.createCellStyle();
                Font rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
                rCellStyle6.setFont(rFont3);


                String[] dates = sessionList.get(m).stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).stream().sorted().toArray(String[]::new);

                row = sheet.createRow(7+cnt);

                int factorShift = 0;
                for (int i = 0; i < dates.length; i++) {
                    CellReference startCellReference = new CellReference(7+cnt, 6 + factorShift);
                    CellReference endCellReference = new CellReference(7+cnt, 6 + factorShift + 4);

                    sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                    cellOfRow = row.createCell(6 + i * 5);

                    cellOfRow.setCellValue(dates[i]);
                    rCellStyle6.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle6.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle6.setBorderBottom(CellStyle.BORDER_MEDIUM);
                    rCellStyle6.setBorderTop(CellStyle.BORDER_MEDIUM);
                    rCellStyle6.setBorderLeft(CellStyle.BORDER_MEDIUM);
                    rCellStyle6.setBorderRight(CellStyle.BORDER_MEDIUM);
                    RegionUtil.setBorderBottom(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                    RegionUtil.setBorderTop(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                    RegionUtil.setBorderLeft(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                    RegionUtil.setBorderRight(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                    cellOfRow.setCellStyle(rCellStyle6);
                    factorShift += 5;
                }

                //section 2 in seventh row
                CellReference startCellReference = new CellReference(6+cnt, 6);
                CellReference endCellReference = new CellReference(6+cnt, 6 + factorShift - 1);

                XSSFCellStyle rCellStyle5 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                cellOfRow = rowOld.createCell(6);

                cellOfRow.setCellValue("جلسات");

                rCellStyle5.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle5.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                RegionUtil.setBorderBottom(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                RegionUtil.setBorderTop(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                RegionUtil.setBorderLeft(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                RegionUtil.setBorderRight(CellStyle.BORDER_MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet, workbook);
                cellOfRow.setCellStyle(rCellStyle5);
                //end ninth row

                //tenth row
                row = sheet.createRow(8+cnt);
                XSSFCellStyle rCellStyle7 = (XSSFCellStyle) workbook.createCellStyle();
                Font rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
                rCellStyle7.setFont(rFont4);

                int factor = 6;
                int z = 0;

                for (int i = 0; i < dates.length; i++) {
                    for (int j = 0; j <= 4; j++) {
                        cellOfRow = row.createCell(factor + j);

                        rCellStyle7.setBorderBottom(CellStyle.BORDER_MEDIUM);
                        rCellStyle7.setBorderTop(CellStyle.BORDER_MEDIUM);
                        rCellStyle7.setBorderLeft(CellStyle.BORDER_MEDIUM);
                        rCellStyle7.setBorderRight(CellStyle.BORDER_MEDIUM);
                        rCellStyle7.setAlignment(CellStyle.ALIGN_CENTER);
                        rCellStyle7.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                        rCellStyle7.setBorderBottom(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderTop(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderLeft(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderRight(BorderStyle.MEDIUM);
                        rCellStyle7.setRotation((short) 90);
                        cellOfRow.setCellStyle(rCellStyle7);

                        if (z < sessionList.get(m).size() && sessionList.get(m).get(z).getSessionDate().equals(dates[i])) {
                            cellOfRow.setCellValue(sessionList.get(m).get(z).getSessionStartHour() + "-" + sessionList.get(m).get(z).getSessionEndHour());
                            z++;
                        }
                    }
                    factor += 5;
                }

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle5.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                Font rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                int reaminCols = dates.length * 5;
                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i+cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getJobTitle());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getCcpAffairs());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(5);
                    cellOfRow.setCellValue(students.get(m).get(i).getEducationMajorTitle());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    Set<String> statesPerStudentKeys = students.get(m).get(i).getStates().keySet();
                    List<String> statesPerStudentKeysList = new ArrayList<>(statesPerStudentKeys);

                    Collection<String> statesPerStudentValues = students.get(m).get(i).getStates().values();
                    List<String> statesPerStudentValuesList = new ArrayList<>(statesPerStudentValues);

                    for (int j = 0; j < reaminCols; j++) {
                        cellOfRow = row.createCell(6 + j);

                        if (j < statesPerStudentKeysList.size() && statesPerStudentKeysList.get(j).equals("z" + j)) {
                            cellOfRow.setCellValue(statesPerStudentValuesList.get(j));
                        }

                        rCellStyle7.setAlignment(CellStyle.ALIGN_CENTER);
                        rCellStyle7.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                        rCellStyle7.setBorderBottom(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderTop(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderLeft(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderRight(BorderStyle.MEDIUM);
                        cellOfRow.setCellStyle(rCellStyle7);

                        z++;
                    }
                }

                //8: num rows in main header
                //3: num new lines after each class in sheet
                cnt = cnt + 8 + 3 + students.get(m).size();
            }//end main for

            ///////////////////////now export the excel
            String mimeType = "application/octet-stream";
            String fileName = URLEncoder.encode("ExportExcel.xlsx", "UTF-8").replace("+", "%20");
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            workbook.write(response.getOutputStream());

            workbook.close();
            ///////////////////////////////////////////

        } catch (Exception ex) {
            throw new Exception("Server problem");
        }//end catch
    }//end exportToExcelAttendance

    public void exportToExcelScore(HttpServletResponse response, List<Map<String, String>> masterHeader, List<List<StudentDTO.scoreAttendance>> students)
            throws Exception {
        String[] headersTable={"ردیف","نام و نام خانوادگی","شماره کار","نمره به عدد","نمره به حروف"};

        try {
            Workbook workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            Sheet sheet = workbook.createSheet("گزارش نمرات");
            sheet.setColumnWidth(0,1000);
            sheet.setColumnWidth(1,5200);
            sheet.setColumnWidth(2,3000);
            sheet.setColumnWidth(3,3500);
            sheet.setColumnWidth(4,5200);
            sheet.setColumnWidth(5,5200);
            sheet.setColumnWidth(6,3000);
            sheet.setColumnWidth(7,3000);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            Font rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

            Font rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);


            int cnt=0;
            for (int m=0;m<masterHeader.size();m++) {
                //first row
                CellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                Row row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt+1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C"+(cnt+3)+":D"+(cnt+3));

                XSSFCellStyle rCellStyle2 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt+2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerRight .setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerRight.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerRight.setBorderLeft(CellStyle.BORDER_MEDIUM);

                XSSFCellStyle rCellStyleCornerTop= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerTop .setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleBottom .setFont(rFont2);
                rCellStyleBottom.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleBottom.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerBottomRight .setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerBottomLeft .setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt+3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleRight .setFont(rFont2);
                rCellStyleRight.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyleRight.setBorderLeft(CellStyle.BORDER_MEDIUM);
                rCellStyleRight.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyleLeft.setBorderRight(CellStyle.BORDER_MEDIUM);
                rCellStyleLeft.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C"+(cnt+5)+":D"+(cnt+5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt+4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C"+(cnt+6)+":D"+(cnt+6));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt+5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(CellStyle.ALIGN_RIGHT);
                rCellStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6+cnt);
                Row rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(CellStyle.ALIGN_LEFT);
                rCellStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2= (XSSFCellStyle) workbook.createCellStyle();
                rCellStyleBottom2 .setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(CellStyle.BORDER_MEDIUM);
                rCellStyleBottom2.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyleBottom2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                CellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle4.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                cellOfRow.setCellStyle( rCellStyleCornerBottomLeft );
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 = (XSSFCellStyle) workbook.createCellStyle();
                Font rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
                rCellStyle6.setFont(rFont3);

                //end ninth row

                //tenth row
                row = sheet.createRow(8+cnt);
                XSSFCellStyle rCellStyle7 = (XSSFCellStyle) workbook.createCellStyle();
                Font rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
                rCellStyle7.setFont(rFont4);

                XSSFCellStyle rCellStyle5 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                rCellStyle5.setAlignment(CellStyle.ALIGN_CENTER);
                rCellStyle5.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle5.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                Font rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 = (XSSFCellStyle) workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i+cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreA());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreB());
                    rCellStyle8.setAlignment(CellStyle.ALIGN_CENTER);
                    rCellStyle8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);
                }

                //8: num rows in main header
                //3: num new lines after each class in sheet
                cnt = cnt + 8 + 3 + students.get(m).size();
            }//end main for

            ///////////////////////now export the excel
            String mimeType = "application/octet-stream";
            String fileName = URLEncoder.encode("ExportExcel.xlsx", "UTF-8").replace("+", "%20");
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            workbook.write(response.getOutputStream());

            workbook.close();
            ///////////////////////////////////////////

        } catch (Exception ex) {
            throw new Exception("Server problem");
        }//end catch
    }//end exportToExcelAttendance
}
