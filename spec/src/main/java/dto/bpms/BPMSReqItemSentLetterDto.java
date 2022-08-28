package dto.bpms;

import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class BPMSReqItemSentLetterDto implements Serializable {
    private String letterNumberSent;
    private String dateSent;
    private ReviewTaskRequest reviewTaskRequest;
}
