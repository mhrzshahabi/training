package com.nicico.training.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class ViewSkillNADTO {

    @NotNull
    @ApiModelProperty(required = true)
    private Long id;

    @NotNull
    @ApiModelProperty(required = true)
    private Long objectId;

    @NotNull
    @ApiModelProperty(required = true)
    private String objectType;

    private String objectCode;
    private String objectName;
    private String peopleType;
    private Long enabled;
    private Long skillId;
    private String skillCode;
    private String skillTitleFa;
    private Long courseId;
    private String courseCode;
    private String courseTitleFa;
    private String affairs;
    private String area;
    private String assistance;
    private String section;
    private String departmentTitle;
    private String unit;
    private String complexTitle;
    private Long departmentId;

}
