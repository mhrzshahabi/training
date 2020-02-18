package com.nicico.training.controller.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.OAuth2RestTemplate;
import org.springframework.security.oauth2.client.token.grant.password.ResourceOwnerPasswordResourceDetails;

import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ExcelUtil {

    final String baseUrl = "http://localhost:8080/training/api/";
    final static String baseDTOPath = "com.nicico.training.dto";
    static String excelFilePath = "E:\\System\\Training\\Data\\forConvert(n1)Import.xlsx";
    static String resultExcelFilePath = "E:\\System\\Training\\Data\\forConvert(n1)ImportResult.xlsx";

    public static void main(String[] args) {
        try {
            parseWorkbook();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static OAuth2RestTemplate getRestTemplate() {

        OAuth2RestTemplate restTemplate = null;
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
        return restTemplate;
    }

    public static void parseWorkbook() {
        FileInputStream file = null;
        ModelMapper modelMapper = new ModelMapper();
        try {
            file = new FileInputStream(new File(excelFilePath));
            XSSFWorkbook workbook = new XSSFWorkbook(file);

            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);

                String className = sheet.getSheetName() + "DTO";

                Class<?> clazz = Class.forName(baseDTOPath + "." + className + "$" + "Create");
                Constructor<?> constructor = clazz.getConstructor();

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
                        if (!(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK)) {
                            jsonObject.addProperty(fields.get(c), cell.toString());
                        }
                    }
                    Object object = new Gson().fromJson(jsonObject, clazz);
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
}


///
//        public static void assignCategory (Row row,int colNums){
//            CategoryDTO.Create category = new CategoryDTO.Create();
//            try {
//                for (int i = 1; i <= colNums; i++) {
//                    Cell cell = row.getCell(i);
//                    if (!(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK)) {
//                        switch (i) {
//                            case 1:
//                                category.setTitleFa(row.getCell(i).toString().trim());
//                                break;
//                            case 2:
//                                category.setCode(row.getCell(i).toString().trim());
//                                break;
//                            case 3:
//                                category.setTitleEn(row.getCell(i).toString().trim());
//                                break;
//                            case 4:
//                                category.setDescription(row.getCell(i).toString().trim());
//                                break;
//                            default:
//                        }
//                    }
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//
//        public static void importCategoryData (XSSFSheet sheet){
//
//            try {
////                HttpClient client = HttpClientBuilder.create().build();
////                HttpPost httpPost = new HttpPost("http://localhost:8080/training/api/category");
////                httpPost.setHeader("Content-Type", "application/json;charset=UTF-8");
////                httpPost.addHeader("Authorization", "Bearer d8548df7-6c3f-407f-99be-0122efa722fe");
////                JSONObject jsonObject = new JSONObject(category);
////                httpPost.setEntity(new StringEntity(jsonObject.toString(), "UTF-8"));
////                HttpResponse response = client.execute(httpPost);
////                int responseCode = response.getStatusLine().getStatusCode();
////                if (!((responseCode == 200) || (responseCode == 201))) {
////                    Cell c = row.createCell(colsNum + 1, Cell.CELL_TYPE_STRING);
////                    c.setCellValue(responseCode);
////                }
//                }
////            try (FileOutputStream outputStream = new FileOutputStream(datafilePathResult)) {
////                workbook.write(outputStream);
////            }
//            } catch (Exception e) {
//                e.printStackTrace();
//
//            }
//        }
//    }

