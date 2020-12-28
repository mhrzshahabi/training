package response.question;

import dto.exam.ImportedQuestionOption;
import lombok.Getter;
import lombok.Setter;
import response.exam.ExamAnswerDto;

import java.util.List;

@Getter
@Setter
public class QuestionsDto {

    private String question;
    private String type;
    private String score;
     private String options;
}
