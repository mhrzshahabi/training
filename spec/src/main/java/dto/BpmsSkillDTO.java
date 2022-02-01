package dto;

import lombok.Getter;
import lombok.Setter;
import response.course.dto.CourseDto;

@Setter
@Getter
public class BpmsSkillDTO {
    private Long id;
    private String code;
    private String titleFa;
    private CourseDto course;
}
