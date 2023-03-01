package request.evaluation;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Getter
@Setter
@ToString
public class ReviewByRunSupervisor implements Serializable {
    private Long id;
    private String runSupervisorComment;
    private String runExpertNationalCode;
}
