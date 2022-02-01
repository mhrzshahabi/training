package request.evaluation;

import dto.evaluuation.EvalCourse;
import dto.evaluuation.EvalCourseProtocol;
import dto.evaluuation.EvalQuestionDto;
import dto.evaluuation.EvalTargetUser;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class ElsEvalRequest implements Serializable {
    private long id;
    private long classId;
    private long questionnaireId;
    private String title;
    private String planner;
    private String organizer;
    private List<EvalQuestionDto> questions;
    private List<EvalTargetUser> targetUsers;
    private EvalTargetUser teacher;
    private EvalCourse course;
    private EvalCourseProtocol courseProtocol;
}
