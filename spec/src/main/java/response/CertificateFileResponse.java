package response;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class CertificateFileResponse extends BaseResponse {
    private byte[] file;
}
