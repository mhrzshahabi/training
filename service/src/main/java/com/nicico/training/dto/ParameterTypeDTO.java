package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ParameterTypeDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterType - Info")
    public static class Info extends ParameterTypeDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterType - Create")
    public static class Create extends ParameterTypeDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterType - Update")
    public static class Update extends ParameterTypeDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterType - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
