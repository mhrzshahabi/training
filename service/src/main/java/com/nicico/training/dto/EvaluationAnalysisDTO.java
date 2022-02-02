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
public class EvaluationAnalysisDTO implements Serializable {
    private Long tClassId;
    private String reactionGrade;
    private String learningGrade;
    private String behavioralGrade;
    private String resultsGrade;
    private String effectivenessGrade;
    private String teacherGrade;
    private Boolean reactionPass;
    private Boolean learningPass;
    private Boolean behavioralPass;
    private Boolean resultsPass;
    private Boolean effectivenessPass;
    private Boolean teacherPass;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Analysis - Info")
    public static class Info extends EvaluationAnalysisDTO {
        private Long id;
        private TclassDTO.Info tClass;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Analysis - Create")
    public static class Create extends EvaluationAnalysisDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Analysis - Update")
    public static class Update extends EvaluationAnalysisDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Analysis - Delete")
    public static class Delete implements Serializable {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }
}
