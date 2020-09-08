/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TrainingFileNAReportDTO;
import com.nicico.training.iservice.ITrainingFileNAReportService;
import com.nicico.training.repository.TrainingFileNAReportDAO;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.util.List;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class TrainingFileNAReportService implements ITrainingFileNAReportService {

    private final TrainingFileNAReportDAO trainingFileNAReportDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(trainingFileNAReportDAO, request, converter);
    }

    @Override
    public void generateReport(HttpServletResponse response, List<String> personnelNos) throws Exception {

        TrainingFileNAReportDTO.GenerateReport generateReport = new TrainingFileNAReportDTO.GenerateReport();
/*        List<TrainingFileNAReportDTO.Row> headers=new ArrayList<>();
        headers.add(new TrainingFileNAReportDTO.Row());*/


        //generateReport.setHeaders()
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
