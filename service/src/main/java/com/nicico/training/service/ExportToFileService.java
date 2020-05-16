package com.nicico.training.service;

import com.google.gson.Gson;
import com.nicico.training.iservice.IExportToFileService;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.URLEncoder;
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
            Sheet sheet = workbook.createSheet("گزارش");
            sheet.setRightToLeft(true);

            Font headerFont = workbook.createFont();
            headerFont.setFontHeightInPoints((short) 12);
            headerFont.setFontName("b Titr");
            headerFont.setColor(IndexedColors.BLACK.getIndex());

            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);
            // headerCellStyle.setFillBackgroundColor(IndexedColors.BLUE.getIndex());
            // headerCellStyle.setFillForegroundColor(IndexedColors.BLUE.getIndex());

            Font bodyFont = workbook.createFont();
            bodyFont.setFontHeightInPoints((short) 12);
            bodyFont.setFontName("B Nazanin");

            CellStyle bodyCellStyle = workbook.createCellStyle();
            bodyCellStyle.setFont(bodyFont);

            //first row
            Font rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 16);
            rFont.setFontName("b Titr");

            CellStyle rCellStyle = workbook.createCellStyle();
            rCellStyle.setFont(rFont);

            CellReference cellAddress = new CellReference(0, fields1.size() - 1);
            sheet.addMergedRegion(CellRangeAddress.valueOf("A1:" + cellAddress.formatAsString()));
            Row row = sheet.createRow(0);
            Cell cellOfRow = row.createCell(0);
            cellOfRow.setCellValue("شركت ملي صنايع مس ايران- امور آموزش و تجهيز نيروي انساني");
            cellOfRow.setCellStyle(rCellStyle);

            //second row
            rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 14);
            rFont.setFontName("b Titr");

            rCellStyle = workbook.createCellStyle();
            rCellStyle.setFont(rFont);

            cellAddress = new CellReference(1, fields1.size() - 1);
            sheet.addMergedRegion(CellRangeAddress.valueOf("A2:" + cellAddress.formatAsString()));
            row = sheet.createRow(1);
            cellOfRow = row.createCell(0);
            cellOfRow.setCellValue("فرم " + pageName);
            cellOfRow.setCellStyle(rCellStyle);

            //third row
            rFont = workbook.createFont();
            rFont.setFontHeightInPoints((short) 12);
            rFont.setFontName("b Nazanin");

            rCellStyle = workbook.createCellStyle();
            rCellStyle.setFont(rFont);

            if(columns.length>3){
                cellAddress = new CellReference(2, fields1.size() - 1);
                sheet.addMergedRegion(CellRangeAddress.valueOf("D3:" + cellAddress.formatAsString()));
            }

            row = sheet.createRow(2);

            row.setHeight((short) 975);
            cellOfRow = row.createCell(3);
            cellOfRow.setCellValue(titr);
            cellOfRow.setCellStyle(rCellStyle);


            Row headerRow = sheet.createRow(3);

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerCellStyle);

            }

            /*CellStyle dateCellStyle = workbook.createCellStyle();
            dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd-MM-yyyy"));*/

            int rowNum = 3;
            for (HashMap<String, String> map : allData) {
                Row tempRow = sheet.createRow(++rowNum);
                for (int i = 0; i < columns.length; i++) {
                    Cell cell = tempRow.createCell(i);
                    cell.setCellValue(map.get(columns[i]).replaceAll("(<a)([^>href]+)(href)([ ])(=)([ ])\"([^\"])\"([^>]+)(>)([^<])(<\\/a>)","[link href=$7]$10[/link]").replaceAll("<[^>]*>",""));
                    cell.setCellStyle(bodyCellStyle);
                }
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            //CellStyle mine = workbook.createCellStyle();
            // mine.setFillForegroundColor(IndexedColors.BLACK.index);
            // mine.setFillForegroundColor(IndexedColors.BLUE_GREY.index);
            //mine.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            //sheet.getRow(4).setRowStyle(mine);


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
            throw new Exception("خطا در سرور");
        }
    }
}
