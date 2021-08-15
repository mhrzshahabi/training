package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsSessionAttendanceUserInfoDto {
    private Long studentId;
    private String fullName;
    private String nationalCode;
    private Long attendanceStateId;
}
