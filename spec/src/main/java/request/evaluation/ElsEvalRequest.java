package request.evaluation;

import dto.EvalQuestionDto;
import dto.EvalTargetUser;
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
    private String title;
    private String planner;
    private String organizer;
    private List<EvalQuestionDto> questions;
    private List<EvalTargetUser> targetUsers;

}
