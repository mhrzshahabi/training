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
public class QuestionnaireDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    private String description;
    private Long questionnaireTypeId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Questionnaire - Info")
    public static class Info extends QuestionnaireDTO {
        private Long id;
        private Integer version;
        private ParameterValueDTO.MinInfo questionnaireType;
        private Long enabled;
        private List<QuestionnaireQuestionDTO.Info> questionnaireQuestionList;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Questionnaire - Create")
    public static class InfoForEvaluation {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Questionnaire - Create")
    public static class Create extends QuestionnaireDTO {
        private Long enabled;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Questionnaire - Update")
    public static class Update extends QuestionnaireDTO {
        private Integer version;
        //private  Long enabled;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Questionnaire - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
