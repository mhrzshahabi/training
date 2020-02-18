/*
ghazanfari_f,
2/5/2020,
8:52 AM
*/
package com.nicico.training.controller.util;

import com.nicico.training.dto.CategoryDTO;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Iterator;

public class ExcelUtil {

    public static void main(String[] args) {
        try {
            getToken();
            importCategoryData();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void getToken() {
        try {
            HttpClient client = HttpClientBuilder.create().build();
            HttpPost post = new HttpPost("http://devapp01.icico.net.ir/oauth/authorize?response_type=code&client_id=Training&scope=user_info&username=ghazanfari_f&password=password");
            HttpResponse response = client.execute(post);
            BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            String resp1 = rd.readLine();
            JSONObject obj = new JSONObject(resp1);
            String token = obj.getString("access_token");
            System.out.println(response);
        } catch (Exception ex) {
        }
    }

    public static void importCategoryData() {

        try {
            String datafilePath = "E:\\System\\Training\\Data\\forConvert(n1)Import.xlsx";
            FileInputStream file = new FileInputStream(new File(datafilePath));
            XSSFWorkbook workbook = new XSSFWorkbook(file);

            XSSFSheet sheet = workbook.getSheet("Category");
            CategoryDTO.Create category = new CategoryDTO.Create();

            Iterator<Row> rowIterator = sheet.iterator();
            Row row = rowIterator.next();
            int colsNum = row.getLastCellNum();

            int rowCounter = 1;
            while (rowIterator.hasNext()) {
                System.out.println("***************************** " + rowCounter++);
                row = rowIterator.next();
                for (int i = 1; i <= colsNum; i++) {
                    Cell cell = row.getCell(i);
                    if (!(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK)) {
                        switch (i) {
                            case 1:
                                category.setTitleFa(row.getCell(i).toString().trim());
                                break;
                            case 2:
                                category.setCode(row.getCell(i).toString().trim());
                                break;
                            case 3:
                                category.setTitleEn(row.getCell(i).toString().trim());
                                break;
                            case 4:
                                category.setDescription(row.getCell(i).toString().trim());
                                break;
                            default:
                        }
                    }
                }

                HttpClient client = HttpClientBuilder.create().build();
                HttpPost httpPost = new HttpPost("http://localhost:8080/training/api/category");
                httpPost.setHeader("Content-Type", "application/json;charset=UTF-8");
                httpPost.addHeader("Authorization", "Bearer d8548df7-6c3f-407f-99be-0122efa722fe");
                JSONObject jsonObject = new JSONObject(category);
                httpPost.setEntity(new StringEntity(jsonObject.toString(), "UTF-8"));
                HttpResponse response = client.execute(httpPost);
                int responseCode = response.getStatusLine().getStatusCode();
                if (!((responseCode == 200) || (responseCode == 201))) {
                    Cell c = row.createCell(colsNum + 1, Cell.CELL_TYPE_STRING);
                    c.setCellValue(responseCode);
                }
            }
//            try (FileOutputStream outputStream = new FileOutputStream(datafilePathResult)) {
//                workbook.write(outputStream);
//            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}