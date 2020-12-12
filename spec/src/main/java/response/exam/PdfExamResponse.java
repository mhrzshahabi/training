package response.exam;

 import lombok.Getter;
import lombok.Setter;
 import response.BaseResponse;

 import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class PdfExamResponse extends BaseResponse implements Serializable {

    private List<ExamResultDto> data;
    private String title;
}
