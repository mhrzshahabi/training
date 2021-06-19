package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)

public class ViewReactionEvaluationFormulaReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewReactionEvaluationFormulaReportInfo")
    public static class Info {

        private Long classId;
        private String classCode;
        private String classStatus;
        private String classStartDate;
        private String classEndDate;
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private String categoryTitleFa;
        private String subCategoryTitleFa;
        private Double studentsGradeToTeacher;
        private Double studentsGradeToGoals;
        private Double studentsGradeToFacility;
        private Double teacherGradeToClass;
        private Double evaluatedPercent;
    }
}
