package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class CompetenceDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceTypeId;
    private String description;
    private Long categoryId;
    private Long subCategoryId;
    private String code;
    private String competenceLevel;
    private String competencePriority;
    private Long competenceLevelId;
    private Long competencePriorityId;
    private Boolean active;
    private Boolean isUsed;
    private String complex;
    private Long workFlowStatusCode;
    private String processInstanceId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Info")
    public static class Info extends CompetenceDTO {
        private Long id;
        private Long CNeedsAssessmentDomainId;
        private Integer version;
        private String returnDetail;
        private ParameterValueDTO.MinInfo competenceType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Info2")
    public static class Info2  {
        private ParameterValueDTO.MinInfo competenceType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Posts")
    public static class Posts {
        private Long id;
         private String title;
         private String type;
         private String code;
         private String skill;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - NeedsAssessmentReportInfo")
    public static class NeedsAssessmentReportInfo {
        @NotEmpty
        @ApiModelProperty(required = true)
        private String title;
        @NotNull
        @ApiModelProperty(required = true)
        private Long competenceTypeId;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - NeedsAssessmentReportInfo2")
    public static class NeedsAssessmentReportInfo2 {
        @NotEmpty
        @ApiModelProperty(required = true)
        private String title;
        @NotNull
        @ApiModelProperty(required = true)
        private Long competenceTypeId;
        private ParameterValueDTO.MinInfo competenceType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Create")
    public static class Create extends CompetenceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Update")
    public static class Update extends Create {
        private Integer version;
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
