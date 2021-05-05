package response.minio;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;

@Setter
@Getter
public class CreateFmsGroupRes extends BaseResponse implements Serializable {
    private String groupId;
}
