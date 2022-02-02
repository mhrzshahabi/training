package dto.exam;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamClassData {
    private Long maxCapacity;
    private String code;
    private String titleClass;
    private String teachingType;
    private String classStatus;
    private String startDate;
    private String endDate;
    private Long teacherId;
    private Boolean saturday;
    private Boolean sunday;
    private Boolean monday;
    private Boolean tuesday;
    private Boolean wednesday;
    private Boolean thursday;
    private Boolean friday;
    private Boolean first;
    private Boolean second;
    private Boolean third;
    private Boolean fourth;
    private Boolean fifth;
    private String acceptancelimit;
    private ExamCourseData course;
}
