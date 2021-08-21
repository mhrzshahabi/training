package response.question.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ElsQuestionBankDto {

    private String nationalCode;
    private List<ElsQuestionDto> question;

}
