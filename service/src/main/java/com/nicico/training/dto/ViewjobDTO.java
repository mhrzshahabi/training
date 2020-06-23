package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.validation.constraints.NotEmpty;
import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewjobDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;

    @ApiModelProperty()
    private Integer competenceCount;

    @ApiModelProperty()
    private Integer personnelCount;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobInfo")
    public static class Info extends ViewjobDTO {
        private Long id;
    }
}
