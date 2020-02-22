/*
ghazanfari_f,
1/14/2020,
1:48 PM
*/
package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentDTO implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private Long objectId;

    @NotNull
    @ApiModelProperty(required = true)
    private String objectType;

    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceId;

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
    @ApiModel("NeedsAssessmentDTO - Info")
    public static class Info extends NeedsAssessmentDTO {
        private Long id;
        private Integer version;
        private String objectName;
        private String objectCode;
        private CompetenceDTO.Info competence;
        private SkillDTO.Info skill;
        private ParameterValueDTO.MinInfo needsAssessmentDomain;
        private ParameterValueDTO.MinInfo needsAssessmentPriority;
        private String workflowStatus;
        private Integer workflowStatusCode;
//        private E object;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Create")
    public static class Create extends NeedsAssessmentDTO {
        private String objectName;
        private String objectCode;
//        private String Action;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Update")
    public static class Update {
        private Long needsAssessmentPriorityId;
//        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentDTO - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
