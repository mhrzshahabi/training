package response.tclass;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsSessionDetailDto {
    private Long sessionId;
    private String day;
    private String startTime;
    private String endTime;
    private Long dateOfHolding;
    private Boolean attendances;
    private Boolean teacherAttendancePermission;
}
