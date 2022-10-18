package com.nicico.training.controller.client.bpms;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.AppUtils;
import com.nicico.training.iservice.IRequestService;
import dto.bpms.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

@Slf4j
@RestController
@RequestMapping("/api/training-certification-bpms")
@RequiredArgsConstructor
public class TrainingCertificationBPMSRestController {

    private final IRequestService requestService;

    @Loggable
    @PostMapping({"/processes/training-certification/start-data-validation"})
    public ResponseEntity<BaseResponse> startTrainingCertificationProcessWithData(@RequestBody BpmsStartParamsDto params) {
        BaseResponse res = new BaseResponse();
        Long requestId = Long.valueOf(params.getData().get("requestId").toString());
        try {
            ProcessInstance processInstance = requestService.startTrainingCertificationProcessWithData(requestService.getTrainingCertificationStartProcessDto(requestId, params, AppUtils.getTenantId()));
            requestService.updateStartedRequestProcess(requestId, processInstance.getId());
            res.setStatus(200);
        } catch (TrainingException trainingException) {
            if (trainingException.getHttpStatusCode().equals(403)) {
                res.setStatus(403);
                res.setMessage("مسئول صدور گواهی نامه تعریف نشده است یا بیش از یک مسئول تعریف شده است");
            } else
                res.setStatus(406);
        } catch (Exception e) {
            res.setStatus(406);
        }
        return new ResponseEntity<>(res, HttpStatus.valueOf(res.getStatus()));
    }

    @Loggable
    @PostMapping({"/tasks/certification-responsible-yes/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleToYes(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByCertificationResponsibleToYes(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/certification-responsible-no/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleToNo(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByCertificationResponsibleToNo(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/financial-responsible/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByFinancialResponsible(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByFinancialResponsible(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/processes/financial-responsible/training-certification/cancel-process"})
    public void cancelTrainingCertificationProcessByFinancialResponsible(@RequestBody BpmsCancelTaskDto value) {
        requestService.cancelTrainingCertificationProcessByFinancialResponsible(value.getReviewTaskRequest(), value.getReason());
    }

    @Loggable
    @PostMapping({"/processes/training-certification/reAssign-process"})
    public BaseResponse reAssignTrainingCertificationProcess(@RequestBody BpmsCancelTaskDto value) {
        return requestService.reAssignTrainingCertificationProcess(value.getReviewTaskRequest());
    }

    @Loggable
    @PostMapping({"/tasks/certification-responsible-approval/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleForApproval(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByCertificationResponsibleForApproval(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/training-manager/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByTrainingManager(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByTrainingManager(reviewTaskRequest);
    }

    @Loggable
    @PostMapping({"/tasks/certification-responsible-issuing/training-certification/review"})
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleForIssuing(@RequestBody ReviewTaskRequest reviewTaskRequest) {
        return requestService.reviewTrainingCertificationByCertificationResponsibleForIssuing(reviewTaskRequest);
    }

}
