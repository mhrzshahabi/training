package dto.bpms;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class BPMSReqItemExpertsDto implements Serializable {
    private String nationalCode;
    private String firstName;
    private String lastName;
    private String generalOpinion;
}
