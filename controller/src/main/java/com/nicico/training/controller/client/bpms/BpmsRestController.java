package com.nicico.training.controller.client.bpms;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.controller.util.AppUtils;
import dto.bpms.BpmsContent;
import dto.bpms.BpmsDefinitionDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;


@Slf4j
@RestController
@RequestMapping("/bpms")
@RequiredArgsConstructor
public class BpmsRestController {

    private final BpmsClientService client;
    private final ObjectMapper mapper;

    @PostMapping({"/processes/definition-search"})
    public Object searchProcess(@RequestBody ProcessDefinitionRequestDTO processDefinitionRequestDTO, @RequestParam int page, @RequestParam int size) {
        return client.searchProcess(processDefinitionRequestDTO, page, size);
    }

    @PostMapping({"/processes/definition-search/{page}/{size}"})
    public BaseResponse getProcessDefinitionKey(@RequestBody String definitionName, @PathVariable int page, @PathVariable int size)  {
        ProcessDefinitionRequestDTO processDefinitionRequestDTO = new ProcessDefinitionRequestDTO();
        processDefinitionRequestDTO.setTenantId(AppUtils.getTenantId());
        Object object = client.searchProcess(processDefinitionRequestDTO, page, size);
        BpmsDefinitionDto bpmsDefinitionDto = mapper.convertValue(object, new TypeReference<>() {});
        Optional<BpmsContent> bpmsContent= bpmsDefinitionDto.getContent().stream().filter(x -> x.getName().trim().equals(definitionName.trim())).findFirst();
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


    @PostMapping({"/processes/start-data-validation"})
    ProcessInstance startProcessWithData(@RequestParam String processDefinitionKey){
        Map<String, Object> map=new HashMap<>();
        map.put("assignTo","3720228851");
        map.put("userId", SecurityUtil.getUserId());
        map.put("tenantId",AppUtils.getTenantId());
        map.put("title","شایستگی تست");
        map.put("fullName",SecurityUtil.getFullName());
        StartProcessWithDataDTO startProcessDto=new StartProcessWithDataDTO();
        startProcessDto.setProcessDefinitionKey(processDefinitionKey);
        startProcessDto.setVariables(map);
        return client.startProcessWithData(startProcessDto);
    }


}
