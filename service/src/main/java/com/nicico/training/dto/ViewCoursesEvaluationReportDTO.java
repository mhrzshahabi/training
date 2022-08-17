package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.text.DecimalFormat;

@Getter
@Setter
@Accessors(chain = true)
public class ViewCoursesEvaluationReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCoursesEvaluationReportInfo")
    public static class Info {
        private String classCode;
        private String classStatus;
        private String classStartDate;
        private String classEndDate;
        private String courseCode;
        private String courseTitleFa;
        private String categoryTitleFa;
        private String subCategoryTitleFa;
        private Long subCategoryId;
        private Integer classStudentStatusReaction;
        private String evaluationAnalysisReactionGrade;

        public String getEvaluationAnalysisReactionGrade() {
            if (evaluationAnalysisReactionGrade!=null)
                return new DecimalFormat("#.00").format(Double.parseDouble(evaluationAnalysisReactionGrade));
            return null;
        }

        private String evaluationAnalysisReactionPass;
        public String getEvaluationAnalysisReactionPass() {
            if (evaluationAnalysisReactionPass!=null && evaluationAnalysisReactionPass.equals("1")) {
                return "نهایی شده";
            } else {
                return "ناقص";
            }
        }
        private String evaluationAnalysisTeacherGrade;
        public String getEvaluationAnalysisTeacherGrade() {
            if (evaluationAnalysisTeacherGrade!=null)
            return new DecimalFormat("#.00").format(Double.parseDouble(evaluationAnalysisTeacherGrade));
            return null;
        }
        private String evaluationAnalysisTeacherPass;
    }
}
