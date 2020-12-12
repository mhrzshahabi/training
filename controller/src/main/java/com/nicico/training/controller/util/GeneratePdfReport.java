package com.nicico.training.controller.util;

import com.lowagie.text.Font;
import com.lowagie.text.Rectangle;
import com.lowagie.text.*;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import response.evaluation.EvalListResponse;
import response.evaluation.dto.EvalAnswerDto;
import response.evaluation.dto.EvalResultDto;
import response.evaluation.dto.PdfEvalResponse;
import response.exam.ExamAnswerDto;
import response.exam.ExamListResponse;
import response.exam.ExamResultDto;
import response.exam.PdfExamResponse;

import java.awt.*;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GeneratePdfReport {
    private static Font catFont = new Font(Font.TIMES_ROMAN, 18,
            Font.BOLD);
    ////    private static Font redFont = new Font(Font.TIMES_ROMAN, 12,
////            Font.NORMAL, BaseColor.RED);
//    private static Font subFont = new Font(Font.TIMES_ROMAN, 16,
//            Font.BOLD);
    private static Font smallBold = new Font(Font.TIMES_ROMAN, 12,
            Font.BOLD);

    public static ByteArrayInputStream ReportEvaluation(EvalListResponse data) {

        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {


            PdfWriter.getInstance(document, out);


            document.open();

            BaseFont bf = BaseFont.createFont(
                    "reports/fonts/bnazanin.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font font = new Font(bf, 16);
            Font headFont = new Font(bf, 20);
            Font spaceFont = new Font(bf, 2);



            PdfPTable table = new PdfPTable(1);
            table.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);

            table.setSpacingAfter(10);

            PdfPCell title = getCell("نتایج ارزیابی :", data.getTitle() , headFont, false,true);
            table.addCell(title);

            PdfPCell space = getCell("  ", " " , spaceFont, false,true);
            table.addCell(space);

            for (EvalResultDto result : data.getData()) {

                PdfPCell cell0 = getCell("اطلاعات کاربر :", " ", headFont, false,false);
                table.addCell(cell0);

                PdfPCell cell = getCell("نام : ", result.getSurname(), font, false,false);
                table.addCell(cell);
                PdfPCell cell2 = getCell("نام خانوادگی  : ", result.getLastName(), font,false, false);
                table.addCell(cell2);
                PdfPCell cell3 = getCell("کد ملی : ", result.getNationalCode(), font, false,false);
                table.addCell(cell3);
                PdfPCell cell4 = getCell("شماره همراه: ", result.getCellNumber(), font, false,false);
                table.addCell(cell4);

                PdfPCell line = getCell(" ", "", font, true,false);
                table.addCell(line);

                for (EvalAnswerDto answer : result.getAnswers()) {
                    PdfPCell line2 = getCell(" ", "", font, false,false);
                    table.addCell(line2);

                    PdfPCell cell6 = getCell("سوال: ", answer.getQuestion(), headFont, false,false);
                    table.addCell(cell6);
                    PdfPCell cell7 = getCell("جواب: ", answer.getAnswer(), font, false,false);
                    table.addCell(cell7);

                }
                PdfPCell cell5 = getCell("توضیحات: ", result.getDescription(), font, false,false);
                table.addCell(cell5);
                PdfPCell line2 = getCell(" ", "", headFont, true,false);
                table.addCell(line2);


            }
            document.add(table);


            document.close();

        } catch (DocumentException | IOException ex) {

            Logger.getLogger(GeneratePdfReport.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new ByteArrayInputStream(out.toByteArray());
    }
    public static ByteArrayInputStream ReportExam(ExamListResponse data) {

        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {


            PdfWriter.getInstance(document, out);


            document.open();

            BaseFont bf = BaseFont.createFont(
                    "reports/fonts/bnazanin.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            Font font = new Font(bf, 16);
            Font headFont = new Font(bf, 20);
            Font spaceFont = new Font(bf, 2);



            PdfPTable table = new PdfPTable(1);
            table.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);

            table.setSpacingAfter(10);

            PdfPCell title = getCell("نتایج آزمون :", "" , headFont, false,true);
            table.addCell(title);

            PdfPCell space = getCell("  ", " " , spaceFont, false,true);
            table.addCell(space);

            for (ExamResultDto result : data.getData()) {

                PdfPCell cell0 = getCell("اطلاعات کاربر :", " ", headFont, false,false);
                table.addCell(cell0);

                PdfPCell cell = getCell("نام : ", result.getSurname(), font, false,false);
                table.addCell(cell);
                PdfPCell cell2 = getCell("نام خانوادگی  : ", result.getLastName(), font,false, false);
                table.addCell(cell2);
                PdfPCell cell3 = getCell("کد ملی : ", result.getNationalCode(), font, false,false);
                table.addCell(cell3);
                PdfPCell cell4 = getCell("شماره همراه: ", result.getCellNumber(), font, false,false);
                table.addCell(cell4);

                PdfPCell line = getCell(" ", "", font, true,false);
                table.addCell(line);

                for (ExamAnswerDto answer : result.getAnswers()) {
                    PdfPCell line2 = getCell(" ", "", font, false,false);
                    table.addCell(line2);

                    PdfPCell cell6 = getCell("سوال: ", answer.getQuestion(), headFont, false,false);
                    table.addCell(cell6);
                    PdfPCell cell7 = getCell("جواب: ", answer.getAnswer(), font, false,false);
                    table.addCell(cell7);

                }

                PdfPCell line2 = getCell(" ", "", headFont, true,false);
                table.addCell(line2);


            }
            document.add(table);


            document.close();

        } catch (DocumentException | IOException ex) {

            Logger.getLogger(GeneratePdfReport.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new ByteArrayInputStream(out.toByteArray());
    }

    private static PdfPCell getCell(String preText, String text, Font headFont, boolean isEnd,boolean hasBackground) {
        String data = "-";
        if (text != null)
            data = text;
        PdfPCell cellOne = new PdfPCell(new Phrase(preText + data, headFont));
        cellOne.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
        if (isEnd) {
            cellOne.setBorder(PdfPCell.BOTTOM);
            cellOne.setBorderWidthBottom(1f);
            cellOne.setPaddingBottom(5);
            cellOne.setVerticalAlignment(Element.ALIGN_MIDDLE);

        } else {
            cellOne.setBorder(Rectangle.NO_BORDER);
            cellOne.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cellOne.setPadding(5);


        }
        cellOne.setUseBorderPadding(true);

        if (hasBackground)
        {

            cellOne.setBackgroundColor(Color.gray);

        }
        return cellOne;
    }

//
//    private static void addTitlePage(Document document, Font headFont)
//            throws DocumentException {
//        Paragraph preface = new Paragraph();
//        // We add one empty line
//        addEmptyLine(preface, 1);
//        // Lets write a big header
//        preface.add(new Paragraph("Title of the document", headFont));
//
//        addEmptyLine(preface, 1);
//        // Will create: Report generated by: _name, _date
//        preface.add(new Paragraph(
//                "Report generated by: " + System.getProperty("user.name") + ", " + new Date(), //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
//                smallBold));
//        addEmptyLine(preface, 3);
//        preface.add(new Paragraph(
//                "This document describes something which is very important ",
//                smallBold));
//
//        addEmptyLine(preface, 8);
//
//        preface.add(new Paragraph(
//                "This document is a preliminary version and not subject to your license agreement or any other agreement with vogella.com ;-).",
//                smallBold));
//
//        document.add(preface);
//        // Start a new page
//        document.newPage();
//    }

    private static void addEmptyLine(Paragraph paragraph, int number) {
        for (int i = 0; i < number; i++) {
            paragraph.add(new Paragraph(" "));
        }
    }


}