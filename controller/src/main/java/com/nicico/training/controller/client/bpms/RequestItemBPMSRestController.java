package com.nicico.training.controller.client.bpms;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.copper.common.Loggable;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.iservice.IRequestItemService;
import dto.bpms.BPMSReqItemCoursesDto;
import dto.bpms.BpmsCancelTaskDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;

@Slf4j
@RestController
@RequestMapping("/api/certification-bpms")
@RequiredArgsConstructor
public class RequestItemBPMSRestController {

    private final IRequestItemService requestItemService;

    @Loggable
    @PostMapping({"/processes/request-item/start-data-validation"})
    public ResponseEntity<BaseResponse> startRequestItemProcessWithData(@RequestBody BpmsStartParamsDto params, HttpServletResponse response) {
        BaseResponse res = new BaseResponse();
        Long requestItemId = Long.valueOf(params.getData().get("requestItemId").toString());
        try {
            ProcessInstance processInstance = requestItemService.startRequestItemProcessWithData(requestItemService.getRequestItemStartProcessDto(requestItemId, params, AppUtils.getTenantId()));
            requestItemService.updateStartedRequestItemProcess(requestItemId, processInstance.getId());
            res.setStatus(200);
        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }

    @Loggable
    @GetMapping({"/processes/details/{processInstanceId}"})
    ResponseEntity<Object> getRequestItemProcessDetailByProcessInstanceId(@PathVariable String processInstanceId) {
        return new ResponseEntity<>(requestItemService.getRequestItemProcessDetailByProcessInstanceId(processInstanceId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping({"/processes/request-item/cancel-process"})
    public void cancelRequestItemProcess(@RequestBody BpmsCancelTaskDto value) {
        requestItemService.cancelRequestItemProcess(value.getReviewTaskRequest(), value.getReason());
    }

    @Loggable
    @PostMapping({"/processes/request-item/reAssign-process"})
    public void reAssignRequestItemProcess(@RequestBody BpmsCancelTaskDto value) {
        requestItemService.reAssignRequestItemProcess(value.getReviewTaskRequest());
    }

    @Loggable
    @PostMapping({"/tasks/request-item/review"})
    public BaseResponse reviewRequestItemTask(@RequestBody ReviewTaskRequest reviewTaskRequestDto) {
        return requestItemService.reviewRequestItemTask(reviewTaskRequestDto);
    }

    @Loggable
    @PostMapping({"/tasks/parallel/request-item/review/{expertOpinionId}/{userNationalCode}"})
    public BaseResponse reviewParallelRequestItemTask(@RequestBody BPMSReqItemCoursesDto bpmsReqItemCoursesDto, @PathVariable Long expertOpinionId, @PathVariable String userNationalCode) {
        return requestItemService.reviewParallelRequestItemTask(bpmsReqItemCoursesDto, expertOpinionId, userNationalCode);
    }

    @Loggable
    @PostMapping({"/tasks/determine-status/request-item/review/{chiefOpinionId}/{chiefNationalCode}"})
    public BaseResponse reviewDetermineStatusRequestItemTask(@RequestBody ReviewTaskRequest reviewTaskRequest, @PathVariable Long chiefOpinionId, @PathVariable String chiefNationalCode) {
        return requestItemService.reviewRequestItemTaskToDetermineStatus(reviewTaskRequest, chiefOpinionId, chiefNationalCode);
    }

    @Loggable
    @PostMapping({"/tasks/run-chief/request-item/review"})
    public BaseResponse reviewRequestItemTaskByRunChief(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByRunChief(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/run-supervisor/request-item/review"})
    public BaseResponse reviewRequestItemTaskByRunSupervisor(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByRunSupervisor(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/run-experts/request-item/review"})
    public BaseResponse reviewRequestItemTaskByRunExperts(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByRunExperts(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/run-supervisor-for-approval/request-item/review"})
    public BaseResponse reviewRequestItemTaskByRunSupervisorForApproval(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByRunSupervisorForApproval(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/appointment-expert/request-item/review/{letterNumberSent}"})
    public BaseResponse reviewRequestItemTaskByAppointmentExpert(@RequestBody ReviewTaskRequest reviewTaskRequest, @PathVariable String letterNumberSent) {
        return requestItemService.reviewRequestItemTaskByAppointmentExpert(reviewTaskRequest, letterNumberSent);
    }

}
