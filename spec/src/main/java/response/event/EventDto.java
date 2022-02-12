package response.event;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EventDto {
    private Long startTime;
    private Long endTime;
    private String date;
    private String title;
    private String location;
    private String sessionId;
    private String classCode;
    private String classId;
}
