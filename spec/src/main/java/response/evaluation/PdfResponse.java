package response.evaluation;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.exam.ExamResultDto;

import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class PdfResponse extends BaseResponse implements Serializable {

    private ByteArrayInputStream data;

}
