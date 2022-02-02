package request.evaluation;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class StudentEvaluationAnswerDto implements Serializable {
    private Long classId;
    private Long sourceId;
    private String nationalCode;
    private String description;
    private List<TeacherEvaluationAnswerList> evaluationAnswerList;
}
