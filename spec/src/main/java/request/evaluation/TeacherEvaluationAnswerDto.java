package request.evaluation;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class TeacherEvaluationAnswerDto implements Serializable {
    private Long classId;
    private String description;
    private List<TeacherEvaluationAnswerList> evaluationAnswerList;
}
