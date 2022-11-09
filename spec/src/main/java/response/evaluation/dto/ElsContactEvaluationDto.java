package response.evaluation.dto;

import dto.evaluuation.EvalCourseProtocol;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsContactEvaluationDto {
    private long id;
    private long classId;
    private long questionnaireId;
    private String title;
    private String evaluated;
    private String planner;
    private String organizer;
    private String teacherFullName;
    private EvalCourseProtocol courseProtocol;
    private boolean isEvaluationExpired;
}
