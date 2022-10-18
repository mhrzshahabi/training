package request.exam;

import dto.exam.ImportedQuestionProtocol;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
@ToString
public class ElsAddQuestionToExamResponse extends BaseResponse {
    private List<ImportedQuestionProtocol> importedQuestionProtocols;
}
