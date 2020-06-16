package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class CategoriesPerformanceViewDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String institute;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer planingClasses;

    @ApiModelProperty
    private Integer processingClasses;

    @ApiModelProperty
    private Integer endedClasses;

    @ApiModelProperty
    private Integer finishedClasses;

    @ApiModelProperty
    private Integer presentStudents;

    @ApiModelProperty
    private Integer overtimedStudents;

    @ApiModelProperty
    private Integer absentStudents;

    @ApiModelProperty
    private Integer unjustifiedStudents;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoriesInfo")
    public static class Info extends CategoriesPerformanceViewDTO{
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MonthlyStatisticalSpecRs")
    public static class CategoriesPerformanceSpecRs {
        private MonthlyStatisticalReportDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CategoriesPerformanceViewDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
