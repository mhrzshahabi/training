package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewPostDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String affairs;

    @ApiModelProperty
    private String area;

    @ApiModelProperty
    private String assistance;

    @ApiModelProperty
    private String costCenterTitleFa;

    @ApiModelProperty
    private String costCenterCode;

    @ApiModelProperty
    private String section;

    @ApiModelProperty
    private String unit;

    @ApiModelProperty
    private Long postGradeId;

    @ApiModelProperty
    private Long jobId;

    @ApiModelProperty
    private Integer competenceCount;

    @ApiModelProperty
    private Integer personnelCount;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostInfo")
    public static class Info extends ViewPostDTO{
        private Long id;
    }
}
