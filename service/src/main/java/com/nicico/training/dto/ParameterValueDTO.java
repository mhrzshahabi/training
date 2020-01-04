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
    private String title;
    private String code;
    private String type;
    private String value;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Info")
    public static class Info extends ParameterValueDTO {
        private Long id;
        private Integer version;
        private ParameterDTO.Info parameter;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Create")
    public static class Create extends ParameterValueDTO {
        @ApiModelProperty(required = true)
        private Long parameterId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ParameterValue - Update")
    public static class Update extends Create {
        private Integer version;
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

    //////////////////////////////////////////config//////////////////////////////////////////

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Parameter - Config - Update")
    public static class ConfigUpdate {
        private Long id;
        private String code;
    }
}
