package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ExamNotSentToElsDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ExamNotSentToElsDTO.Info")
    public static class Info {

        @ApiModelProperty
        private Long id;

        @ApiModelProperty
        private String testQuestionType;

        @ApiModelProperty
        private Long tclassId;

        @ApiModelProperty
        private String date;

        @ApiModelProperty
        private String endDate;

        @ApiModelProperty
        private String endTime;

        @ApiModelProperty
        private String time;

        @ApiModelProperty
        private Integer duration;

        @ApiModelProperty
        private Boolean onlineFinalExamStatus;

        @ApiModelProperty
        private String name;

        @ApiModelProperty
        private ExamType type;

        @ApiModelProperty
        private Double acceptanceLimit;

        @ApiModelProperty
        private String classCode;
    }

}
