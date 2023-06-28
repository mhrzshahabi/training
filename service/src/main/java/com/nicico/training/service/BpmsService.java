package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.*;
import dto.bpms.BpmsCancelTaskDto;
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

import static com.nicico.training.model.enums.AgreementStatus.*;

@Service
@RequiredArgsConstructor
public class BpmsService implements IBpmsService {

    private final ObjectMapper mapper;
    private final BpmsClientService client;
    private final CompetenceService competenceService;
    private final IRequestItemService requestItemService;
    private final INeedsAssessmentTempService iNeedsAssessmentTempService;
    private final IAgreementService iAgreementService;
    private final IParameterService parameterService;


    @Override
    public BaseResponse getDefinitionKey(String definitionKey, String TenantId, int page, int size) {
        ProcessDefinitionRequestDTO processDefinitionRequestDTO = new ProcessDefinitionRequestDTO();
        processDefinitionRequestDTO.setTenantId(TenantId);
        Object object = client.searchProcess(processDefinitionRequestDTO, page, size);
        BpmsDefinitionDto bpmsDefinitionDto = mapper.convertValue(object, new TypeReference<>() {
        });
        Optional<BpmsContent> bpmsContent = bpmsDefinitionDto.getContent().stream().filter(x -> x.getName().trim().equals(definitionKey.trim())).findFirst();
        BaseResponse response = new BaseResponse();
        if (bpmsContent.isPresent()) {
            response.setStatus(200);
            response.setMessage(bpmsContent.get().getProcessDefinitionKey());
        } else {
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
    @Transactional
    public void cancelProcessInstance(ReviewTaskRequest reviewTaskRequest, String reason) {
        competenceService.updateStatus(reviewTaskRequest.getProcessInstanceId(), 1L, reason);
        client.reviewTask(reviewTaskRequest);
    }

    @Override
    public StartProcessWithDataDTO getStartProcessDto(BpmsStartParamsDto params, String tenantId, String process) {
        BaseResponse planningChiefResponse = new BaseResponse();
        String userToAssignTo = params.getData().get("HeadNationalCode") != null ? params.getData().get("HeadNationalCode").toString() : null;
        if (userToAssignTo == null) {
            planningChiefResponse = requestItemService.getPlanningChiefNationalCode("HEAD_OF_PLANNING");
        }
        if (userToAssignTo != null || planningChiefResponse.getStatus() == 200) {
            Map<String, Object> map = new HashMap<>();
            if (userToAssignTo == null)
                map.put("assignTo", planningChiefResponse.getMessage());
            else
                map.put("assignTo", userToAssignTo);

            map.put("userId", SecurityUtil.getUserId());
            map.put("assignFrom", SecurityUtil.getNationalCode());
            map.put("tenantId", tenantId);
            map.put("title", params.getData().get("title").toString());
            if (process.equals("needAssessment")) {
                map.put("objectType", params.getRq().getType());
                map.put("objectId", params.getRq().getId());
            }
            map.put("createBy", SecurityUtil.getFullName());
            StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
            startProcessDto.setProcessDefinitionKey(getDefinitionKey(params.getData().get("processDefinitionKey").toString(), tenantId, 0, 10).getMessage());
            startProcessDto.setVariables(map);
            return startProcessDto;
        } else
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
    }

    @Override
    @Transactional
    public BaseResponse reviewCompetenceTask(ReviewTaskRequest reviewTaskRequestDto) {
        BaseResponse res = new BaseResponse();
        BaseResponse competenceRes = competenceService.updateStatus(reviewTaskRequestDto.getProcessInstanceId(), 2L, null);
        if (competenceRes.getStatus() == 200) {
            try {
                client.reviewTask(reviewTaskRequestDto);
                res.setStatus(200);
                res.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                res.setStatus(404);
                res.setMessage("عملیات bpms انجام نشد");
            }
        } else {
            res.setStatus(406);
            res.setMessage("تغییر وضعیت شایستگی انجام نشد");
        }
        return res;
    }

    @Override
    public BaseResponse reviewNeedAssessmentTask(ReviewTaskRequest reviewTaskRequestDto) {
        BaseResponse res = new BaseResponse();
        try {
            iNeedsAssessmentTempService.updateNeedsAssessmentTempMainWorkflow(reviewTaskRequestDto.getProcessInstanceId(), 1, "تایید نهایی اصلی");
            iNeedsAssessmentTempService.verifyNeedsAssessmentTempMainWorkflow(reviewTaskRequestDto.getProcessInstanceId());

            try {
                client.reviewTask(reviewTaskRequestDto);
                res.setStatus(200);
                res.setMessage("عملیات موفقیت آمیز به پایان رسید");
                return res;
            } catch (Exception e) {
                res.setStatus(404);
                res.setMessage("عملیات bpms انجام نشد");
                return res;
            }

        } catch (Exception e) {
            res.setStatus(406);
            res.setMessage("تغییر وضعیت شایستگی انجام نشد");
            return res;
        }
    }

    @Override
    public void cancelNeedAssessmentProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data) {

        iNeedsAssessmentTempService.updateNeedsAssessmentTempWorkflowMainStatusInBpms(data.getReviewTaskRequest().getVariables().get("objectType").toString(), Long.valueOf(data.getReviewTaskRequest().getVariables().get("objectId").toString()), -1, "عدم تایید اصلی", data.getReason());
        client.reviewTask(reviewTaskRequest);
    }

    @Override
    public BaseResponse reAssignNeedAssessmentProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data) {

        BaseResponse response = new BaseResponse();
        BaseResponse planningChiefResponse = requestItemService.getPlanningChiefNationalCode("HEAD_OF_PLANNING");
        String userToAssignTo = data.getHeadNationalCode() != null ? data.getHeadNationalCode() : null;


        if (userToAssignTo!=null || planningChiefResponse.getStatus() == 200 ) {
            iNeedsAssessmentTempService.updateNeedsAssessmentTempWorkflowMainStatusInBpms(data.getReviewTaskRequest().getVariables().get("objectType").toString(), Long.valueOf(data.getReviewTaskRequest().getVariables().get("objectId").toString()), 0, "ارسال به گردش کار اصلی", data.getReason());
            Map<String, Object> map = reviewTaskRequest.getVariables();
            if (userToAssignTo == null)
                map.put("assignTo", planningChiefResponse.getMessage());
            else
                map.put("assignTo", userToAssignTo);

            map.put("approved", true);
            client.reviewTask(reviewTaskRequest);
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("عملیات با موفقیت انجام شد.");
        } else {
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        }
        return response;
    }
    @Override
    public BaseResponse reAssignAgreementProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data) {

        BaseResponse response = new BaseResponse();
        BaseResponse planningChiefResponse = requestItemService.getPlanningChiefNationalCode("FINANCIAL_RESPONSIBLE");
        String userToAssignTo = data.getHeadNationalCode() != null ? data.getHeadNationalCode() : null;


        if (userToAssignTo!=null || planningChiefResponse.getStatus() == 200 ) {
            BaseResponse  baseResponse= iAgreementService.updateAgreement(waiting,reviewTaskRequest.getProcessInstanceId(),null );
            if (baseResponse.getStatus()==200){
                Map<String, Object> map = reviewTaskRequest.getVariables();
                if (userToAssignTo == null)
                    map.put("assignTo", planningChiefResponse.getMessage());
                else
                    map.put("assignTo", userToAssignTo);

                map.put("approved", true);
                client.reviewTask(reviewTaskRequest);
                response.setStatus(planningChiefResponse.getStatus());
                response.setMessage("عملیات با موفقیت انجام شد.");
            }else {
                response.setStatus(406);
                response.setMessage("عملیات انجام نشد");
            }

        } else {
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewAgreementTask(ReviewTaskRequest reviewTaskRequestDto) {
        BaseResponse res = new BaseResponse();
        BaseResponse response =   iAgreementService.updateAgreement(accepted,reviewTaskRequestDto.getProcessInstanceId(),null );
        if (response.getStatus() == 200) {
            try {
                client.reviewTask(reviewTaskRequestDto);
                res.setStatus(200);
                res.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                res.setStatus(404);
                res.setMessage("عملیات bpms انجام نشد");
            }
        } else {
            res.setStatus(406);
            res.setMessage("تغییر وضعیت شایستگی انجام نشد");
        }
        return res;
    }

    @Override
    public BaseResponse checkHasHead(String type) {
        BaseResponse response = new BaseResponse();
        try {
            boolean planningChiefResponse = requestItemService.getPlanningChiefNationalCodeWithCheckDepartment();
            if (planningChiefResponse)
                response.setStatus(200);
            else {
                if (checkConfig())
                    response.setStatus(400);
                else
                    response.setStatus(402);


            }
        } catch (Exception e) {
            response.setStatus(400);
        }
        return response;
    }

    @Override
    public void cancelAgreementProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data) {
        try {
          BaseResponse response =   iAgreementService.updateAgreement(returning,reviewTaskRequest.getProcessInstanceId(),reviewTaskRequest.getVariables().get("returnReason").toString() );
        if (response.getStatus()==200){
            client.reviewTask(reviewTaskRequest);
        }
        }catch (Exception e){

        }

    }

    private boolean checkConfig() {
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("needAssessmentConfig");
        ParameterValueDTO.Info info = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("chooseUser")).findFirst().orElse(null);
        if (info != null) {
            return switch (info.getValue()) {
                case "بله" -> true;
                case "خیر" -> false;
                default -> true;
            };
        } else throw new TrainingException(TrainingException.ErrorType.NotFound);

    }

    @Override
    public StartProcessWithDataDTO startProcessDto(Map<String, Object> params, String tenantId) {
        BaseResponse planningChiefResponse = new BaseResponse();
        String userToAssignTo = params.get("HeadNationalCode") != null ? params.get("HeadNationalCode").toString() : null;
        if (userToAssignTo == null) {
            planningChiefResponse = requestItemService.getPlanningChiefNationalCode("FINANCIAL_RESPONSIBLE");
        }
        if (userToAssignTo != null || planningChiefResponse.getStatus() == 200) {
            Map<String, Object> map = new HashMap<>();
            if (userToAssignTo == null)
                map.put("assignTo", planningChiefResponse.getMessage());
            else
                map.put("assignTo", userToAssignTo);

            map.put("userId", SecurityUtil.getUserId());
            map.put("assignFrom", SecurityUtil.getNationalCode());
            map.put("tenantId", tenantId);
            map.put("title", params.get("title").toString());
            map.put("createBy", SecurityUtil.getFullName());
            StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
            startProcessDto.setProcessDefinitionKey(getDefinitionKey(params.get("processDefinitionKey").toString(), tenantId, 0, 20).getMessage());
            startProcessDto.setVariables(map);
            return startProcessDto;
        } else
            throw new TrainingException(TrainingException.ErrorType.Forbidden);
    }
}
