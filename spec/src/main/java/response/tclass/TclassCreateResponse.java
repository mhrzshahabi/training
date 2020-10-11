package response.tclass;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.tclass.dto.TclassDto;

@Getter
@Setter
public class TclassCreateResponse extends BaseResponse {
    private TclassDto record;
}
