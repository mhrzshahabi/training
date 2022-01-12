package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.repository.PersonnelDAO;
import dto.bpms.BpmsContent;
import dto.bpms.BpmsDefinitionDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BpmsService implements IBpmsService {

    private final BpmsClientService client;
    private final ObjectMapper mapper;
    private final PersonnelDAO personnelDAO;


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

    @Override
    public ProcessInstance cancelProcessInstance(String processInstanceId) {
        return client.cancelProcessInstance(processInstanceId);
    }

    @Override
    public StartProcessWithDataDTO getStartProcessDto(BpmsStartParamsDto params, String tenantId) {
        Map<String, Object> map = new HashMap<>();
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
//        String mainConfirmBoss = "ahmadi_z";
        String mainConfirmBoss = "3621296476";
        if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
//            mainConfirmBoss = "pourfathian_a";
            mainConfirmBoss = "3149622123";
//            mainConfirmBoss = "hajizadeh_mh";
        }

        map.put("assignTo", mainConfirmBoss);
        map.put("userId", SecurityUtil.getUserId());
        map.put("tenantId",tenantId);
        map.put("title", params.getData().get("title").toString());
        map.put("createBy", SecurityUtil.getFullName());
        StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
        startProcessDto.setProcessDefinitionKey(getDefinitionKey(params.getData().get("processDefinitionKey").toString(), tenantId, 0, 10).getMessage());
        startProcessDto.setVariables(map);
        return startProcessDto;
    }
}