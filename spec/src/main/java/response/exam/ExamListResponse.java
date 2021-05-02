package response.exam;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.evaluation.dto.EvalResultDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ExamListResponse extends BaseResponse implements Serializable {

    private List<ExamResultDto> data;
    private String title;
    private String examType;

}
