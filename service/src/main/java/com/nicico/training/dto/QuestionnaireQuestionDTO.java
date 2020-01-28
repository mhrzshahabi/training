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
public class QuestionnaireQuestionDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long questionnaireId;
    @ApiModelProperty(required = true)
    private Long evaluationQuestionId;
    @ApiModelProperty(required = true)
    private Float weight;
    @ApiModelProperty(required = true)
    private Integer order;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionnaireQuestion - Info")
    public static class Info extends QuestionnaireQuestionDTO {
        private Long id;
        private Integer version;
        private EvaluationQuestionDTO.Info evaluationQuestion;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionnaireQuestion - Create")
    public static class Create extends QuestionnaireQuestionDTO {


    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionnaireQuestion - Update")
    public static class Update extends QuestionnaireQuestionDTO {
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionnaireQuestion - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
