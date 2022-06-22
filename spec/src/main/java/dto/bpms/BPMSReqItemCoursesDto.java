package dto.bpms;

import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class BPMSReqItemCoursesDto implements Serializable {
    private List<BPMSReqItemCoursesDetailDto> courses;
    private ReviewTaskRequest reviewTaskRequest;
}
