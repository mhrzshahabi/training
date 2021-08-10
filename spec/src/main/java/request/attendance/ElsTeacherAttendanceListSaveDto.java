package request.attendance;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import request.attendance.dto.AttendanceDto;

import java.util.List;

@Getter
@Setter
public class ElsTeacherAttendanceListSaveDto {
    @ApiModelProperty
    private List<AttendanceDto> attendanceDtos;
}

