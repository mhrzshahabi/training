package com.nicico.training.service;

import com.google.gson.Gson;
import com.nicico.training.iservice.IExportToFileService;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.*;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.List;

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

            //CellStyle mine = workbook.createCellStyle();
            //mine.setFillForegroundColor(IndexedColors.BLACK.index);
            //mine.setFillForegroundColor(IndexedColors.BLUE_GREY.index);
            //mine.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            //sheet.getRow(4).setRowStyle(mine);


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
