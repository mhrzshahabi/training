package dto.bpms;

import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import dto.BpmsCompetenceDTO;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Map;

@Setter
@Getter
public class BpmsCancelTaskDto implements Serializable {
    private String reason;
    private ReviewTaskRequest reviewTaskRequest;
}
