package com.nicico.training;

import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.SkillDTO;
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
}
