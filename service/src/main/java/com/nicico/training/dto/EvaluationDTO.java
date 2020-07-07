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
public class EvaluationDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long classId;

    @ApiModelProperty(required = true)
    private Long questionnaireTypeId;

    @ApiModelProperty(required = true)
    private Long evaluatorId;

    @ApiModelProperty(required = true)
    private Long evaluatorTypeId;

    @ApiModelProperty(required = true)
    private Long evaluatedId;

    @ApiModelProperty(required = true)
    private Long evaluatedTypeId;

    @ApiModelProperty(required = true)
    private Long evaluationLevelId;

    private String description;
    private Boolean evaluationFull;
    private Boolean status;
    private String returnDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Info")
    public static class Info extends EvaluationDTO {
        private List<EvaluationAnswerDTO.Create> evaluationAnswerList;
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Create")
    public static class Create extends EvaluationDTO {
        private List<EvaluationAnswerDTO.Create> evaluationAnswerList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Evaluation - Update")
    public static class Update {
        private Boolean evaluationFull;
        private String description;
        private Boolean status;
        private String returnDate;
        private List<EvaluationAnswerDTO.Create> evaluationAnswerList;
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

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EvaluationSpecRs")
    public static class EvaluationSpecRs {
        private EvaluationDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //-----------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationLearningResult")
    public static class EvaluationLearningResult{
        private String preTestMeanScore;
        private String postTestMeanScore;
        private String havePreTest;
        private String havePostTest;
        private String felgrade;
        private String limit;
        private String felpass;
        private String feclgrade;
        private String feclpass;
        private String tstudent;
        private Float studentCount;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BehavioralForms")
    public static class BehavioralForms {
        private Long evaluatorTypeId;
        private String evaluatorName;
        private Boolean status;
        private Long id;
        private Long evaluatorId;
        private String returnDate;
    }
}
