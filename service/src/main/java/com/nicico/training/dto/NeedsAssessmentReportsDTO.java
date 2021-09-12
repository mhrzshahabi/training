package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentReportsDTO implements Serializable {

    @Getter
    @Setter
    @ApiModel("NeedsAssessment - Courses")
    public static class NeedsCourses {
        private Long id;
        private String code;
        private String titleFa;
        private Float theoryDuration;
        private Long needsAssessmentPriorityId;
        private String status;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - ReportInfo")
    public static class ReportInfo {
        private Long id;
        private CompetenceDTO.NeedsAssessmentReportInfo competence;
        private SkillDTO.NeedsAssessmentReportInfo skill;
        private Long needsAssessmentDomainId;
        private Long needsAssessmentPriorityId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - ReportGroupInfo")
    public static class ReportGroupInfo {
        private Long id;
        private Long postCode;
        private String personnelName;
        private String personnelNo;
        private String personnelAffairsName;
        private Long courseCode;
        private String courseTitle;
        private String competenceTitle;
        private String skillTitle;
        private String scoreState;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - CourseNAS")
    public static class CourseNAS {
        private Long needsAssessmentPriorityId;
        private Integer passedPersonnelCount = 0;
        private Integer TotalPersonnelCount = 0;
    }
}
