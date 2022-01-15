package com.nicico.training.controller.client.bpms;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstanceHistory;
import com.nicico.bpmsclient.model.flowable.task.TaskHistory;
import com.nicico.bpmsclient.model.flowable.task.TaskInfo;
import com.nicico.bpmsclient.model.request.TaskSearchDto;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.controller.ISC;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.mapper.bpms.BPMSBeanMapper;
import dto.bpms.*;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.mapper.bpmsNeedAssessment.CompetenceBeanMapper;
import com.nicico.training.service.CompetenceService;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

import java.net.URI;
import java.util.List;


@Slf4j
@RestController
@RequestMapping("/api/bpms")
@RequiredArgsConstructor
public class BpmsRestController {

    private final ObjectMapper mapper;
    private final IBpmsService service;
    private final BpmsClientService client;
    private final BpmsTestApi bpmsTestApi;
    private final BPMSBeanMapper bpmsBeanMapper;
    private final CompetenceBeanMapper beanMapper;
    private final CompetenceService competenceService;


    @PostMapping({"/processes/definition-search"})
    public Object searchProcess(@RequestBody ProcessDefinitionRequestDTO processDefinitionRequestDTO, @RequestParam int page, @RequestParam int size) {
        return client.searchProcess(processDefinitionRequestDTO, page, size);
    }

    //confirm task
    @PostMapping({"/tasks/review"})
    public BaseResponse reviewTask(@RequestBody ReviewTaskRequest reviewTaskRequestDto){
        return service.reviewCompetenceTask(reviewTaskRequestDto);
    }

    @PostMapping({"/processes/definition-search/{page}/{size}"})
    public BaseResponse getProcessDefinitionKey(@RequestBody String definitionName, @PathVariable int page, @PathVariable int size) {
        return service.getDefinitionKey(definitionName, AppUtils.getTenantId(), page, size);
    }

    //cancel task
    @PostMapping({"/processes/cancel-process/{processInstanceId}"})
    public ProcessInstance cancelProcessInstance(@PathVariable(name = "processInstanceId") String processInstanceId, @RequestBody String reason){
           return service.cancelProcessInstance(processInstanceId,reason);
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
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }


    @PutMapping({"/processes/start-data-validation"})
    public ResponseEntity<BaseResponse> editProcessWithData(@RequestBody BpmsStartParamsDto params, HttpServletResponse response) {
        BaseResponse res = new BaseResponse();
        try {
            ProcessInstance processInstance=  service.startProcessWithData(service.getStartProcessDto(params, AppUtils.getTenantId()));
            CompetenceDTO.Update update = beanMapper.toUpdateCompetence(params.getRq());
            update.setProcessInstanceId(processInstance.getId());
            update.setId(params.getRq().getId());
            competenceService.checkAndUpdate(params.getRq().getId(), update,response);
            res.setStatus(200);
        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }

    @GetMapping({"/tasks/user-assigned"})
    List<TaskInfo> getUserTasks(@RequestParam("userId") String userId, @RequestParam("tenantId") String tenantId) {
        return client.getUserTasks(userId, tenantId);
    }

    @PostMapping({"/tasks/searchByUserId"})
    @Loggable
    public ResponseEntity<ISC<BPMSUserTasksContentDto>> searchTaskByUserId(HttpServletRequest iscRq,
                                                                   @RequestParam String userId,
                                                                   @RequestParam String tenantId,
                                                                   @RequestParam int page,
                                                                   @RequestParam int size) throws IOException {

        TaskSearchDto taskSearchDto = new TaskSearchDto();
        taskSearchDto.setUserId(userId);
        taskSearchDto.setTenantId(tenantId);
        log.error("zaza1", "");
        Object object = client.searchTask(taskSearchDto, page, size);
        log.error("zaza2", object.toString());
        BPMSUserTasksDto bpmsUserTasksDto = mapper.convertValue(object, new TypeReference<>() {});
        log.error("zaza3", bpmsUserTasksDto.toString());

        List<BPMSUserTasksContentDto> bpmsUserTasksContentDtoList = bpmsBeanMapper.toUserTasksContentList(bpmsUserTasksDto.getContent());
        log.error("zaza4", bpmsUserTasksContentDtoList.toString());

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<BPMSUserTasksContentDto> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) bpmsUserTasksContentDtoList.size());
        log.error("zaza5", bpmsUserTasksContentDtoList.size()+"");

        searchRs.setList(bpmsUserTasksContentDtoList);

        ISC<BPMSUserTasksContentDto> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    /**
     * to show all the tasks from bpms
     * @param iscRq
     * @param tenantId
     * @param page
     * @param size
     * @return
     * @throws IOException
     */
    @PostMapping({"/tasks/searchAll"})
    public ResponseEntity<ISC<BPMSUserTasksContentDto>> searchAllTask(HttpServletRequest iscRq, @RequestParam String tenantId, @RequestParam int page, @RequestParam int size) throws IOException {

        TaskSearchDto taskSearchDto = new TaskSearchDto();
        taskSearchDto.setTenantId(tenantId);

        Object object = client.searchTask(taskSearchDto, page, size);

        BPMSUserTasksDto bpmsUserTasksDto = mapper.convertValue(object, new TypeReference<>() {});
        List<BPMSUserTasksContentDto> bpmsUserTasksContentDtoList = bpmsBeanMapper.toUserTasksContentList(bpmsUserTasksDto.getContent());

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<BPMSUserTasksContentDto> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) bpmsUserTasksContentDtoList.size());
        searchRs.setList(bpmsUserTasksContentDtoList);

        ISC<BPMSUserTasksContentDto> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @GetMapping({"/processes/process-instance-history/details/{processInstanceId}"})
    List<TaskHistory> getProcessInstanceHistoryById(@PathVariable String processInstanceId) {
        ProcessInstanceHistory processInstanceHistory = client.getProcessInstanceHistoryById(processInstanceId);
        return processInstanceHistory.getTaskHistoryDetailList();
    }

    @GetMapping({"/processes/details/{processInstanceId}"})
    ResponseEntity<CompetenceDTO.Info> getProcessDetailByProcessInstanceId(@PathVariable String processInstanceId) {
        return new ResponseEntity<>(competenceService.getProcessDetailByProcessInstanceId(processInstanceId), HttpStatus.OK);
    }

}
