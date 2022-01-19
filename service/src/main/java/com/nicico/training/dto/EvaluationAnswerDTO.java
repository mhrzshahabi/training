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
public class EvaluationAnswerDTO implements Serializable {

    @ApiModelProperty(required = true)
    private Long evaluationId;

    @ApiModelProperty(required = true)
    private Long evaluationQuestionId;

    @ApiModelProperty(required = true)
    private Long questionSourceId;

    @ApiModelProperty(required = true)
    private Long answerId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationAnswer - Info")
    public static class Info extends EvaluationAnswerDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationAnswer - Create")
    public static class Create extends EvaluationAnswerDTO {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationAnswer - Update")
    public static class Update {
        private Long id;
        private Long answerId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationAnswer - Delete")
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
    @ApiModel("EvaluationAnswerSpecRs")
    public static class EvaluationAnswerSpecRs {
        private EvaluationAnswerDTO.SpecRs response;
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
    @ApiModel("EvaluationAnswerFullData")
    public static class EvaluationAnswerFullData extends EvaluationAnswerDTO {
        private Long id;
        private Long evaluationId;
        private Long evaluationQuestionId;
        private Long questionSourceId;
        private Long answerId;

        private Integer order;
        private Integer weight;
        private String question;
        private Long domainId;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EvaluationAnswerForAudit")
    public static class EvaluationAnswerForAudit {
        private Long evaluationId;
        private Long evaluationQuestionId;
        private Long questionSourceId;
        private Long answerId;
        private String question;
        private String answerTitle;
        private String createdBy;
        private String modifiedBy;
        private String modifiedDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecEvaluationAnswerForAuditRs {
        private List<EvaluationAnswerDTO.EvaluationAnswerForAudit> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TClassAuditEvalSpecRs")
    public static class EvaluationAnswerAuditSpecRs {
        private EvaluationAnswerDTO.SpecEvaluationAnswerForAuditRs response;
    }

}
