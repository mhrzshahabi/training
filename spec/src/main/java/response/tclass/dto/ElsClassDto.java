package response.tclass.dto;

import dto.exam.ClassType;
import dto.exam.CourseStatus;
import dto.exam.CourseType;
import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsClassDto  implements Serializable {

    private Long classId;

    private String name;

    private String title;

    private String code;

    private String description;

    private Integer capacity;

    private Integer duration;

    private String location;

    private CourseStatus courseStatus;

    private ClassType classType;

    private CourseType courseType;


    private Long startDate;

    private Long finishDate;

    private List<CourseProgramDTO> coursePrograms;

    private String  instructor;

}
