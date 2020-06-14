package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)

public class ViewEvaluationStaticalReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewEvaluationStaticalReportInfo")
    public static class Info{
        private Long id;
        private Long termId;
        private Long instituteId;
        private Long teacherId;
        private Integer tclassStudentsCount;
        private String tclassCode;
        private String tclassStartDate;
        private String tclassEndDate;
        private String tclassYear;
        private String courseCode;
        private Long courseCategory;
        private Long courseSubCategory;
        private String courseTitleFa;
        private String evaluation;
        private String evaluationBehavioralGrade;
        private Boolean evaluationBehavioralPass;
        private Boolean evaluationBehavioralStatus;
        private String evaluationEffectivenessGrade;
        private Boolean evaluationEffectivenessPass;
        private Boolean evaluationEffectivenessStatus;
        private String evaluationLearningGrade;
        private Boolean evaluationLearningPass;
        private Boolean evaluationLearningStatus;
        private String evaluationReactionGrade;
        private Boolean evaluationReactionPass;
        private Boolean evaluationReactionStatus;
        private String evaluationResultsGrade;
        private Boolean evaluationResultsPass;
        private Boolean evaluationResultsStatus;
        private String evaluationTeacherGrade;
        private Boolean evaluationTeacherPass;
        private Boolean evaluationTeacherStatus;
    }

}
