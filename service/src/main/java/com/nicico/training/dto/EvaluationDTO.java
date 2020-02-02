package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.Tclass;
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

    private Long id;
    private Tclass tclass;
    private Long classId;
    private Long evaluatorId;
    private ParameterValue evaluatorType;
    private Long evaluatorTypeId;
    private Long evaluatedId;
    private ParameterValue evaluatedType;
    private Long evaluatedTypeId;
    private ParameterValue evaluationLevel;
    private Long evaluationLevelId;
    private String description;
    private List<EvaluationAnswer> evaluationAnswerList;

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
}
