package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.training.iservice.IBpmsService;
import dto.bpms.BpmsContent;
import dto.bpms.BpmsDefinitionDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BpmsService implements IBpmsService {

    private final BpmsClientService client;
    private final ObjectMapper mapper;


    @Override
    public BaseResponse getDefinitionKey(String definitionKey, String TenantId,int page,int size) {
        ProcessDefinitionRequestDTO processDefinitionRequestDTO = new ProcessDefinitionRequestDTO();
        processDefinitionRequestDTO.setTenantId(TenantId);
        Object object = client.searchProcess(processDefinitionRequestDTO, page, size);
        BpmsDefinitionDto bpmsDefinitionDto = mapper.convertValue(object, new TypeReference<>() {});
        Optional<BpmsContent> bpmsContent= bpmsDefinitionDto.getContent().stream().filter(x -> x.getName().trim().equals(definitionKey.trim())).findFirst();
        BaseResponse response=new BaseResponse();
        if (bpmsContent.isPresent()){
            response.setStatus(200);
            response.setMessage(bpmsContent.get().getProcessDefinitionKey());
        }else {
            response.setStatus(409);
            response.setMessage("فرایند یافت نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public ProcessInstance startProcessWithData(StartProcessWithDataDTO startProcessDto) {
        return client.startProcessWithData(startProcessDto);
    }
}
