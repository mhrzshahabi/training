package com.nicico.training.controller.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.OAuth2RestTemplate;
import org.springframework.security.oauth2.client.token.grant.password.ResourceOwnerPasswordResourceDetails;

import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Constructor;
import java.net.URI;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ExcelUtil {

    static final String baseUrl = "http://localhost:8080/training/api/";
    final static String baseDTOPath = "com.nicico.training.dto";
    static String excelFilePath = "E:\\System\\Training\\Data\\Converted\\forConvert(n3) Part 1 For Import.xlsx";

    static OAuth2RestTemplate restTemplate;
    static URI uri;

    static {
        configRestTemplate();
    }

    public static void main(String[] args) {
        try {
            parseWorkbook();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void configRestTemplate() {
        try {
            ResourceOwnerPasswordResourceDetails resourceDetails = new ResourceOwnerPasswordResourceDetails();
            resourceDetails.setGrantType("password");
            resourceDetails.setClientId("Training");
            resourceDetails.setClientSecret("password");
            resourceDetails.setUsername("ghazanfari_f");
            resourceDetails.setPassword("password");
            resourceDetails.setAccessTokenUri("http://devapp01.icico.net.ir/oauth/token");
            restTemplate = new OAuth2RestTemplate(resourceDetails);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void parseWorkbook() {
        FileInputStream file = null;
        try {
            file = new FileInputStream(new File(excelFilePath));
            XSSFWorkbook workbook = new XSSFWorkbook(file);

            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);
                String className = sheet.getSheetName() + "DTO";

                Class<?> clazz = Class.forName(baseDTOPath + "." + className + "$" + "Create");
                Constructor<?> constructor = clazz.getConstructor();
                char[] chArr = sheet.getSheetName().toCharArray();
                chArr[0] = Character.toLowerCase(chArr[0]);
                uri = new URI(baseUrl + new String(chArr));

                Iterator<Row> rowIterator = sheet.iterator();
                Row row;
                int colsNum = 0;

                List<String> fields = new ArrayList<>();
                if (rowIterator.hasNext()) {
                    row = rowIterator.next();
                    colsNum = row.getLastCellNum();
                    for (int c = 0; c <= colsNum; c++) {
                        Cell cell = row.getCell(c);
                        if (!(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK)) {
                            fields.add(cell.toString());
                        }
                    }
                }

                while (rowIterator.hasNext()) {
                    row = rowIterator.next();
                    JsonObject jsonObject = new JsonObject();
                    for (int c = 0; c <= colsNum; c++) {
                        Cell cell = row.getCell(c);
                        String value = null;
                        if (!(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK)) {
                            value = getCellValue(cell);
                            if (value != null && !value.isEmpty()) {
                                jsonObject.addProperty(fields.get(c), value.trim());
                            }
                        }
                    }
                    Object object = new Gson().fromJson(jsonObject, clazz);
                    ResponseEntity<String> result = null;
                    try {
                        result = restTemplate.postForEntity(uri, object, String.class);
                        System.out.println(result.getStatusCode());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        System.out.println(result);
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                file.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    private static String getCellValue(Cell cell) {

        String value = null;
        if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
            Double doubleValue = cell.getNumericCellValue();
            value = doubleValue.toString().replaceAll("\\.?0*$", "");
        } else if (cell.getCellType() == Cell.CELL_TYPE_FORMULA) {
            switch (cell.getCachedFormulaResultType()) {
                case Cell.CELL_TYPE_NUMERIC:
                    Double doubleValue = cell.getNumericCellValue();
                    value = doubleValue.toString().replaceAll("\\.?0*$", "");
                    break;
                case Cell.CELL_TYPE_STRING:
                    value = cell.getRichStringCellValue().toString();
                    break;
            }
        } else {
            value = cell.toString();
        }
        return value;
    }
}

//
//                if(sheet.getSheetName().equals("PreCourse")) {
//
//                        Iterator<Row> rowIterator = sheet.iterator();
//        Row row = rowIterator.next();
//
//        while (rowIterator.hasNext()) {
//        row = rowIterator.next();
//        String courseId = getCellValue(row.getCell(0));
//        List<Long> test = new ArrayList<>();
//        test.add(38L);
//        Long preCourseCells = Long.parseLong(getCellValue(row.getCell(1)));
//
//        uri = new URI(baseUrl + "course/setPreCourse/" + courseId);
//
//        try {
//        restTemplate.put(uri, preCourseCells);
//        } catch (Exception ex) {
//        ex.printStackTrace();
//        }
//        }
//        }