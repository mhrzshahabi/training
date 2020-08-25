package request.needsassessment;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class NeedsAssessmentUpdateRequest implements Serializable {
    private static final long serialVersionUID = -7827181432362662579L;

    private long objectId;
    private String objectType;
    private long needsAssessmentPriorityId;

}
