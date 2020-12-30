package response.exam;

import dto.exam.ImportedQuestionOption;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ExamAnswerDto {

    private String question;
    private String answer;
    private String type;
    private List<ImportedQuestionOption> options;
}
