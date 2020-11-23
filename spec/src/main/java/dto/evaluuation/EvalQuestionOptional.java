package dto.evaluuation;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
public class EvalQuestionOptional {

    private List<String> options;
}
