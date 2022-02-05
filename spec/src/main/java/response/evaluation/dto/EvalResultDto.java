package response.evaluation.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class EvalResultDto {
    private String description;
    private String surname;
    private String lastName;
    private String nationalCode;
    private String cellNumber;
    private List<EvalAnswerDto> answers;
}
