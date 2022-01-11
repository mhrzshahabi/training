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
    private Long workFlowStatusCode;
    private String processInstanceId;


@Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Info")
    public static class Info extends CompetenceDTO {
        private Long id;
        private Integer version;
        private ParameterValueDTO.MinInfo competenceType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
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
    @ApiModel("CompetenceDTO - Create")
    public static class Create extends CompetenceDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceDTO - Update")
    public static class Update extends Create {
        private Integer version;
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
