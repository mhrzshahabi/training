package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
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
    @ApiModelProperty(hidden = true)
    private Long courseId;
    @ApiModelProperty(hidden = true)
    private String courseCode;
    @ApiModelProperty
    private String examCode;
    @ApiModelProperty
    private String name;
    @ApiModelProperty
    private Long examStartDate;
    @ApiModelProperty
    private Long examEndDate;
    @ApiModelProperty
    private Integer questionCount;
    @ApiModelProperty
    private Double practicalScore;
    @ApiModelProperty
    private Double score;
    @ApiModelProperty
    private Double minimumAcceptScore;
    @ApiModelProperty
    private Integer duration;
    @ApiModelProperty
    private String method;
}
