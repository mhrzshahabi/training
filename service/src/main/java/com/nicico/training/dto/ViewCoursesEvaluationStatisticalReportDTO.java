package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewCoursesEvaluationStatisticalReportDTO implements Serializable {

    private Long id;
    private Long classId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCoursesEvaluationStatisticalReportInfo")
    public static class Info extends ViewCoursesEvaluationStatisticalReportDTO {

        private String classCode;
        private String classStartDate;
        private String classEndDate;
        private Integer totalStudent;
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private String classYear;
        private Long termId;
        private Long categoryId;
        private String categoryTitleFa;
        private Long subCategoryId;
        private String subCategoryTitleFa;
        private Long teacherId;
        private String teacherNationalCode;
        private String teacherFullName;

        private String studentComplex;
        private String studentAssistant;
        private String studentAffairs;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCoursesEvaluationStatisticalReportDetail")
    public static class Detail {

        private boolean hasReactionEval;
        private boolean hasLearningEval;
        private boolean hasBehavioralEval;
        private boolean hasResultEval;
        private boolean effective;
        private boolean inEffective;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StatisticalData")
    public static class StatisticalData {

        private Integer totalClasses;
        private Integer numberOfReaction;
        private Integer numberOfLearning;
        private Integer numberOfBehavioral;
        private Integer numberOfResult;
        private Integer numberOfEffective;
        private Integer numberOfInEffective;
    }

}
