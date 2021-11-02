package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewReactionEvaluationFormulaReportDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.service.ViewReactionEvaluationFormulaReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view_reaction_evaluation_formula_report")
public class ViewReactionEvaluationFormulaReportRestController {
    private static final DecimalFormat df = new DecimalFormat("0.00");
    private final ITclassService iTclassService;
    private final ViewReactionEvaluationFormulaReportService viewReactionEvaluationFormulaReportService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewReactionEvaluationFormulaReportDTO.Info>> iscList(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewReactionEvaluationFormulaReportDTO.Info> searchRs = viewReactionEvaluationFormulaReportService.search(searchRq);
        ISC<ViewReactionEvaluationFormulaReportDTO.Info> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        List<ViewReactionEvaluationFormulaReportDTO.Info> data = infoISC.getResponse().getData();

        data.forEach(d -> {
            Map<String, Double> formulaResult = iTclassService.getClassReactionEvaluationFormula(d.getClassId());
            if (formulaResult.get("studentsGradeToTeacher") != null)
                d.setStudentsGradeToTeacher(Double.valueOf(df.format(formulaResult.get("studentsGradeToTeacher"))));
            d.setStudentsGradeToGoals(formulaResult.get("studentsGradeToGoals"));
            d.setStudentsGradeToFacility(formulaResult.get("studentsGradeToFacility"));
            if (formulaResult.get("teacherGradeToClass") != null)
                d.setTeacherGradeToClass(Double.valueOf(df.format(formulaResult.get("teacherGradeToClass"))));

            if (formulaResult.get("trainingGradeToTeacher") != null)
                d.setTrainingGradeToTeacher(Double.valueOf(df.format(formulaResult.get("trainingGradeToTeacher"))));
            d.setEvaluatedPercent(formulaResult.get("evaluatedPercent"));
            d.setAnsweredStudentsNum(formulaResult.get("answeredStudentsNum"));
            d.setAllStudentsNum(formulaResult.get("allStudentsNum"));
        });

        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
