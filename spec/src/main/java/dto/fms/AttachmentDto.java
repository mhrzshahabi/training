package dto.fms;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AttachmentDto {
    private String fileKey;
    private String description;
    private String name;
    private Integer type;
    private String objectType;
    private Long objectId;
    private String FmsGroup;
}
