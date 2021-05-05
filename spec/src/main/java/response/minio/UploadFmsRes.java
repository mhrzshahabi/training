package response.minio;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;

@Getter
@Setter
public class UploadFmsRes extends BaseResponse implements Serializable {
    private String key;
}
