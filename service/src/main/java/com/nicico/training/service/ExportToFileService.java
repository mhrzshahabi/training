package com.nicico.training.service;

import com.google.gson.Gson;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IExportToFileService;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;
import org.apache.poi.xwpf.usermodel.*;
import org.modelmapper.TypeToken;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTSectPr;
import org.springframework.stereotype.Service;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.io.*;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ExportToFileService implements IExportToFileService {



    @Override
    public void exportToExcel(HttpServletResponse response, String fields, String data, String titr, String pageName) throws Exception {

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);
        List<HashMap<String, String>> allData = gson.fromJson(data, resultType);

        try {

            String[] headers = new String[fields1.size()];
            String[] columns = new String[fields1.size()];
            for (int i = 0; i < fields1.size(); i++) {
                headers[i] = fields1.get(i).get("title");
                columns[i] = fields1.get(i).get("name");
            }

            XSSFWorkbook workbook = new XSSFWorkbook();
            //CreationHelper createHelper = workbook.getCreationHelper();
            XSSFSheet sheet = workbook.createSheet("گزارش");
            sheet.setRightToLeft(true);

            XSSFCellStyle headerCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, new Color(0, 0, 0), null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);
            headerCellStyle.getFont().setBold(true);


            XSSFCellStyle bodyCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, null, null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);

            //first row
            XSSFCellStyle rCellStyle = setCellStyle(workbook, "Tahoma", (short) 16, new Color(0, 0, 0), null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);

            CellReference cellAddress = new CellReference(0, fields1.size() - 1);
            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:" + cellAddress.formatAsString()));
            XSSFRow row = sheet.createRow(0);
            XSSFCell cellOfRow = row.createCell(0);
            cellOfRow.setCellValue("شركت ملي صنايع مس ايران- امور آموزش و تجهيز نيروی انسانی");
            cellOfRow.setCellStyle(rCellStyle);

            //second row
            rCellStyle = setCellStyle(workbook, "Tahoma", (short) 14, new Color(0, 0, 0), null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);

            cellAddress = new CellReference(1, fields1.size() - 1);
            sheet.addMergedRegion(CellRangeAddress.valueOf("A2:" + cellAddress.formatAsString()));
            row = sheet.createRow(1);
            cellOfRow = row.createCell(0);
            cellOfRow.setCellValue("فرم " + pageName);
            cellOfRow.setCellStyle(rCellStyle);

            //third row
            rCellStyle = setCellStyle(workbook, "Tahoma", (short) 12, new Color(0, 0, 0), null, VerticalAlignment.CENTER, HorizontalAlignment.CENTER);

            //if (columns.length > 4) {
            cellAddress = new CellReference(2, fields1.size() - 1);
            sheet.addMergedRegion(CellRangeAddress.valueOf("A3:" + cellAddress.formatAsString()));
            //}

            row = sheet.createRow(2);

            row.setHeight((short) 1350);
            cellOfRow = row.createCell(0);
            cellOfRow.setCellValue(titr);
            rCellStyle.setWrapText(true);
            cellOfRow.setCellStyle(rCellStyle);


            XSSFRow headerRow = sheet.createRow(3);

            for (int i = 0; i < columns.length; i++) {
                XSSFCell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);

            }

            /*CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));*/

            int rowNum = 3;
            String tmpCell = "";
            for (HashMap<String, String> map : allData) {
                XSSFRow tempRow = sheet.createRow(++rowNum);
                for (int i = 0; i < columns.length; i++) {
                    XSSFCell cell = tempRow.createCell(i);
                    tmpCell = map.get(columns[i]) == null ? "" : map.get(columns[i]);
                    tmpCell = tmpCell.replaceAll("(<a)([^>href]+)(href)([ ])(=)([ ])\"([^\"])\"([^>]+)(>)([^<])(<\\/a>)", "[link href=$7]$10[/link]").replaceAll("<[^>ابپتثجچحخدذرزژصضسشطظکگفقعغونيي]*>", "");

                    /*if(tmpCell.matches(".*[ابپتثجچحخدذرزژصضسشطظکگفقعغونيي].*")){
                        tmpCell="\u200F" + tmpCell;
                    }*/
                    cell.setCellValue(tmpCell);
                    cell.setCellStyle(bodyCellStyle);
                }
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            int sumWidth = 0;

            for (int i = 0; i < columns.length; i++) {
                sumWidth += sheet.getColumnWidth(i);
            }

            if (sumWidth < 26000) {
                sheet.setColumnWidth(columns.length - 1, 26000 - sumWidth);
            }


            String mimeType = "application/octet-stream";
            String fileName = URLEncoder.encode("ExportExcel.xlsx", "UTF-8").replace("+", "%20");
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            workbook.write(response.getOutputStream()); // Write workbook to response.

            workbook.close();

        } catch (Exception ex) {
            throw new Exception("خطا در سرور");
        }
    }

    @Override
    public void exportToWord(HttpServletResponse response, String fields, String data, String titr, String pageName, Map<String, String> titles) throws Exception {
        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);
        List<HashMap<String, String>> allData = gson.fromJson(data, resultType);
        try {
            XWPFDocument doc = new XWPFDocument();
            CTSectPr sectPr = doc.getDocument().getBody().addNewSectPr();
            XWPFHeaderFooterPolicy headerFooterPolicy = new XWPFHeaderFooterPolicy(doc, sectPr);
            XWPFHeader header = headerFooterPolicy.createHeader(XWPFHeaderFooterPolicy.DEFAULT);
            XWPFParagraph paragraph = header.getParagraphArray(0);
            if (paragraph == null) paragraph = header.createParagraph();
            paragraph.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun run = paragraph.createRun();
            run.setFontSize(8);
            run.setText("شركت ملي صنايع مس ايران- امور آموزش و تجهيز نيروی انسانی");
            paragraph = header.createParagraph();
            paragraph.setAlignment(ParagraphAlignment.CENTER);
            run = paragraph.createRun();
            run.setFontSize(6);
            run.setText(pageName);
            if (titles != null && !titles.isEmpty()) {
                paragraph = doc.createParagraph();
                paragraph.setFontAlignment(ParagraphAlignment.RIGHT.getValue());
                XWPFTable table = paragraph.getBody().insertNewTbl(paragraph.getCTP().newCursor());
                table.setTableAlignment(TableRowAlign.RIGHT);
                table.setWidthType(TableWidthType.PCT);
                table.setWidth(10000);
                XWPFTableRow row = table.getRow(0);
                if (row == null) row = table.createRow();
                Set<String> keySet = titles.keySet();
                int ix = 0;
                for (String s : keySet) {
                    XWPFTableCell cell = row.getCell(ix++);
                    if (cell == null) cell = row.createCell();
                    cell.setVerticalAlignment(XWPFTableCell.XWPFVertAlign.CENTER);
                    cell.getParagraphs().get(0).setVerticalAlignment(TextAlignment.AUTO);
                    run = cell.getParagraphs().get(0).createRun();
                    run.setFontSize(4);
                    run.setBold(true);
                    run.setText(s);
                }
                row = table.createRow();
                ix = 0;
                for (String s : keySet) {
                    XWPFTableCell cell = row.getCell(ix++);
                    if (cell == null) cell = row.createCell();
                    cell.setVerticalAlignment(XWPFTableCell.XWPFVertAlign.CENTER);
                    cell.getParagraphs().get(0).setVerticalAlignment(TextAlignment.AUTO);
                    run = cell.getParagraphs().get(0).createRun();
                    run.setFontSize(3);
                    run.setBold(false);
                    run.setText(titles.get(s));
                }
            }

            String[] headers = new String[fields1.size()];
            String[] columns = new String[fields1.size()];
            for (int i = 0; i < fields1.size(); i++) {
                headers[i] = fields1.get(fields1.size() - i - 1).get("title");
                columns[i] = fields1.get(fields1.size() - i - 1).get("name");
            }
            String tmpCell;
            paragraph = doc.createParagraph();
            paragraph.setFontAlignment(ParagraphAlignment.RIGHT.getValue());
            XWPFTable table = paragraph.getBody().insertNewTbl(paragraph.getCTP().newCursor());
            table.setTableAlignment(TableRowAlign.RIGHT);
            table.setWidthType(TableWidthType.PCT);
            table.setWidth(10000);
            XWPFTableRow row = table.getRow(0);
            if (row == null) row = table.createRow();
            for (int i = 0; i < headers.length; i++) {
                XWPFTableCell cell = row.getCell(i);
                if (cell == null) cell = row.createCell();
                cell.setVerticalAlignment(XWPFTableCell.XWPFVertAlign.CENTER);
                cell.getParagraphs().get(0).setVerticalAlignment(TextAlignment.AUTO);
                run = cell.getParagraphs().get(0).createRun();
                run.setFontSize(4);
                run.setBold(true);
                run.setText(headers[i]);
            }
            for (HashMap<String, String> map : allData) {
                row = table.createRow();
                for (int i = 0; i < columns.length; i++) {
                    tmpCell = map.get(columns[i]) == null ? "" : map.get(columns[i]);
                    tmpCell = tmpCell.replaceAll("(<a)([^>href]+)(href)([ ])(=)([ ])\"([^\"])\"([^>]+)(>)([^<])(<\\/a>)", "[link href=$7]$10[/link]").replaceAll("<[^>ابپتثجچحخدذرزژصضسشطظکگفقعغونيي]*>", "");
                    XWPFTableCell cell = row.getCell(i);
                    if (cell == null) cell = row.createCell();
                    paragraph = cell.getParagraphs().get(0);
                    run = paragraph.createRun();
                    run.setFontSize(3);
                    run.setText(tmpCell);
                }
            }
            String mimeType = "application/octet-stream";
            String fileName = URLEncoder.encode("ExportWord.docx", "UTF-8").replace("+", "%20");
            String headerKey = "Content-Disposition";
            String headerValue;
            response.setContentType(mimeType);
            headerValue = String.format("attachment; filename=\"%s\"", fileName);
            response.setHeader(headerKey, headerValue);
            doc.write(response.getOutputStream());
            doc.close();
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

    @Override
    public String exportToExcel(Map<Integer, Object[]> dataMap) {

        String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date());
        String fileName = "export-"+timeStamp+".xlsx";
//        String fileName = "export.xlsx";

        //Create blank workbook
        XSSFWorkbook workbook = new XSSFWorkbook();

        //Create a blank sheet
        XSSFSheet sheet = workbook.createSheet("export");

        //Create row object
        XSSFRow row;

        //Iterate over data and write to sheet
        Set<Integer> keyid = dataMap.keySet();
        int rowNum = 0;

        System.out.println("Creating excel");

        for (Integer key : keyid) {
            row = sheet.createRow(rowNum++);
            Object[] objectArr = dataMap.get(key);
            int cellid = 0;

            for (Object obj : objectArr) {
                Cell cell = row.createCell(cellid++);
                cell.setCellValue((String) obj);
            }
        }

        try {
            FileOutputStream outputStream = new FileOutputStream(fileName);
            workbook.write(outputStream);
            workbook.close();
            outputStream.close();
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
        }
        return fileName;
    }
}
