package dto.bpms;

import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashMap;

@Setter
@Getter
public class BPMSUserTasksResponseDto {

    private String name;
    private String deploymentId;
    private String tenantId;
    private LinkedHashMap<String, Object> variables;
    private LinkedHashMap<String, Object> processVariables;
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
