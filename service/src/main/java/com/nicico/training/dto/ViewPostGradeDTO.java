package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
public class ViewPostGradeDTO implements Serializable {

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

    @ApiModelProperty
    private Date lastModifiedDateNA;

    @ApiModelProperty
    private String modifiedByNA;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGradeInfo")
    public static class Info extends ViewPostGradeDTO {
        private Long id;
    }
}
