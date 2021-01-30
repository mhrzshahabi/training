package request.evaluation;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class TeacherEvaluationAnswerList implements Serializable {
    private String question;
    private String answer;
}
