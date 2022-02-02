package request.exam;

import dto.Question.QuestionData;
import dto.Question.QuestionScores;
import dto.evaluuation.EvalTargetUser;
import dto.exam.ExamData;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class ExamImportedRequest implements Serializable {
    private ExamData examItem;
    private boolean deleteAbsentUsers;
    private List<QuestionData> questions;
    private List<QuestionScores> questionData;
    private List<EvalTargetUser> absentUsers;
}
