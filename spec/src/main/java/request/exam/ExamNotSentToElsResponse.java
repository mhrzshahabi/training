package request.exam;

import dto.exam.ExamNotSentToElsDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
@ToString
public class ExamNotSentToElsResponse extends BaseResponse {
    private List<ExamNotSentToElsDTO.Info> examNotSentToElsDTOS;
}
