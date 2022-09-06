package dto.bpms;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class BPMSReqItemProcessHistoryDto implements Serializable {
    private String name;
    private String assignee;
    private String timeComing;
    private String endTime;
    private String waitingTime;
    private Boolean approved;
}
