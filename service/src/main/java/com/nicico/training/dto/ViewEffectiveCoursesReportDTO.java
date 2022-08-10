package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewEffectiveCoursesReportDTO implements Serializable {
    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private String classCode;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String classTitle;

    @ApiModelProperty
    private String teacherFullName;

    @ApiModelProperty
    private String classStartDate;

    @ApiModelProperty
    private String classEndDate;

    @ApiModelProperty
    private String classYear;

    @ApiModelProperty
    private String termTitle;

    @ApiModelProperty
    private String evaluationType;

    @ApiModelProperty
    private Double effectivenessGrade;

    @ApiModelProperty
    private String effectivenessStatus;

    @ApiModelProperty
    private String description;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewEffectiveCoursesReportDTOInfo")
    public static class Info extends ViewEffectiveCoursesReportDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewEffectiveCoursesReportDTOSpecRs")
    public static class ViewEffectiveCoursesReportDTOSpecRs {
        private ViewEffectiveCoursesReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewEffectiveCoursesReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
