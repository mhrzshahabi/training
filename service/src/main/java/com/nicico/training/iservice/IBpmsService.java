package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import response.BaseResponse;

public interface IBpmsService {

    BaseResponse getDefinitionKey(String definitionKey, String TenantId,int page,int size);

    ProcessInstance startProcessWithData(StartProcessWithDataDTO startProcessDto);
}
