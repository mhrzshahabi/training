package dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
public class ExamQuestionDto {
    private String title;
    private EvalQuestionType type;
    private Object option;
    private String correctAnswer;
    private Integer mark;
    private Integer time;
}
