package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.Tclass;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)

public class TestQuestionDTO {

    private boolean isPreTestQuestion;

    private Long tclassId;
    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLeveFullInfo")
    public static class fullInfo extends TestQuestionDTO {

        private Long id;
        private Integer version;

        @NotNull
        @ApiModelProperty(required = true)
        private String date;

        @NotNull
        @ApiModelProperty(required = true)
        private String time;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer duration;

        private TclassDTO.Info tclass;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelInfo")
    public static class Info extends TestQuestionDTO {
        private Long id;
        private Integer version;

        private String date;

        private String time;

        private Integer duration;

        private TclassDTO.Info tclass;
        //private Set<QuestionBankTestQuestionDTO.Info> QuestionBankTestQuestionList;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelCreateRq")
    public static class Create extends TestQuestionDTO {

        @NotNull
        @ApiModelProperty(required = true)
        private String date;

        @NotNull
        @ApiModelProperty(required = true)
        private String time;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer duration;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelUpdateRq")
    public static class Update extends TestQuestionDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private String date;

        @NotNull
        @ApiModelProperty(required = true)
        private String time;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer duration;

        private Long id;
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SkillLevelSpecRs")
    public static class TestQuestionSpecRs {
        private SpecRs response;
    }

    // ---------------

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
}
