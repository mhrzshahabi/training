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
public class ViewClassStudentFinalStatusDTO implements Serializable {
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
    private String studentNationalCode;

    @ApiModelProperty
    private String studentFullName;

    @ApiModelProperty
    private String studentComplex;

    @ApiModelProperty
    private String studentAssistant;

    @ApiModelProperty
    private String studentAffair;

    @ApiModelProperty
    private String acceptanceStatus;

    @ApiModelProperty
    private Integer studentScore;

    @ApiModelProperty
    private Integer acceptanceLimit;

    @ApiModelProperty
    private String instituteTitle;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingClassStudentFinalStatusDTOInfo")
    public static class Info extends ViewClassStudentFinalStatusDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingClassStudentFinalStatusDTOSpecRs")
    public static class TrainingClassStudentFinalStatusDTOSpecRs {
        private ViewClassStudentFinalStatusDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewClassStudentFinalStatusDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
