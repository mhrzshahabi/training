package response.evaluation.dto;

 import lombok.Getter;
import lombok.Setter;
 import response.BaseResponse;

 import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class PdfEvalResponse extends BaseResponse implements Serializable {

    private List<EvalResultDto> data;
    private String title;
}
