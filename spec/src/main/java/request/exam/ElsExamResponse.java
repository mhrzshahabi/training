package request.exam;

import dto.exam.ElsExamCreateDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

@Setter
@Getter
@ToString
public class ElsExamResponse extends BaseResponse {
    private ElsExamCreateDTO elsExamCreateDTO;
}
