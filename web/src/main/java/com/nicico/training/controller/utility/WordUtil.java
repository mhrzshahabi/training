package com.nicico.training.controller.utility;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.xwpf.usermodel.*;
import org.springframework.stereotype.Component;

import java.text.NumberFormat;
import java.text.ParseException;
import java.util.List;

import static com.nicico.training.utility.MakeExcelOutputUtil.isNumericWithDot;

@Component
public class WordUtil {

    public void replacePOI(XWPFDocument doc, String placeHolder, String replaceText) {
        // REPLACE ALL HEADERS
        for (XWPFHeader header : doc.getHeaderList())
            replaceAllBodyElements(header.getBodyElements(), placeHolder, replaceText);
        // REPLACE BODY
        replaceAllBodyElements(doc.getBodyElements(), placeHolder, replaceText);
    }

    private void replaceAllBodyElements(List<IBodyElement> bodyElements, String placeHolder, String replaceText) {
        for (IBodyElement bodyElement : bodyElements) {
            if (bodyElement.getElementType().compareTo(BodyElementType.PARAGRAPH) == 0)
                replaceParagraph((XWPFParagraph) bodyElement, placeHolder, replaceText);
            if (bodyElement.getElementType().compareTo(BodyElementType.TABLE) == 0)
                replaceTable((XWPFTable) bodyElement, placeHolder, replaceText);
        }
    }

    private void replaceTable(XWPFTable table, String placeHolder, String replaceText) {
        for (XWPFTableRow row : table.getRows()) {
            for (XWPFTableCell cell : row.getTableCells()) {
                for (IBodyElement bodyElement : cell.getBodyElements()) {
                    if (bodyElement.getElementType().compareTo(BodyElementType.PARAGRAPH) == 0) {
                        replaceParagraph((XWPFParagraph) bodyElement, placeHolder, replaceText);
                    }
                    if (bodyElement.getElementType().compareTo(BodyElementType.TABLE) == 0) {
                        replaceTable((XWPFTable) bodyElement, placeHolder, replaceText);
                    }
                }
            }
        }
    }

    private void replaceParagraph(XWPFParagraph paragraph, String placeHolder, String replaceText) {
        for (XWPFRun r : paragraph.getRuns()) {
            String text = r.getText(r.getTextPosition());
            if (text != null && text.contains(placeHolder)) {
                text = text.replace(placeHolder, (replaceText != null ? replaceText : ""));
                r.setText(text, 0);
            }
        }
    }

    public static void SetValueWithCheckData(String tmpCell, Cell cell) {
        if (isNumericWithDot(tmpCell)){
            Number number = null;
            try {
                number = NumberFormat.getInstance().parse(tmpCell);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            if (number instanceof  Integer){
                cell.setCellValue(number.intValue());

            }else if (number instanceof Long){
                cell.setCellValue(number.longValue());
            }else if (number instanceof Double){
                cell.setCellValue(number.doubleValue());
            }else if (number instanceof Float){
                cell.setCellValue(number.floatValue());
            }
            cell.setCellType(CellType.NUMERIC);

        }else {
            cell.setCellValue(tmpCell);
        }    }
}
