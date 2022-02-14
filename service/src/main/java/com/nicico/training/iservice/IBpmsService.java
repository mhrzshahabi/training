package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import dto.bpms.BpmsStartParamsDto;
import response.BaseResponse;

public interface IBpmsService {

    BaseResponse getDefinitionKey(String definitionKey, String TenantId,int page,int size);

    ProcessInstance startProcessWithData(StartProcessWithDataDTO startProcessDto);

    ProcessInstance cancelProcessInstance(String processInstanceId, String reason);

    StartProcessWithDataDTO getStartProcessDto(BpmsStartParamsDto params,String tenantId,String process);

    BaseResponse reviewCompetenceTask(ReviewTaskRequest reviewTaskRequestDto);

    BaseResponse reviewNeedAssessmentTask(ReviewTaskRequest reviewTaskRequestDto);
}
