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
public class ParameterValueDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String value;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Info")
    public class Info extends ParameterValueDTO {
        private Long id;
        ParameterTypeDTO.Info parameterType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Create")
    public class Create extends ParameterValueDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Update")
    public class Update extends ParameterValueDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Delete")
    public class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
