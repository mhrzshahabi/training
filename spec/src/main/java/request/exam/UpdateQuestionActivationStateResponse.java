package request.exam;

import dto.Question.QuestionBankData;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;
import response.question.dto.ElsQuestionBankDto;

import java.util.List;

@Setter
@Getter
@ToString
public class UpdateQuestionActivationStateResponse extends BaseResponse {
    Boolean updated;
}
