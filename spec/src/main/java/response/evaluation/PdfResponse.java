package response.evaluation;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import java.io.ByteArrayInputStream;
import java.io.Serializable;

@Getter
@Setter
public class PdfResponse extends BaseResponse implements Serializable {

    private ByteArrayInputStream data;

}
