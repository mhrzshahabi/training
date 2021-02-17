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
public class ViewNeedAssessmentInRangeDTO implements Serializable {



    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String postType;

    @ApiModelProperty
    private String postCode;

    @ApiModelProperty
    private String postTitle;

    @ApiModelProperty
    private String updateBy;

    @ApiModelProperty
    private String updateAt;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingNeedAssessmentDTOInfo")
    public static class Info extends ViewNeedAssessmentInRangeDTO {
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingNeedAssessmentDTOSpecRs")
    public static class TrainingNeedAssessmentDTOSpecRs {
        private ViewNeedAssessmentInRangeDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewNeedAssessmentInRangeDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
