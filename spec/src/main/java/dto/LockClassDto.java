package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LockClassDto {
    private Long classId;
    private String groupId;
    private String reason;
}
