package request.attendance;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class AuditAttendanceDto {
    private List<Long> attendanceIdes;
    private String sessionTime;
}

