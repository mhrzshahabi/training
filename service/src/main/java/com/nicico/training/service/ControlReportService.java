package com.nicico.training.service;

import com.nicico.training.dto.StudentDTO;
import com.nicico.training.model.ClassSession;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.*;
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
        String[] headersTable = {"ردیف", "نام و نام خانوادگی", "شماره کار", "امور", "مدرک", "شغل"};
        XSSFWorkbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            XSSFSheet sheet = workbook.createSheet("گزارش حضور و غیاب");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 4200);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);

            for (int i = 6; i < 100; i++)
                sheet.setColumnWidth(i, 480);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            XSSFFont rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBold(true);

            XSSFFont rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBold(true);


            int cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                // sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);


                String[] dates = sessionList.get(m).stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).stream().sorted().toArray(String[]::new);

                row = sheet.createRow(7 + cnt);

                int factorShift = 0;
                for (int i = 0; i < dates.length; i++) {
                    CellReference startCellReference = new CellReference(7 + cnt, 6 + factorShift);
                    CellReference endCellReference = new CellReference(7 + cnt, 6 + factorShift + 4);

                    sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                    cellOfRow = row.createCell(6 + i * 5);

                    cellOfRow.setCellValue(dates[i]);
                    rCellStyle6.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle6.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle6.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderRight(BorderStyle.MEDIUM);

                    RegionUtil.setBorderBottom(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderTop(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderLeft(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderRight(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);


                    cellOfRow.setCellStyle(rCellStyle6);
                    factorShift += 5;
                }

                //section 2 in seventh row
                CellReference startCellReference = new CellReference(6 + cnt, 6);
                CellReference endCellReference = new CellReference(6 + cnt, 6 + factorShift - 1);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                cellOfRow = rowOld.createCell(6);

                cellOfRow.setCellValue("جلسات");

                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                RegionUtil.setBorderBottom(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderTop(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderLeft(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderRight(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);

                cellOfRow.setCellStyle(rCellStyle5);
                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                int factor = 6;
                int z = 0;

                for (int i = 0; i < dates.length; i++) {
                    for (int j = 0; j <= 4; j++) {
                        cellOfRow = row.createCell(factor + j);
                        cellOfRow.setCellValue("فاقد جلسه");
                        rCellStyle7.setBorderBottom(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderTop(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderLeft(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderRight(BorderStyle.MEDIUM);
                        rCellStyle7.setAlignment(HorizontalAlignment.CENTER);
                        rCellStyle7.setVerticalAlignment(VerticalAlignment.CENTER);
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
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                int reaminCols = dates.length * 5;
                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getCcpAffairs());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getEducationMajorTitle());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(5);
                    cellOfRow.setCellValue(students.get(m).get(i).getJobTitle());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    Map map = students.get(m).get(i).getStates();
                    TreeMap treeMap = new TreeMap<>(map);

                    Set<Integer> statesPerStudentKeys = treeMap.keySet();
                    List<Integer> statesPerStudentKeysList = new ArrayList<>(statesPerStudentKeys);

                    Collection<String> statesPerStudentValues = treeMap.values();
                    List<String> statesPerStudentValuesList = new ArrayList<>(statesPerStudentValues);

                    z = 0;
                    int k=0;
                    for (int j = 0; j < reaminCols; j++) {
                        cellOfRow = row.createCell(6 + j);

                        for (Integer key : statesPerStudentKeysList) {
                            if (key == j) {
                                cellOfRow.setCellValue(statesPerStudentValuesList.get(k));
                                k++;
                                break;
                            }
                        }

                        rCellStyle7.setAlignment(HorizontalAlignment.CENTER);
                        rCellStyle7.setVerticalAlignment(VerticalAlignment.CENTER);
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
            XSSFCellStyle rCellStyle = workbook.createCellStyle();
            rCellStyle.setFont(rFont);
            XSSFRow row = sheet.createRow(cnt);
            Cell cellOfRow = row.createCell(1);
            row.setHeight((short) 575);
            cellOfRow.setCellValue("نام و امضای مسئول واحد ");
            cellOfRow.setCellStyle(rCellStyle);
            rCellStyle.setAlignment(HorizontalAlignment.RIGHT);
            rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);


            XSSFRow rowSec = sheet.createRow(cnt+1);
            Cell cellOfRowSec = rowSec.createCell(1);
            rowSec.setHeight((short) 575);
            cellOfRowSec.setCellValue("نام و امضای استاد ");
            cellOfRowSec.setCellStyle(rCellStyle);

            XSSFRow rowTh = sheet.createRow(cnt+2);
            Cell cellOfRowTh = rowTh.createCell(1);
            rowTh.setHeight((short) 575);
            cellOfRowTh.setCellValue("نام و امضای سرپرست آزمون ");
            cellOfRowTh.setCellStyle(rCellStyle);

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
        } finally {
            if (workbook != null)
                workbook.close();
        }
    }//end exportToExcelAttendance

    public void exportToExcelScore(HttpServletResponse response, List<Map<String, String>> masterHeader, List<List<StudentDTO.scoreAttendance>> students)
            throws Exception {
        String[] headersTable = {"ردیف", "نام و نام خانوادگی", "شماره کار", "نمره به عدد", "نمره به حروف"};
        XSSFWorkbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            XSSFSheet sheet = workbook.createSheet("گزارش نمرات");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 4200);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);
            sheet.setColumnWidth(6, 3000);
            sheet.setColumnWidth(7, 3000);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            XSSFFont rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBold(true);

            XSSFFont rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBold(true);

            int cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                // sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);

                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreA());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreB());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
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
            XSSFCellStyle rCellStyle = workbook.createCellStyle();
            rCellStyle.setFont(rFont);
            XSSFRow row = sheet.createRow(cnt);
            Cell cellOfRow = row.createCell(1);
            row.setHeight((short) 575);
            cellOfRow.setCellValue("نام و امضای مسئول واحد ");
            cellOfRow.setCellStyle(rCellStyle);
            rCellStyle.setAlignment(HorizontalAlignment.RIGHT);
            rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);


            XSSFRow rowSec = sheet.createRow(cnt+1);
            Cell cellOfRowSec = rowSec.createCell(1);
            rowSec.setHeight((short) 575);
            cellOfRowSec.setCellValue("نام و امضای استاد ");
            cellOfRowSec.setCellStyle(rCellStyle);

            XSSFRow rowTh = sheet.createRow(cnt+2);
            Cell cellOfRowTh = rowTh.createCell(1);
            rowTh.setHeight((short) 575);
            cellOfRowTh.setCellValue("نام و امضای سرپرست آزمون ");
            cellOfRowTh.setCellStyle(rCellStyle);


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
        } finally {
            if (workbook != null)
                workbook.close();
        }
    }//end exportToExcelScore

    public void exportToExcelControl(HttpServletResponse response, List<Map<String, String>> masterHeader, List<List<StudentDTO.controlAttendance>> students)
            throws Exception {
        String[] headersTable = {"ردیف", "نام و نام خانوادگی", "شماره کار جدید", "شماره کار قدیم", "امور"};
        XSSFWorkbook workbook = null;
        try {
            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            XSSFSheet sheet = workbook.createSheet("گزارش کنترل");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 4200);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);
            sheet.setColumnWidth(6, 3000);
            sheet.setColumnWidth(7, 3000);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            XSSFFont rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBold(true);

            XSSFFont rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBold(true);

            int cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                //sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);

                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo2());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getCcpAffairs());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);
                }

                //8: num rows in main header
                //3: num new lines after each class in sheet
                cnt = cnt + 8 + 3 + students.get(m).size();
            }
            //end main for

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
        } finally {
            if (workbook != null)
                workbook.close();
        }
    }//end exportToExcelControl

    public void exportToExcelFull(HttpServletResponse response, List<Map<String, String>> masterHeader, List<List<ClassSession>> sessionList, List<List<StudentDTO.fullAttendance>> students)
            throws Exception {
        XSSFWorkbook workbook = null;
        //نمرات
        try {
            String[] headersTable = {"ردیف", "نام و نام خانوادگی", "شماره کار", "نمره به عدد", "نمره به حروف"};
            workbook = new XSSFWorkbook();
            CreationHelper createHelper = workbook.getCreationHelper();
            XSSFSheet sheet = workbook.createSheet("گزارش نمرات");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 4200);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);
            sheet.setColumnWidth(6, 3000);
            sheet.setColumnWidth(7, 3000);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            XSSFFont rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 11);
            rFont.setFontName("Tahoma");
            rFont.setBold(true);

            XSSFFont rFont2 = workbook.createFont();
            rFont2.setFontHeightInPoints((short) 10);
            rFont2.setFontName("Tahoma");
            rFont2.setBold(true);

            int cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                //sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);

                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreA());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getScoreB());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
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


            //حضور و غياب
            headersTable = new String[]{"ردیف", "نام و نام خانوادگی", "شماره کار", "امور", "مدرک", "شغل"};

            sheet = workbook.createSheet("گزارش حضور و غیاب");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 4200);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);

            for (int i = 6; i < 100; i++)
                sheet.setColumnWidth(i, 480);

            sheet.setRightToLeft(true);

            cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                if (sessionList.get(m).size() == 0) {
                    continue;
                }
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                // sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);


                String[] dates = sessionList.get(m).stream().map(ClassSession::getSessionDate).collect(Collectors.toSet()).stream().sorted().toArray(String[]::new);

                row = sheet.createRow(7 + cnt);

                int factorShift = 0;
                for (int i = 0; i < dates.length; i++) {
                    CellReference startCellReference = new CellReference(7 + cnt, 6 + factorShift);
                    CellReference endCellReference = new CellReference(7 + cnt, 6 + factorShift + 4);

                    sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                    cellOfRow = row.createCell(6 + i * 5);

                    cellOfRow.setCellValue(dates[i]);
                    rCellStyle6.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle6.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle6.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle6.setBorderRight(BorderStyle.MEDIUM);

                    RegionUtil.setBorderBottom(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderTop(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderLeft(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                    RegionUtil.setBorderRight(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);

                    cellOfRow.setCellStyle(rCellStyle6);
                    factorShift += 5;
                }

                //section 2 in seventh row
                CellReference startCellReference = new CellReference(6 + cnt, 6);
                CellReference endCellReference = new CellReference(6 + cnt, 6 + factorShift - 1);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                sheet.addMergedRegion(CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()));
                cellOfRow = rowOld.createCell(6);

                cellOfRow.setCellValue("جلسات");

                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                RegionUtil.setBorderBottom(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderTop(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderLeft(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);
                RegionUtil.setBorderRight(BorderStyle.MEDIUM, CellRangeAddress.valueOf(startCellReference.formatAsString() + ":" + endCellReference.formatAsString()), sheet);

                cellOfRow.setCellStyle(rCellStyle5);
                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                int factor = 6;
                int z = 0;

                for (int i = 0; i < dates.length; i++) {
                    for (int j = 0; j <= 4; j++) {
                        cellOfRow = row.createCell(factor + j);
                        cellOfRow.setCellValue("فاقد جلسه");
                        rCellStyle7.setBorderBottom(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderTop(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderLeft(BorderStyle.MEDIUM);
                        rCellStyle7.setBorderRight(BorderStyle.MEDIUM);
                        rCellStyle7.setAlignment(HorizontalAlignment.CENTER);
                        rCellStyle7.setVerticalAlignment(VerticalAlignment.CENTER);
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
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                int reaminCols = dates.length * 5;
                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getCcpAffairs());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getEducationMajorTitle());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(5);
                    cellOfRow.setCellValue(students.get(m).get(i).getJobTitle());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    Set<Integer> statesPerStudentKeys = students.get(m).get(i).getStates().keySet();
                    List<Integer> statesPerStudentKeysList = new ArrayList<>(statesPerStudentKeys);

                    Collection<String> statesPerStudentValues = students.get(m).get(i).getStates().values();
                    List<String> statesPerStudentValuesList = new ArrayList<>(statesPerStudentValues);

                    int k=0;
                    for (int j = 0; j < reaminCols; j++) {
                        cellOfRow = row.createCell(6 + j);

                        if (k < statesPerStudentKeysList.size() && statesPerStudentKeysList.get(k).equals(j)) {
                            cellOfRow.setCellValue(statesPerStudentValuesList.get(k));
                            k++;
                        }

                        rCellStyle7.setAlignment(HorizontalAlignment.CENTER);
                        rCellStyle7.setVerticalAlignment(VerticalAlignment.CENTER);
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

            //کنترل
            headersTable = new String[]{"ردیف", "نام و نام خانوادگی", "شماره کار جدید", "شماره کار قدیم", "امور"};

            sheet = workbook.createSheet("گزارش کنترل");
            sheet.setColumnWidth(0, 1000);
            sheet.setColumnWidth(1, 5200);
            sheet.setColumnWidth(2, 3000);
            sheet.setColumnWidth(3, 3500);
            sheet.setColumnWidth(4, 5200);
            sheet.setColumnWidth(5, 5200);
            sheet.setColumnWidth(6, 3000);
            sheet.setColumnWidth(7, 3000);

            sheet.setRightToLeft(true);

            ////////////////////////////////////////////////////////////////
            cnt = 0;
            for (int m = 0; m < masterHeader.size(); m++) {
                //first row
                XSSFCellStyle rCellStyle = workbook.createCellStyle();
                rCellStyle.setFont(rFont);
                XSSFRow row = sheet.createRow(cnt);
                Cell cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("شركت ملي صنايع مس ايران");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end first row

                //second row
                row = sheet.createRow(cnt + 1);
                cellOfRow = row.createCell(4);
                row.setHeight((short) 575);
                cellOfRow.setCellValue("امور آموزش و تجهيز نيروي انساني");
                cellOfRow.setCellStyle(rCellStyle);
                rCellStyle.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
                //end second row

                //third row
                CellRangeAddress cellRangeAddress1 = CellRangeAddress.valueOf("C" + (cnt + 3) + ":D" + (cnt + 3));

                XSSFCellStyle rCellStyle2 =  workbook.createCellStyle();
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress1);
                row = sheet.createRow(cnt + 2);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleCornerRight =  workbook.createCellStyle();
                rCellStyleCornerRight.setFont(rFont2);
                rCellStyleCornerRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("نام دوره:");
                cellOfRow.setCellStyle(rCellStyleCornerRight);

                rCellStyleCornerRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerRight.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerRight.setBorderLeft(BorderStyle.MEDIUM);

                XSSFCellStyle rCellStyleCornerTop =  workbook.createCellStyle();
                rCellStyleCornerTop.setFont(rFont2);
                rCellStyleCornerTop.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerTop.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerTop.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleBottom =  workbook.createCellStyle();
                rCellStyleBottom.setFont(rFont2);
                rCellStyleBottom.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom.setVerticalAlignment(VerticalAlignment.CENTER);

                XSSFCellStyle rCellStyleCornerBottomRight =  workbook.createCellStyle();
                rCellStyleCornerBottomRight.setFont(rFont2);
                rCellStyleCornerBottomRight.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleCornerBottomRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleCornerBottomLeft =  workbook.createCellStyle();
                rCellStyleCornerBottomLeft.setFont(rFont2);
                rCellStyleCornerBottomLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleCornerBottomLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerBottomLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerBottomLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle3 =  workbook.createCellStyle();
                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("titleClass"));
                rCellStyle3.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle3.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                cellOfRow = row.createCell(3);
                cellOfRow.setCellStyle(rCellStyleCornerTop);

                XSSFCellStyle rCellStyleCornerLeft =  workbook.createCellStyle();
                rCellStyleCornerLeft.setBorderTop(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleCornerLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleCornerLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleCornerLeft);

                //end third row

                //fourth row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(cnt + 3);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                XSSFCellStyle rCellStyleRight =  workbook.createCellStyle();
                rCellStyleRight.setFont(rFont2);
                rCellStyleRight.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyleRight.setBorderLeft(BorderStyle.MEDIUM);
                rCellStyleRight.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleRight.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleRight.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyleLeft =  workbook.createCellStyle();
                rCellStyleLeft.setFont(rFont2);
                rCellStyleLeft.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleLeft.setBorderRight(BorderStyle.MEDIUM);
                rCellStyleLeft.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleLeft.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleLeft.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                cellOfRow.setCellValue("کد دوره:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("code"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(3);
                XSSFCellStyle rCellStyleTemp =  workbook.createCellStyle();
                rCellStyleTemp.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleTemp.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                cellOfRow.setCellStyle(rCellStyleTemp);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fourth row

                //fifth row
                CellRangeAddress cellRangeAddress2 = CellRangeAddress.valueOf("C" + (cnt + 5) + ":D" + (cnt + 5));
                rCellStyle2.setFont(rFont2);
                sheet.addMergedRegion(cellRangeAddress2);
                row = sheet.createRow(cnt + 4);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("روزهاي تشكيل كلاس:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("days"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end fifth row

                //sixth row
                CellRangeAddress cellRangeAddress3 = CellRangeAddress.valueOf("C" + (cnt + 6) + ":D" + (cnt + 6));
                rCellStyle2.setFont(rFont2);
                //sheet.addMergedRegion(cellRangeAddress3);
                row = sheet.createRow(cnt + 5);
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("استاد:");
                cellOfRow.setCellStyle(rCellStyleRight);
                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("teacher"));
                rCellStyle3.setAlignment(HorizontalAlignment.RIGHT);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                rCellStyle3.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("مدت زمان:");
                rCellStyle3.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle3.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyle3);

                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("hduration"));
                cellOfRow.setCellStyle(rCellStyleLeft);
                //end sixth row

                //seventh row
                rCellStyle2.setFont(rFont2);
                row = sheet.createRow(6 + cnt);
                XSSFRow rowOld = row;
                cellOfRow = row.createCell(1);
                row.setHeight((short) 475);

                cellOfRow.setCellValue("تاريخ برگزاری:");
                cellOfRow.setCellStyle(rCellStyleCornerBottomRight);

                rCellStyle2.setAlignment(HorizontalAlignment.LEFT);
                rCellStyle2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyle2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyle2.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                XSSFCellStyle rCellStyleBottom2 =  workbook.createCellStyle();
                rCellStyleBottom2.setFont(rFont2);
                rCellStyleBottom2.setBorderBottom(BorderStyle.MEDIUM);
                rCellStyleBottom2.setAlignment(HorizontalAlignment.CENTER);
                rCellStyleBottom2.setVerticalAlignment(VerticalAlignment.CENTER);
                rCellStyleBottom2.setFillForegroundColor(IndexedColors.ORANGE.getIndex());
                rCellStyleBottom2.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                XSSFCellStyle rCellStyle4 = workbook.createCellStyle();
                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(2);
                cellOfRow.setCellValue(masterHeader.get(m).get("startDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(3);
                cellOfRow.setCellValue("لغایت");
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);

                cellOfRow.setCellStyle(rCellStyleBottom2);

                rCellStyle4.setFont(rFont2);
                cellOfRow = row.createCell(4);
                cellOfRow.setCellValue(masterHeader.get(m).get("endDate"));
                rCellStyle4.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle4.setVerticalAlignment(VerticalAlignment.CENTER);
                cellOfRow.setCellStyle(rCellStyleCornerBottomLeft);
                //end seventh row

                //ninth row
                XSSFCellStyle rCellStyle6 =  workbook.createCellStyle();
                XSSFFont rFont3 = workbook.createFont();
                rFont3.setFontHeightInPoints((short) 7);
                rFont3.setFontName("Tahoma");
                rFont3.setBold(true);
                rCellStyle6.setFont(rFont3);

                //end ninth row

                //tenth row
                row = sheet.createRow(8 + cnt);
                XSSFCellStyle rCellStyle7 =  workbook.createCellStyle();
                XSSFFont rFont4 = workbook.createFont();
                rFont4.setFontHeightInPoints((short) 6);
                rFont4.setFontName("Tahoma");
                rFont4.setBold(true);
                rCellStyle7.setFont(rFont4);

                XSSFCellStyle rCellStyle5 =  workbook.createCellStyle();
                rCellStyle5.setFont(rFont2);
                rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);

                for (int i = 0; i < headersTable.length; i++) {
                    cellOfRow = row.createCell(i);
                    row.setHeight((short) 815);

                    cellOfRow.setCellValue(headersTable[i]);
                    rCellStyle5.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle5.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle5.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle5.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle5);
                }
                //end tenth row

                //create students
                XSSFFont rFont5 = workbook.createFont();
                rFont5.setFontHeightInPoints((short) 8);
                rFont5.setFontName("Tahoma");
                XSSFCellStyle rCellStyle8 =  workbook.createCellStyle();
                rCellStyle8.setFont(rFont5);

                for (int i = 0; i < students.get(m).size(); i++) {
                    row = sheet.createRow(9 + i + cnt);
                    row.setHeight((short) 475);
                    cellOfRow = row.createCell(0);
                    cellOfRow.setCellValue(i + 1);
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(1);
                    cellOfRow.setCellValue(students.get(m).get(i).getFirstName() + " " + students.get(m).get(i).getLastName());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(2);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);


                    cellOfRow = row.createCell(3);
                    cellOfRow.setCellValue(students.get(m).get(i).getPersonnelNo2());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
                    rCellStyle8.setBorderBottom(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderTop(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderLeft(BorderStyle.MEDIUM);
                    rCellStyle8.setBorderRight(BorderStyle.MEDIUM);
                    cellOfRow.setCellStyle(rCellStyle8);

                    cellOfRow = row.createCell(4);
                    cellOfRow.setCellValue(students.get(m).get(i).getCcpAffairs());
                    rCellStyle8.setAlignment(HorizontalAlignment.CENTER);
                    rCellStyle8.setVerticalAlignment(VerticalAlignment.CENTER);
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
        } finally {
            if (workbook != null)
                workbook.close();
        }
    }//end exportToExcelFull
}
