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
public class ViewTrainingNeedAssessmentDTO implements Serializable {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private String code;
    @ApiModelProperty
    private String courseTitle;
    @ApiModelProperty
    private String categoryTitle;
    @ApiModelProperty
    private String subCategoryTitle;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingNeedAssessmentDTOInfo")
    public static class Info extends ViewTrainingNeedAssessmentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingNeedAssessmentDTOSpecRs")
    public static class TrainingNeedAssessmentDTOSpecRs {
        private ViewTrainingNeedAssessmentDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewTrainingNeedAssessmentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
