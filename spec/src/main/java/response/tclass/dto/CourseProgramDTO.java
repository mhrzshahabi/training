package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CourseProgramDTO {

    private Long id;

    private WeekDays day;

    private String classNo;

    private String startTime;

    private String endTime;

    private String location;
}
