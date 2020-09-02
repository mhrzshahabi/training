package request.student;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class UpdateStudentScoreRequest implements Serializable {
    private static final long serialVersionUID = -2127040011027785973L;

    private Long scoresStateId;
    private Float score;
    private long failureReasonId;
}
