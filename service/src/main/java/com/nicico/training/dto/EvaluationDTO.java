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
public class EvaluationDTO implements Serializable {

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
    @ApiModel("Evaluation - Info")
    public static class MinInfo {
        private Long id;
        private String title;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Info")
    public static class Info extends EvaluationDTO {
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Create")
    public static class Create extends EvaluationDTO {
        @ApiModelProperty(required = true)
        private Long parameterId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Update")
    public static class Update extends Create {
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
