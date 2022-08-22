package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

public class ViewCalenderMainGoalsDTO implements Serializable {
    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String classCode;

    @ApiModelProperty
    private String mainGoal;

    @ApiModelProperty
    private Long  calenderId;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info extends ViewCalenderMainGoalsDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewCalenderMainGoalsSpecRs")
    public static class ViewCalenderMainGoalsSpecRs {
        private ViewCalenderMainGoalsDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewCalenderMainGoalsDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
