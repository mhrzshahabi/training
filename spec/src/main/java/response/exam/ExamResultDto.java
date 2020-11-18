package response.exam;

import lombok.Getter;
import lombok.Setter;
import response.evaluation.dto.EvalAnswerDto;

import java.util.List;

@Getter
@Setter
public class ExamResultDto {

    private String surname;
    private String lastName;
    private String nationalCode;
    private String cellNumber;
    private List<ExamAnswerDto> answers;
}
