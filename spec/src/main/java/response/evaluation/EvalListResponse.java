package response.evaluation;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.evaluation.dto.EvalResultDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class EvalListResponse extends BaseResponse implements Serializable {

    private List<EvalResultDto> data ;
    private String title;

}
