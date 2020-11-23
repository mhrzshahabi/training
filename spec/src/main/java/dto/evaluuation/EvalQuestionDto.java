package dto.evaluuation;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
public class EvalQuestionDto {

    private String title;
    private EvalQuestionType type;
    private Object option;
}
