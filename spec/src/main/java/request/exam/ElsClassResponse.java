package request.exam;

import dto.exam.ClassCreateDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

@Setter
@Getter
@ToString
public class ElsClassResponse extends BaseResponse {
    private ClassCreateDTO classCreateDTO;
}
