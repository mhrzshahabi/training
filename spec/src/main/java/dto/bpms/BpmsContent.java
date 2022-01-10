package dto.bpms;

import lombok.Getter;
import lombok.Setter;



@Setter
@Getter
public class BpmsContent {
    private String processDefinitionKey;
    private String processDefinitionId;
    private String name;
    private String deploymentId;
    private String tenantId;
    private String tenantTitle;
    private Integer version;

}
