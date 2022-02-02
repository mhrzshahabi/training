package response.question.dto;

import lombok.Getter;
import lombok.Setter;
import response.PageDto;

import java.util.List;

@Getter
@Setter
public class ElsQuestionBankDto extends PageDto {
    private String nationalCode;
    private List<ElsQuestionDto> questions;
}
