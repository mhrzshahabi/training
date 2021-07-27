package response.exam;

import dto.exam.ImportedQuestionOption;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
public class ExamAnswerDto {

    private String question;
    private String answer;
    private String examinerAnswer;
    private Double  mark;
    private String type;
    private Map<String,String> files;//files for questions that admin or teacher upload them
    private Map<String,String> answerFiles;//files that students upload them
    private Map<String,String> option1Files;//
    private Map<String,String> option2Files;//
    private Map<String,String> option3Files;//
    private Map<String,String> option4Files;//
    private List<ImportedQuestionOption> options;
}
