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
public class FileLabelDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String labelName;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FileLabel - Info")
    public static class Info extends FileLabelDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FileLabel - Create")
    public static class Create extends FileLabelDTO {
        private Long id;
    }
}
