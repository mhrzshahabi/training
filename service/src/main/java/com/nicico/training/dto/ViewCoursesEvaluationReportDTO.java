package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

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
        private Integer classStudentStatusReaction;
        private String evaluationAnalysisReactionGrade;
        private String evaluationAnalysisReactionPass;
        private String evaluationAnalysisTeacherGrade;
        private String evaluationAnalysisTeacherPass;
    }
}
