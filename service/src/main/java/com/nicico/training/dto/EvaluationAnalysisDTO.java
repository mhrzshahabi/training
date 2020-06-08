package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Analysis - Info")
    public static class Info extends EvaluationAnalysisDTO {
        private Long id;
        private TclassDTO.Info tClass;
        private Long tClassId;
        private String reactionGrade;
        private String learningGrade;
        private String behavioralGrade;
        private String resultsGrade;
        private String effectivenessGrade;
        private Boolean reactionPass;
        private Boolean learningPass;
        private Boolean behavioralPass;
        private Boolean resultsPass;
        private Boolean effectivenessPass;
    }
}
