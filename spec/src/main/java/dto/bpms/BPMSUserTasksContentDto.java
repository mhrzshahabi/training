package dto.bpms;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BPMSUserTasksContentDto {

    private String name;
    private String deploymentId;
    private String tenantId;
    private String createBy;
    private String title;
    private String processInstanceId;
    private String processDefinitionId;
    private String taskId;
    private String tenantTitle;
    private String date;
    private String processStartTime;
    private String taskDefinitionKey;
    private String processDefinitionKey;
//    private List<Object> formListDTOS;
}