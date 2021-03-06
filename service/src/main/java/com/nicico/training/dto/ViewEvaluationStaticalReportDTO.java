package com.nicico.training.dto;

import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
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
        private Long unitId;
        private Long tclassId;
        private Long evaluationAnalysisId;
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
        private String courseEvaluation;
        private ETechnicalType courseTechnicalType;
        private ERunType courseRunType;
        private ETheoType courseTheoType;
        private ELevelType courseLevelType;
        private String classEvaluation;
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
        private Long tclassDuration;
        private Long tclassOrganizerId;
        private String tclassStatus;
        private String classCancelReasonId;
        private String classCancelReasonTitle;
        private Long tclassPlanner;
        private Long tclassSupervisor;
        private String termTitleFa;
        private String teacherFirstName;
        private String teacherLastName;
        private String teacherFullName;
        private String tclassReason;
        private String tclassTeachingType;
        private String plannerComplex;
        private String plannerAssistant;
        private String plannerAffairs;
        private String plannerSection;
        private String plannerUnit;
        private String plannerName;
        private String instituteName;
        private String presenceManHour;
        private String absenceManHour;
        private String unknownManHour;
        private String holdingClassTypeId;
        private String holdingClassTypeTitle;
        private String teachingMethodId;
        private String teachingMethodTitle;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Statical")
    public static class Statical{
        private Integer classCount_reaction;
        private Integer classCount_learning;
        private Integer classCount_behavioral;
        private Integer classCount_results;
        private Integer classCount_teacher;
        private Integer classCount_effectiveness;

        private Integer passed_reaction;
        private Integer passed_learning;
        private Integer passed_behavioral;
        private Integer passed_results;
        private Integer passed_teacher ;
        private Integer passed_effectiveness;

        private Integer failed_reaction;
        private Integer failed_learning;
        private Integer failed_behavioral;
        private Integer failed_results;
        private Integer failed_teacher;
        private Integer failed_effectiveness;
    }

}
