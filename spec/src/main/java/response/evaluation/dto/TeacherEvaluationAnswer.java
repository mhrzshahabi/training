package response.evaluation.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class TeacherEvaluationAnswer implements Serializable {
    private String id;
    private String answerID;
}
