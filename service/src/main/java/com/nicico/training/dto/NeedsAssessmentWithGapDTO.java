package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentWithGapDTO implements Serializable {
    @NotNull
    @ApiModelProperty(required = true)
    private Long objectId;
    @NotNull
    @ApiModelProperty(required = true)
    private String objectType;
    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceId;
    private String limitSufficiency;
    @NotNull
    @ApiModelProperty(required = true)
    private Long skillId;
    @NotNull
    @ApiModelProperty(required = true)
    private Long needsAssessmentDomainId;
    @NotNull
    @ApiModelProperty(required = true)
    private Long needsAssessmentPriorityId;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentWithGapDTO - Info")
    public static class Info extends NeedsAssessmentWithGapDTO {
        private Long id;
        private Integer version;
        private String objectName;
        private String objectCode;
        private String workflowStatus;
        private Integer workflowStatusCode;
        private String mainWorkflowStatus;
        private Integer mainWorkflowStatusCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentWithGapDTO - ReportInfo")
    public static class ReportInfo {
        private Long id;
        private CompetenceDTO.NeedsAssessmentReportInfo2 competence;
        private SkillDTO.NeedsAssessmentReportInfo skill;
        private Long needsAssessmentDomainId;
        private Long needsAssessmentPriorityId;
        private Long limitSufficiency;
        private String  committeeScore;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentWithGapDTO - verify")
    public static class verify extends NeedsAssessmentWithGapDTO {
        private Long id;
        private String objectName;
        private String objectCode;
        private String workflowStatus;
        private Integer workflowStatusCode;
        private String mainWorkflowStatus;
        private Integer mainWorkflowStatusCode;
        private Date createdDate;
        private String createdBy;
        private Long enabled;
        private Long deleted;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentWithGapDTO - Tree")
    public static class Tree extends Info {
        private Long parentId;
        private String name;
        private String competenceTypeTitle;
        private String competenceNameTitle;
        private String needsAssessmentDomainTitle;
        private String needsAssessmentPriorityTitle;
        private String skillTitle;
        private String skillCourseTitle;

        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31).
                    append(competenceNameTitle).
                    append(competenceTypeTitle).
                    append(needsAssessmentDomainTitle).
                    append(needsAssessmentPriorityTitle).
                    append(skillTitle).
                    toHashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof NeedsAssessmentWithGapDTO))
                return false;
            return (this.getId().equals(((Tree) obj).getId()));
        }
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CreateNeedAssessment - Info")
    public static class CreateNeedAssessment {
        private Long objectId;
        private Long competenceId;
        private Long needsAssessmentDomainId;
        private String objectType;
        private List<CreateNeedAssessmentSkill> createNeedAssessmentSkills;

    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CreateNeedAssessmentSkill - Info")
    public static class CreateNeedAssessmentSkill {
        private Long id;
        private Long courseId;
        private Float limitSufficiency;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentWithGapDTO - allCompetence")
    public static class allCompetence extends NeedsAssessmentWithGapDTO {

        private String code;
        private String title;
        private String competenceType;
        private String needsAssessmentDomain;
        private String needsAssessmentPriority;
        private String courseTitleFa;
        private String courseCode;

    }
}
