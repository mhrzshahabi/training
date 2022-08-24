package com.nicico.training.controller.client.bpms;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.copper.common.Loggable;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.iservice.IRequestItemService;
import dto.bpms.BPMSReqItemCoursesDto;
import dto.bpms.BPMSReqItemSentLetterDto;
import dto.bpms.BpmsCancelTaskDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/certification-bpms")
@RequiredArgsConstructor
public class RequestItemBPMSRestController {

    private final IRequestItemService requestItemService;

    @Loggable
    @PostMapping({"/processes/request-item/start-data-validation"})
    public ResponseEntity<BaseResponse> startRequestItemProcessWithData(@RequestBody BpmsStartParamsDto params) {
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
    @PostMapping({"/processes/request-item/start-data-validation/group"})
    public ResponseEntity startGroupRequestItemProcessWithData(@RequestBody List<BpmsStartParamsDto> paramsList) {
        boolean hasException = false;
        for (BpmsStartParamsDto params : paramsList) {
            Long requestItemId = Long.valueOf(params.getData().get("requestItemId").toString());
            try {
                ProcessInstance processInstance = requestItemService.startRequestItemProcessWithData(requestItemService.getRequestItemStartProcessDto(requestItemId, params, AppUtils.getTenantId()));
                requestItemService.updateStartedRequestItemProcess(requestItemId, processInstance.getId());
            } catch (Exception e) {
                hasException = true;
            }
        }
        return new ResponseEntity<>(hasException, HttpStatus.OK);
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
    @PostMapping({"/tasks/request-item/review/group"})
    public ResponseEntity reviewGroupRequestItemTask(@RequestBody List<ReviewTaskRequest> reviewTaskRequestList) {
        boolean hasException = false;
        for (ReviewTaskRequest reviewTaskRequest : reviewTaskRequestList) {
            BaseResponse response = requestItemService.reviewRequestItemTask(reviewTaskRequest);
            if (response.getStatus() != 200)
                hasException = true;
        }
        return new ResponseEntity<>(hasException, HttpStatus.OK);
    }

    @Loggable
    @PostMapping({"/tasks/parallel/request-item/review/{userNationalCode}"})
    public BaseResponse reviewParallelRequestItemTask(@RequestBody BPMSReqItemCoursesDto bpmsReqItemCoursesDto, @PathVariable String userNationalCode) {
        return requestItemService.reviewParallelRequestItemTask(bpmsReqItemCoursesDto, userNationalCode);
    }

    @Loggable
    @PostMapping({"/tasks/parallel/request-item/review/group/{userNationalCode}"})
    public ResponseEntity reviewGroupParallelRequestItemTask(@RequestBody List<ReviewTaskRequest> reviewTaskRequestList, @PathVariable String userNationalCode) {
        boolean hasException = false;
        for (ReviewTaskRequest reviewTaskRequest : reviewTaskRequestList) {
            BPMSReqItemCoursesDto bPMSReqItemCoursesDto = new BPMSReqItemCoursesDto();
            bPMSReqItemCoursesDto.setReviewTaskRequest(reviewTaskRequest);
            bPMSReqItemCoursesDto.setCourses(requestItemService.getNotPassedCourses(reviewTaskRequest.getProcessInstanceId()));
            BaseResponse response = requestItemService.reviewParallelRequestItemTask(bPMSReqItemCoursesDto, userNationalCode);
            if (response.getStatus() != 200)
                hasException = true;
        }
        return new ResponseEntity<>(hasException, HttpStatus.OK);
    }

    @Loggable
    @PostMapping({"/tasks/determine-status/request-item/review/{chiefNationalCode}"})
    public BaseResponse reviewDetermineStatusRequestItemTask(@RequestBody ReviewTaskRequest reviewTaskRequest, @PathVariable String chiefNationalCode) {
        return requestItemService.reviewRequestItemTaskToDetermineStatus(reviewTaskRequest, chiefNationalCode);
    }

    @Loggable
    @PostMapping({"/tasks/determine-status/request-item/review/group/{chiefNationalCode}"})
    public ResponseEntity reviewGroupDetermineStatusRequestItemTask(@RequestBody List<ReviewTaskRequest> reviewTaskRequestList, @PathVariable String chiefNationalCode) {
        boolean hasException = false;
        for (ReviewTaskRequest reviewTaskRequest : reviewTaskRequestList) {
            BaseResponse response = requestItemService.reviewRequestItemTaskToDetermineStatus(reviewTaskRequest, chiefNationalCode);
            if (response.getStatus() != 200)
                hasException = true;
        }
        return new ResponseEntity<>(hasException, HttpStatus.OK);
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
    @PostMapping({"/tasks/run-chief-for-approval/request-item/review"})
    public BaseResponse reviewRequestItemTaskByRunChiefForApproval(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByRunChiefForApproval(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/planning-chief-for-approval/request-item/review"})
    public BaseResponse reviewRequestItemTaskByPlanningChiefForApproval(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestItemService.reviewRequestItemTaskByPlanningChiefForApproval(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/appointment-expert/request-item/review"})
    public BaseResponse reviewRequestItemTaskByAppointmentExpert(@RequestBody BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto) {
        return requestItemService.reviewRequestItemTaskByAppointmentExpert(bpmsReqItemSentLetterDto);
    }

    @Loggable
    @PostMapping({"/tasks/appointment-expert/request-item/review/group"})
    public ResponseEntity reviewGroupRequestItemTaskByAppointmentExpert(@RequestBody List<BPMSReqItemSentLetterDto> bPMSReqItemSentLetterDtoList) {
        boolean hasException = false;
        for (BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto : bPMSReqItemSentLetterDtoList) {
            BaseResponse response = requestItemService.reviewRequestItemTaskByAppointmentExpert(bpmsReqItemSentLetterDto);
            if (response.getStatus() != 200)
                hasException = true;
        }
        return new ResponseEntity<>(hasException, HttpStatus.OK);
    }

}
