package request.student;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class UpdateStudentScoreRequest implements Serializable {
    private static final long serialVersionUID = -2127040011027785973L;

    private long scoresStateId;
    private float score;
    private long failureReasonId;
}
