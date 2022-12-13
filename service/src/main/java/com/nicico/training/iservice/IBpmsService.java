package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import dto.bpms.BpmsCancelTaskDto;
import dto.bpms.BpmsStartParamsDto;
import response.BaseResponse;

public interface IBpmsService {

    BaseResponse getDefinitionKey(String definitionKey, String TenantId,int page,int size);

    ProcessInstance startProcessWithData(StartProcessWithDataDTO startProcessDto);

    void cancelProcessInstance(ReviewTaskRequest reviewTaskRequest, String reason);

    StartProcessWithDataDTO getStartProcessDto(BpmsStartParamsDto params,String tenantId,String process);

    BaseResponse reviewCompetenceTask(ReviewTaskRequest reviewTaskRequestDto);

    BaseResponse reviewNeedAssessmentTask(ReviewTaskRequest reviewTaskRequestDto);

    void cancelNeedAssessmentProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data);

    BaseResponse reAssignNeedAssessmentProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data);

    BaseResponse checkHasHead(String type);
}
