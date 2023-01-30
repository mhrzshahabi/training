package request.exam;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import response.BaseResponse;

import java.util.List;
import java.util.Map;

@Setter
@Getter
@ToString
public class UpdateScoreResponse extends BaseResponse {
    private Map<String,String> notUpdatedNationalCodes;
}
