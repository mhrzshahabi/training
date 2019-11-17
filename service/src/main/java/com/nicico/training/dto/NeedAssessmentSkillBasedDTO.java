
package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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
public class NeedAssessmentSkillBasedDTO implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private Long skillId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer eneedAssessmentPriorityId;

    @NotNull
    @ApiModelProperty(required = true)
    private String objectType;

    @NotNull
    @ApiModelProperty(required = true)
    private Long objectId;




    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessmentSkillBased - Create")
    public static class Create extends NeedAssessmentSkillBasedDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessmentSkillBased - Update")
    public static class Update extends NeedAssessmentSkillBasedDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessmentSkillBased - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedAssessmentSkillBased - Info")
    public static class Info<E> {
        private Long id;
        private ENeedAssessmentPriority eneedAssessmentPriority;
        private SkillDTO.Info skill;
        private E object;
        private String objectType;
        private Long objectId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("NeedAssessmentSkillBased - SpecRs")
    public static class NeedAssessmentSkillBasedSpecRs {
        private NeedAssessmentSkillBasedDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<NeedAssessmentSkillBasedDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}