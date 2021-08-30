package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsStudentAttendanceInfoDto {
    private String sessionDate;
    private String sessionStartHour;
    private String sessionEndHour;
    private String sessionWeekDayName;
    private Long attendanceStateId;
    private String attendanceStateTitle;
}
