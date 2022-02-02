package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)
public class EvaluationQuestionDTO implements Serializable {
    private String question;
    private Long domainId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationQuestion - Info")
    public static class Info extends EvaluationQuestionDTO {
        private Long id;
        private ParameterValueDTO.Info domain;
        private List<EvaluationIndexDTO.Info> evaluationIndices;

        public List<Long> getEvaluationIndices() {
            if (evaluationIndices == null)
                return null;
            return evaluationIndices.stream().map(EvaluationIndexDTO.Info::getId).collect(Collectors.toList());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationQuestion - InfoWithDomain")
    public static class InfoWithDomain extends EvaluationQuestionDTO {
        private Long id;
        private ParameterValueDTO.TupleInfo domain;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationQuestion - Create")
    public static class Create extends EvaluationQuestionDTO {
        private List<EvaluationIndexDTO.Info> evaluationIndices;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationQuestion - Update")
    public static class Update extends EvaluationQuestionDTO {
        private Long id;
        private List<EvaluationIndexDTO.Info> evaluationIndices;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationQuestion - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
