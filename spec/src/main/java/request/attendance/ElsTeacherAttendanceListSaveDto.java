package request.attendance;

import lombok.Getter;
import lombok.Setter;
import request.attendance.dto.AttendanceDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsTeacherAttendanceListSaveDto {
    private List<AttendanceDto> attendanceDtos;
}
