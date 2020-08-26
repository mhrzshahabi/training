package request.attendance.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttendanceDto {

    private long sessionId;
    private long studentId;
    private String state;
    private String description;
}
