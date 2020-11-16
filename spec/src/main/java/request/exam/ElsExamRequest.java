package request.exam;

import dto.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class ElsExamRequest implements Serializable {

    private long id;
    private List<EvalTargetUser> targetUsers;
    private EvalTargetUser teacher;
    private ExamCourseCategoryDto examCourseCategory;
    private ExamCourseDto examCourse ;
    private ExamCourseProtocolDto examCourseProtocol ;
    private List<ExamQuestionDto> questions;


//
//    private EvalCourse course;
//    private EvalCourseProtocol courseProtocol;

}
