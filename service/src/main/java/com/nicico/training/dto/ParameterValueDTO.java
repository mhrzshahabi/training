package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
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
    private String title;
    private String code;
    private String description;
    @ApiModelProperty(required = true)
    private Long parameterId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Info")
    public static class Info extends ParameterValueDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Create")
    public static class Create extends ParameterValueDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Update")
    public static class Update extends ParameterValueDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
