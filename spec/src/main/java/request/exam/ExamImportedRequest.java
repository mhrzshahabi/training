package request.exam;

import dto.Question.QuestionData;
import dto.Question.QuestionScores;
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
    private List<QuestionData> questions;
    private List<QuestionScores> questionData;


}
