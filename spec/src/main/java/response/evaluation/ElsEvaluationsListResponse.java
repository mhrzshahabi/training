package response.evaluation;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.evaluation.dto.ElsContactEvaluationDto;

import java.util.List;

@Getter
@Setter
public class ElsEvaluationsListResponse extends BaseResponse {
    private String nationalCode;
    private List<ElsContactEvaluationDto> elsContactEvaluationDtos;
}
