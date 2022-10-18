package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.model.RequestAudit;
import com.nicico.training.model.enums.RequestStatus;
import dto.bpms.BpmsStartParamsDto;
import response.BaseResponse;

import java.util.List;

public interface IRequestService {

    List<RequestResVM> findAll();

    List<RequestResVM> findAllByStatus(RequestStatus status);

    List<RequestResVM> findAllByNationalCode(String nationalCode);

    RequestResVM createRequest(RequestReqVM requestReqVM);

    RequestResVM changeStatus(String reference, RequestStatus status);

    RequestResVM findByReference(String reference);

    boolean remove(String reference);

    RequestResVM answerRequest(String reference, String response,RequestStatus status);

    List<RequestAudit> getAuditData(Long requestId);

    void updateStartedRequestProcess(Long id, String processInstanceId);

    ProcessInstance startTrainingCertificationProcessWithData(StartProcessWithDataDTO startProcessDto);

    StartProcessWithDataDTO getTrainingCertificationStartProcessDto(Long requestId, BpmsStartParamsDto params, String tenantId);

    BaseResponse reviewTrainingCertificationByCertificationResponsibleToYes(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewTrainingCertificationByCertificationResponsibleToNo(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewTrainingCertificationByFinancialResponsible(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewTrainingCertificationByCertificationResponsibleForApproval(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewTrainingCertificationByTrainingManager(ReviewTaskRequest reviewTaskRequest);

    BaseResponse cancelTrainingCertificationProcessByFinancialResponsible(ReviewTaskRequest reviewTaskRequest, String reason);

    BaseResponse reAssignTrainingCertificationProcess(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewTrainingCertificationByCertificationResponsibleForIssuing(ReviewTaskRequest reviewTaskRequest);

    BaseResponse getCertificationResponsibleNationalCode();

    BaseResponse getFinancialResponsibleNationalCode();

    BaseResponse getTrainingManagerNationalCode();

}
