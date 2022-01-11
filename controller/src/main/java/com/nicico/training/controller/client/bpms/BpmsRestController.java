package com.nicico.training.controller.client.bpms;


import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.mapper.bpmsNeedAssessment.CompetenceBeanMapper;
import com.nicico.training.service.CompetenceService;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;
import javax.servlet.http.HttpServletResponse;



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

    @PostMapping({"/processes/cancel-process/{processInstanceId}"})
    public ProcessInstance cancelProcessInstance(@PathVariable(name = "processInstanceId") String processInstanceId){
        return service.cancelProcessInstance(processInstanceId);
    }


    @PostMapping({"/processes/start-data-validation"})
    public ResponseEntity<BaseResponse> startProcessWithData(@RequestBody BpmsStartParamsDto params, HttpServletResponse response) {
        BaseResponse res = new BaseResponse();
        try {

                ProcessInstance processInstance=  service.startProcessWithData(service.getStartProcessDto(params, AppUtils.getTenantId()));

                CompetenceDTO.Create create = beanMapper.toCompetence(params.getRq());
                create.setProcessInstanceId(processInstance.getId());
                competenceService.checkAndCreate(create, response);

            res.setStatus(200);

        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));    }

    @NotNull
    private ResponseEntity<BaseResponse> getBaseResponseResponseEntity(@RequestBody BpmsStartParamsDto params, HttpServletResponse response, String method) {
        BaseResponse res = new BaseResponse();
        try {
            if (method.equals("post")){
                ProcessInstance processInstance=  service.startProcessWithData(service.getStartProcessDto(params, AppUtils.getTenantId()));

                CompetenceDTO.Create create = beanMapper.toCompetence(params.getRq());
                create.setProcessInstanceId(processInstance.getId());
                competenceService.checkAndCreate(create, response);
            }else if (method.equals("put")){
                CompetenceDTO.Update update = beanMapper.toUpdateCompetence(params.getRq());
//                update.setProcessInstanceId(processInstance.getId());
                update.setId(params.getRq().getId());
                competenceService.checkAndUpdate(params.getRq().getId(), update,response);
            }
            res.setStatus(200);

        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }

    @PutMapping({"/processes/start-data-validation"})
    public ResponseEntity<BaseResponse> editProcessWithData(@RequestBody BpmsStartParamsDto params, HttpServletResponse response) {
        BaseResponse res = new BaseResponse();
        try {
                CompetenceDTO.Update update = beanMapper.toUpdateCompetence(params.getRq());
//                update.setProcessInstanceId(processInstance.getId());
                update.setId(params.getRq().getId());
                competenceService.checkAndUpdate(params.getRq().getId(), update,response);
            res.setStatus(200);

        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }


}
