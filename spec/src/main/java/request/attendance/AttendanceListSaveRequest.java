package request.attendance;

import lombok.Getter;
import lombok.Setter;
import request.attendance.dto.AttendanceDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class AttendanceListSaveRequest implements Serializable {
    private static final long serialVersionUID = 7710786106266650447L;

    private List<AttendanceDto> attendanceDtos;
}
