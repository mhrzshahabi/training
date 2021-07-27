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
    private Map<String,String> files;
    private Map<String,String> answerFiles;
    private List<ImportedQuestionOption> options;
}
