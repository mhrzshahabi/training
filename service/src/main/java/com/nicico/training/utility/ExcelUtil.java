/*
ghazanfari_f,
2/5/2020,
8:52 AM
*/
package com.nicico.training.utility;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.File;
import java.io.FileInputStream;
import java.util.Iterator;

public class ExcelUtil {

    static String datafilePath = "F:\\System\\Training\\Data\\TrainingData1.xlsx";

    public static void main(String[] args) {
        importCategoryData();
    }

    public static void importCategoryData() {
        try {
            FileInputStream file = new FileInputStream(new File(datafilePath));
            XSSFWorkbook workbook = new XSSFWorkbook(file);
            XSSFSheet sheet = workbook.getSheet("Category");
            Iterator<Row> rowIterator = sheet.iterator();
            for(int i = 0; i<2; i++)
                rowIterator.next();
            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
//                For each row, iterate through all the columns
                Iterator<Cell> cellIterator = row.cellIterator();
                while (cellIterator.hasNext()) {
                    Cell cell = cellIterator.next();
                    //Check the cell type and format accordingly
                    switch (cell.getCellType()) {
                        case Cell.CELL_TYPE_NUMERIC:
                            System.out.print(cell.getNumericCellValue() + "\t");
                            break;
                        case Cell.CELL_TYPE_STRING:
                            System.out.print(cell.getStringCellValue() + "\t");
                            break;
                    }
                }
//                System.out.println(row);
            }
            file.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}