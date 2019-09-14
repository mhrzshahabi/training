/*
ghazanfari_f, 9/12/2019, 3:02 PM
*/
package com.nicico.training.dto;

import com.nicico.training.model.enums.EDomainType;
import com.nicico.training.model.enums.ENeedAssessmentPriority;
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
public class NeedAssessmentDTO implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private Long postId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long skillId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer edomainTypeId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer eneedAssessmentPriorityId;

    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessment - Create")
    public static class Create extends NeedAssessmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessment - Update")
    public static class Update extends NeedAssessmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessment - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessment - Info")
    public static class Info extends NeedAssessmentDTO {
        private Long id;
        private PostDTO.Info post;
        private CompetenceDTO.Info competence;
        private EDomainType eDomainType;
        private ENeedAssessmentPriority eNeedAssessmentPriority;
        private SkillDTO.Info skill;
        private String description;
    }
}