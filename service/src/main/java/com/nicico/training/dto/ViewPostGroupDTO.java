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

public class ViewPostGroupDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String code;

    @ApiModelProperty()
    private String titleEn;

    @ApiModelProperty()
    private String description;

    @ApiModelProperty()
    private Integer competenceCount;

    @ApiModelProperty()
    private Integer personnelCount;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupInfo")
    public static class Info extends ViewPostGroupDTO {
        private Long id;
    }

}
