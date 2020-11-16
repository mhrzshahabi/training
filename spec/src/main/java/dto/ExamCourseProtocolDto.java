package dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;


@Getter
@Setter
@ToString
public class ExamCourseProtocolDto {
    private String name;
    private String code;
    private Integer capacity;
    private Integer duration;
    //teachingType
    private String classType;
    //ENeedAssessmentPriority
    private String courseType;
    //activeOrNot
    private String courseStatus;
    private String startDate;
    private String finishDate;
    private List<ExamProtocolProgramDto> programs;
}
