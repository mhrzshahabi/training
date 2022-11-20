package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import javax.validation.constraints.NotNull;
import java.util.List;

@Setter
@Getter
@ToString
public class ElsImportedExam extends BaseResponse {
    @NotNull
    @ApiModelProperty
    private String examCode;

    @NotNull
    @ApiModelProperty(required = true)
    private String startDate;

    @NotNull
    @ApiModelProperty(required = true)
    private String startTime;

    @NotNull
    @ApiModelProperty(required = true)
    private String endDate;

    @NotNull
    @ApiModelProperty(required = true)
    private String endTime;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer duration;

    @ApiModelProperty
    private String testQuestionType;

    @ApiModelProperty
    private String practicalScore;

    @ApiModelProperty
    private String classScore;

    @ApiModelProperty
    private List<ElsImportedQuestionProtocol> questionProtocols;
}
