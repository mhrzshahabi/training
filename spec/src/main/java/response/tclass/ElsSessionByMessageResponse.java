package response.tclass;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsSessionByMessageResponse extends BaseResponse implements Serializable {
    private List<ElsMessageWithSessionDTO> messages;
}
