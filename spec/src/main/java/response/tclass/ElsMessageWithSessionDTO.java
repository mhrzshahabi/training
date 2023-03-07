package response.tclass;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsMessageWithSessionDTO {
    
    private Long messageId;
    private String title;
    private String context;
    private String groupId;

    //session attributes
    private Long sessionId;
    private String dayName;
    private Long classId;
    private String titleClass;
    private String sessionDate;
    private String sessionStartHour;
    private String sessionEndHour;
}
