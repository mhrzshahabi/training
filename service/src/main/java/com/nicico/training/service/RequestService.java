package com.nicico.training.service;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.IRequestService;
import com.nicico.training.iservice.ISynonymOAUserService;
import com.nicico.training.mapper.request.RequestMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.repository.AttachmentDAO;
import com.nicico.training.repository.RequestAuditDAO;
import com.nicico.training.repository.RequestDAO;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.question.dto.ElsAttachmentDto;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RequestService implements IRequestService {

    private final RequestDAO requestDAO;
    private final IBpmsService iBpmsService;
    private final AttachmentDAO attachmentDAO;
    private final RequestMapper requestMapper;
    private final RequestAuditDAO requestAuditDAO;
    private final BpmsClientService bpmsClientService;
    private final ISynonymOAUserService synonymOAUserService;
    private final IOperationalRoleService operationalRoleService;

    @Override
    public List<RequestResVM> findAll() {
        List<Request> all = requestDAO.findAll();
        return requestMapper.mapListEntityToRes(all);
    }

    @Override
    public List<RequestResVM> findAllByStatus(RequestStatus status) {
        List<Request> allByStatus = requestDAO.findAllByStatus(status);
        return requestMapper.mapListEntityToRes(allByStatus);
    }

    @Override
    @Transactional
    public RequestResVM createRequest(RequestReqVM requestReqVM) {
        List<Attachment> requestAttachments=new ArrayList<>();
        Request request = requestMapper.mapReqToEntity(requestReqVM);
        Request save = requestDAO.save(request);
        if(requestReqVM.getAttachments()!=null && requestReqVM.getAttachments().size()>0){
            requestReqVM.getAttachments().forEach(elsAttachmentDto -> {
                Attachment attachment=  saveRequestAttachment(save,elsAttachmentDto);
                requestAttachments.add(attachment);
            });
            save.setRequestAttachments(requestAttachments);
        }

        return requestMapper.mapEntityToRes(save);
    }

    private Attachment saveRequestAttachment(Request request, ElsAttachmentDto elsAttachmentDto){
        Attachment create = new Attachment();
        create.setObjectId(request.getId());
        create.setObjectType("Request");
        create.setFileTypeId(5);
        create.setFileName(elsAttachmentDto.getFileName()!=null ? elsAttachmentDto.getFileName() : "noName" );
        create.setGroup_id(elsAttachmentDto.getGroupId());
        create.setKey(elsAttachmentDto.getAttachment());

      Attachment att=  attachmentDAO.saveAndFlush(create);
      return att;



    }

    @Override
    public RequestResVM changeStatus(String reference, RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public boolean remove(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        requestDAO.delete(request);
        return true;
    }

    @Override
    public RequestResVM answerRequest(String reference, String response,RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setResponse(response);
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public List<RequestAudit> getAuditData(Long requestId) {
      return requestAuditDAO.getAuditData(requestId);
    }

    @Override
    public List<RequestResVM> findAllByNationalCode(String nationalCode) {

        List<Request> allByNationalCode = requestDAO.findAllByNationalCode(nationalCode);
        if(allByNationalCode!=null && allByNationalCode.size()>0){
            allByNationalCode.stream().forEach(request -> {
                List<Attachment> requestAttachments=new ArrayList();
                List<Attachment> responseAttachments=new ArrayList<>();
              List<Attachment> reqAttachments=  attachmentDAO.findAttachmentByObjectTypeAndObjectId("Request",request.getId());
              if(reqAttachments!=null){
                  reqAttachments.stream().forEach(attachment -> {
                      requestAttachments.add(attachment);
                  });
              }
              List<Attachment> resAttachments= attachmentDAO.findAttachmentByObjectTypeAndObjectId("Response",request.getId());
              if(resAttachments!=null){
                  resAttachments.stream().forEach(attachment -> {
                      responseAttachments.add(attachment);
                  });

              }
              request.setRequestAttachments(requestAttachments);
              request.setResponseAttachments(responseAttachments);
            });
        }
     List<RequestResVM> finalList= requestMapper.mapListEntityToRes(allByNationalCode).stream().sorted(Comparator.comparing(RequestResVM::getId)).collect(Collectors.toList());
        return finalList ;

    }

    @Override
    public RequestResVM findByReference(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        List<Attachment> requestAttachments=new ArrayList();
        List<Attachment> responseAttachments=new ArrayList<>();
        List<Attachment> reqAttachments=  attachmentDAO.findAttachmentByObjectTypeAndObjectId("Request",request.getId());
        if(reqAttachments!=null){
            reqAttachments.stream().forEach(attachment -> {
                requestAttachments.add(attachment);
            });
        }
        List<Attachment> resAttachments= attachmentDAO.findAttachmentByObjectTypeAndObjectId("Response",request.getId());
        if(resAttachments!=null){
            resAttachments.stream().forEach(attachment -> {
                responseAttachments.add(attachment);
            });

        }
        request.setRequestAttachments(requestAttachments);
        request.setResponseAttachments(responseAttachments);

        return requestMapper.mapEntityToRes(request);
    }

    @Override
    public void updateStartedRequestProcess(Long id, String processInstanceId) {
        Optional<Request> optionalRequest = requestDAO.findById(id);
        if (optionalRequest.isPresent()) {
            Request request = optionalRequest.get();
            request.setProcessInstanceId(processInstanceId);
            requestDAO.save(request);
        }
    }

    @Override
    public ProcessInstance startTrainingCertificationProcessWithData(StartProcessWithDataDTO startProcessDto) {
        return bpmsClientService.startProcessWithData(startProcessDto);
    }

    @Override
    public StartProcessWithDataDTO getTrainingCertificationStartProcessDto(Long requestId, BpmsStartParamsDto params, String tenantId) {
        Map<String, Object> map = new HashMap<>();
        BaseResponse certificationResponsibleResponse = getCertificationResponsibleNationalCode();
        if (certificationResponsibleResponse.getStatus() == 200) {
            Optional<Request> optionalRequest = requestDAO.findById(requestId);
            if (optionalRequest.isPresent()) {
                map.put("assignTo", certificationResponsibleResponse.getMessage());
                map.put("userId", SecurityUtil.getUserId());
                map.put("assignFrom", SecurityUtil.getNationalCode());
                map.put("tenantId", tenantId);
                map.put("title", params.getData().get("title").toString());
                map.put("createBy", SecurityUtil.getFullName());
                StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
                startProcessDto.setProcessDefinitionKey(iBpmsService.getDefinitionKey(params.getData().get("processDefinitionKey").toString(), tenantId, 0, 10).getMessage());
                startProcessDto.setVariables(map);
                return startProcessDto;
            } else
                throw new TrainingException(TrainingException.ErrorType.NotFound);
        } else {
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
        }
    }

    @Override
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleToYes(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse financialResponsibleResponse = getFinancialResponsibleNationalCode();
        if (financialResponsibleResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", financialResponsibleResponse.getMessage());
                map.put("needToPay", true);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(financialResponsibleResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مسئول مالی تعریف نشده است یا بیش از یک مسئول تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleToNo(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse trainingManagerResponse = getTrainingManagerNationalCode();
        if (trainingManagerResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", trainingManagerResponse.getMessage());
                map.put("needToPay", false);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(trainingManagerResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مدیر آموزش تعریف نشده است یا بیش از یک مدیر تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewTrainingCertificationByFinancialResponsible(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse certificationResponsibleResponse = getCertificationResponsibleNationalCode();
        if (certificationResponsibleResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", certificationResponsibleResponse.getMessage());
                map.put("approved", true);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(certificationResponsibleResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مسئول صدور گواهی نامه تعریف نشده است یا بیش از یک مسئول تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse cancelTrainingCertificationProcessByFinancialResponsible(ReviewTaskRequest reviewTaskRequest, String reason) {

        BaseResponse response = new BaseResponse();
        BaseResponse certificationResponsibleResponse = getCertificationResponsibleNationalCode();
        if (certificationResponsibleResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findFirstByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", certificationResponsibleResponse.getMessage());
                Request request = optionalRequest.get();
                request.setReturnDetail(reason);
                requestDAO.saveAndFlush(request);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(certificationResponsibleResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مسئول صدور گواهی نامه تعریف نشده است یا بیش از یک مسئول تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reAssignTrainingCertificationProcess(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse financialResponsibleResponse = getFinancialResponsibleNationalCode();
        if (financialResponsibleResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", financialResponsibleResponse.getMessage());
                map.put("needToPay", true);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(financialResponsibleResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مسئول مالی تعریف نشده است یا بیش از یک مسئول تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse trainingManagerResponse = getTrainingManagerNationalCode();
        if (trainingManagerResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", trainingManagerResponse.getMessage());
                map.put("approved", true);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(trainingManagerResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مدیر آموزش تعریف نشده است یا بیش از یک مدیر تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewTrainingCertificationByTrainingManager(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        BaseResponse certificationResponsibleResponse = getCertificationResponsibleNationalCode();
        if (certificationResponsibleResponse.getStatus() == 200) {

            Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
            if (optionalRequest.isPresent()) {

                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", certificationResponsibleResponse.getMessage());
                map.put("approved", true);
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
        } else {
            response.setStatus(certificationResponsibleResponse.getStatus());
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("مسئول صدور گواهی نامه تعریف نشده است یا بیش از یک مسئول تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewTrainingCertificationByCertificationResponsibleForIssuing(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<Request> optionalRequest = requestDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
        if (optionalRequest.isPresent())
            response.setStatus(200);
        else
            response.setStatus(404);

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse getCertificationResponsibleNationalCode() {

        BaseResponse response = new BaseResponse();
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByComplexIdAndObjectType("CERTIFICATION_RESPONSIBLE");
        Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList()));
        if (userIds.size() != 1)
            response.setStatus(HttpStatus.FORBIDDEN.value());
        else {
            response.setStatus(HttpStatus.OK.value());
            response.setMessage(synonymOAUserService.getNationalCodeByUserId(userIds.stream().findFirst().get()));
        }
        return response;
    }

    @Override
    public BaseResponse getFinancialResponsibleNationalCode() {

        BaseResponse response = new BaseResponse();
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByComplexIdAndObjectType("FINANCIAL_RESPONSIBLE");
        Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList()));
        if (userIds.size() != 1)
            response.setStatus(HttpStatus.FORBIDDEN.value());
        else {
            response.setStatus(HttpStatus.OK.value());
            response.setMessage(synonymOAUserService.getNationalCodeByUserId(userIds.stream().findFirst().get()));
        }
        return response;
    }

    @Override
    public BaseResponse getTrainingManagerNationalCode() {

        BaseResponse response = new BaseResponse();
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByComplexIdAndObjectType("TRAINING_MANAGER");
        Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList()));
        if (userIds.size() != 1)
            response.setStatus(HttpStatus.FORBIDDEN.value());
        else {
            response.setStatus(HttpStatus.OK.value());
            response.setMessage(synonymOAUserService.getNationalCodeByUserId(userIds.stream().findFirst().get()));
        }
        return response;
    }

}
