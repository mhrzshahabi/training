package request.attendance.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttendanceDto {

    @ApiModelProperty
    private long sessionId;
    @ApiModelProperty
    private long studentId;
    @ApiModelProperty
    private String state;
    @ApiModelProperty
    private String description;
}
