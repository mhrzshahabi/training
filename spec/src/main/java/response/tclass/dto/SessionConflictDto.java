package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SessionConflictDto {
    private Long id;
    private String startHour;
    private String endHour;
    private String date;
    private String classCode;
    private String firstName;
    private String lastName;

    public SessionConflictDto(Long id, String startHour, String endHour, String date, String classCode, String firstName, String lastName) {
        this.id = id;
        this.startHour = startHour;
        this.endHour = endHour;
        this.date = date;
        this.classCode = classCode;
        this.firstName = firstName;
        this.lastName = lastName;
    }
}
