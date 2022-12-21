package dto.bpms;

import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class BpmsCancelTaskDto implements Serializable {
    private String reason;
    private String headNationalCode;
    private ReviewTaskRequest reviewTaskRequest;
}
