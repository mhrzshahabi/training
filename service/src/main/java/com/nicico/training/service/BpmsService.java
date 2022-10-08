package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.*;
import dto.bpms.BpmsCancelTaskDto;
import dto.bpms.BpmsContent;
import dto.bpms.BpmsDefinitionDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.*;

@Service
@RequiredArgsConstructor
public class BpmsService implements IBpmsService {

    private final ObjectMapper mapper;
    private final BpmsClientService client;
    private final CompetenceService competenceService;
    private final IRequestItemService requestItemService;
    private final INeedsAssessmentTempService iNeedsAssessmentTempService;


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

        BaseResponse planningChiefResponse = requestItemService.getPlanningChiefNationalCode();
        if (planningChiefResponse.getStatus() == 200) {
            Map<String, Object> map = new HashMap<>();
            map.put("assignTo", planningChiefResponse.getMessage());
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

        iNeedsAssessmentTempService.updateNeedsAssessmentTempWorkflowMainStatusInBpms(data.getReviewTaskRequest().getVariables().get("objectType").toString(), Long.valueOf(data.getReviewTaskRequest().getVariables().get("objectId").toString()), -1, "عدم تایید اصلی",data.getReason());
         client.reviewTask(reviewTaskRequest);
    }

    @Override
    public BaseResponse reAssignNeedAssessmentProcessInstance(ReviewTaskRequest reviewTaskRequest, BpmsCancelTaskDto data) {

        BaseResponse response = new BaseResponse();
        BaseResponse planningChiefResponse = requestItemService.getPlanningChiefNationalCode();
        if (planningChiefResponse.getStatus() == 200) {
            iNeedsAssessmentTempService.updateNeedsAssessmentTempWorkflowMainStatusInBpms(data.getReviewTaskRequest().getVariables().get("objectType").toString(), Long.valueOf(data.getReviewTaskRequest().getVariables().get("objectId").toString()), 0, "ارسال به گردش کار اصلی",data.getReason());
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignTo", planningChiefResponse.getMessage());
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
}
