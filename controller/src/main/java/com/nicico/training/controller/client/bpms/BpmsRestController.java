package com.nicico.training.controller.client.bpms;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.StateDTO;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.mapper.bpmsNeedAssessment.CompetenceBeanMapper;
import com.nicico.training.service.CompetenceService;
import dto.bpms.BpmsDefinitionDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


@Slf4j
@RestController
@RequestMapping("/api/bpms")
@RequiredArgsConstructor
public class BpmsRestController {

    private final BpmsClientService client;
    private final IBpmsService service;
    private final CompetenceBeanMapper beanMapper;
    private final CompetenceService competenceService;


    @PostMapping({"/processes/definition-search"})
    public Object searchProcess(@RequestBody ProcessDefinitionRequestDTO processDefinitionRequestDTO, @RequestParam int page, @RequestParam int size) {
        return client.searchProcess(processDefinitionRequestDTO, page, size);
    }

    @PostMapping({"/processes/definition-search/{page}/{size}"})
    public BaseResponse getProcessDefinitionKey(@RequestBody String definitionName, @PathVariable int page, @PathVariable int size) {
        return service.getDefinitionKey(definitionName, AppUtils.getTenantId(), page, size);
    }


    @PostMapping({"/processes/start-data-validation"})
    public ResponseEntity<BaseResponse> startProcessWithData(@RequestBody BpmsStartParamsDto params, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<>();
        map.put("assignTo", "3720228851");
        map.put("userId", SecurityUtil.getUserId());
        map.put("tenantId", AppUtils.getTenantId());
        map.put("title", params.getData().get("title").toString());
        map.put("createBy", SecurityUtil.getFullName());
        StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
        startProcessDto.setProcessDefinitionKey(service.getDefinitionKey(params.getData().get("processDefinitionKey").toString(), AppUtils.getTenantId(), 0, 10).getMessage());
        startProcessDto.setVariables(map);
        CompetenceDTO.Create create = beanMapper.toCompetence(params.getRq());
        BaseResponse res = new BaseResponse();
        try {
            ProcessInstance processInstance=  service.startProcessWithData(startProcessDto);
            create.setProcessInstanceId(processInstance.getId());
            competenceService.checkAndCreate(create, response);
            res.setStatus(200);

        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }


}
