package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewEvaluationCommentsDTO implements Serializable {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private Long subCategoryId;
    @ApiModelProperty
    private String description;
    @ApiModelProperty
    private String classCode;
    @ApiModelProperty
    private String classTitle;
    @ApiModelProperty
    private String firstName;
    @ApiModelProperty
    private String lastName;
    @ApiModelProperty
    private String titleCategory;
    @ApiModelProperty
    private String titleSubCategory;
    @ApiModelProperty
    private String startDate;
    @ApiModelProperty
    private String endDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationCommentsDTOInfo")
    public static class Info extends ViewEvaluationCommentsDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewEvaluationCommentsDTOSpecRs")
    public static class ViewEvaluationCommentsDTOSpecRs {
        private ViewEvaluationCommentsDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewEvaluationCommentsDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
