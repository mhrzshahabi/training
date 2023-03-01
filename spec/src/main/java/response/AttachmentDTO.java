package response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttachmentDTO {
    private String fileName;
    private String minioAddress;
    private String groupId;
}
