package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class QuestionBankTestQuestionDTO {
    private Long testQuestionId;
    private Long questionBankId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBankTestQuestionInfo")
    public static class Info extends QuestionBankTestQuestionDTO {
        private Long id;
        private Integer version;
        private QuestionBankDTO.Info questionBank;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBankTestQuestion-Info-Used")
    public static class InfoUsed extends QuestionBankTestQuestionDTO {
        private Long id;
        private Integer version;
        private TestQuestionDTO.Info testQuestion;
        private QuestionBankDTO.Info questionBank;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("QuestionBankTestQuestionSpecRs")
    public static class QuestionBankTestQuestionFinalTest extends QuestionBankTestQuestionDTO {
        private Long id;
        private Integer version;
        private QuestionBankDTO.FinalTestInfo questionBank;
        private TestQuestionDTO.FinalTestInfo testQuestion;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBankTestQuestionCreateRq")
    public static class Create extends QuestionBankTestQuestionDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBankTestQuestionUpdateRq")
    public static class Update extends QuestionBankTestQuestionDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBankTestQuestionDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("QuestionBankTestQuestionSpecRs")
    public static class QuestionBankTestQuestionSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("QuestionBankTestQuestionSpecRs")
    public static class QuestionBankTestQuestionSpecRsUsed {
        private SpecRsUsed response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsUsed {
        private List<InfoUsed> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
