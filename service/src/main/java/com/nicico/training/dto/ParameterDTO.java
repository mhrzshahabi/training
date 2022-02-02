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
public class ParameterDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    private String code;
    private String type;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Info")
    public static class Info extends ParameterDTO {
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Create")
    public static class Create extends ParameterDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Update")
    public static class Update extends ParameterDTO {
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Config")
    public static class Config {
        private Long id;
        private String title;
        List<ParameterValueDTO.Info> parameterValueList;
    }
}
