package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class DynamicQuestionDTO implements Serializable {

    private Integer weight;
    private Integer order;
    private String question;
    private Long typeId;
    private Long skillId;
    private Long goalId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DyanamicQuestion - Info")
    public static class Info extends DynamicQuestionDTO {
        private Long id;
        private ParameterValueDTO.Info  type;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DyanamicQuestion - Create")
    public static class Create extends DynamicQuestionDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DyanamicQuestion - Update")
    public static class Update extends DynamicQuestionDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DyanamicQuestion - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
