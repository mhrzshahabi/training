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
public class ElsExamCreateDTO {
    @ApiModelProperty(required = true)
    private Long classId;
    @ApiModelProperty
    private Long courseId;
    @ApiModelProperty
    private String courseCode;
    @ApiModelProperty
    private String examCode;
    @ApiModelProperty
    private String name;
    @ApiModelProperty
    private Double finalScore;
    @ApiModelProperty
    private Double minimumAcceptScore;
    @ApiModelProperty
    private Long hDuration;
    @ApiModelProperty
    private String startDate;
    @ApiModelProperty
    private String endDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ElsExamCreateDTO.Info")
    public static class Info {
        private Long id;
        private Integer version;
        private String startDate;
        private String startTime;
        private Integer duration;
        private String endDate;
        private String endTime;
        private String practicalScore;
        private String classScore;
        private String testQuestionType;
        private Long sourceExamId;
    }

}
