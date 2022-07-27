package response.tclass;

import dto.exam.ClassType;
import dto.exam.CourseStatus;
import dto.exam.CourseType;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.tclass.dto.CourseProgramDTO;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsClassDetailResponse extends BaseResponse implements Serializable {
    private Long id;
    private String name;
    private String title;
    private String code;
    private String description;
//    private Integer capacity;
//    private Integer duration;
    private String location;
//    private String notification;
//    private Boolean dbStatus;
//    private CourseStatus courseStatus;
//    private ClassType classType;
//    private CourseType courseType;
    private Long start_Date;
    private String startDate;
    private Long finish_Date;
    private String finishDate;
//    private Double evaluationRate;
    private String instructor;
    private Long evaluationId;
    private List<CourseProgramDTO> coursePrograms;
    private String instructorNationalCode;
//    private String supervisor;
    private List<String> studentsNationalCodes;
}
