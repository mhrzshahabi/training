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
    private String excelUrl="https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_10.xls";

}
