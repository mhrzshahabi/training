package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewClassCourseFinalStatusDTO implements Serializable {
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
    private String classStatus;

    @ApiModelProperty
    private String classScoringStatus;

    @ApiModelProperty
    private Double acceptancePercentage;

    @ApiModelProperty
    private String instituteTitle;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingClassCourseFinalStatusDTOInfo")
    public static class Info extends ViewClassCourseFinalStatusDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingClassCourseFinalStatusDTOSpecRs")
    public static class TrainingClassCourseFinalStatusDTOSpecRs {
        private ViewClassCourseFinalStatusDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewClassCourseFinalStatusDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
