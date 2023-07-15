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
public class ViewTeacherQuestionCountDTO implements Serializable {

    @ApiModelProperty
    private Long id;

    @ApiModelProperty
    private Long courseId;

    @ApiModelProperty
    private String courseTitle;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private Long teacherId;

    @ApiModelProperty
    private String teacherCode;

    @ApiModelProperty
    private String teacherFirstName;

    @ApiModelProperty
    private String teacherLastName;

    @ApiModelProperty
    private String teacherNationalCode;

    @ApiModelProperty
    private Long yearOfQuestion;

    @ApiModelProperty
    private Long questionCount;

    public String getTeacherFullName() {
        return (teacherFirstName + " " + teacherLastName);
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewTeacherQuestionCountInfo")
    public static class Info extends ViewTeacherQuestionCountDTO {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewTeacherQuestionCountDTOSpecRs")
    public static class ViewTeacherQuestionCountDTOSpecRs {
        private ViewTeacherQuestionCountDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewTeacherQuestionCountDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}
