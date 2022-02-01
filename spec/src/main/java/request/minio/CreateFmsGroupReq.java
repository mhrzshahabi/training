package request.minio;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class CreateFmsGroupReq implements Serializable {
    private String name;
    private boolean general;
    private boolean encrypted;
}
