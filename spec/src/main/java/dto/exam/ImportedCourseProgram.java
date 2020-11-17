package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ImportedCourseProgram {
//    @ApiModelProperty(required = true)
//    private Long courseProtocolId;
    @ApiModelProperty(required = true)
    private String day;
    @ApiModelProperty(required = true)
    private String endTime;
    @ApiModelProperty(required = true)
    private String startTime;
//    private String location;
//    private String classNo;
}
