package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.ProcessInstanceHistory;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.mapper.requestItem.RequestItemCoursesDetailBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.RequestItemState;
import com.nicico.training.repository.RequestItemDAO;
import dto.bpms.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.*;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class RequestItemService implements IRequestItemService {

    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final ITclassService classService;
    private final RequestItemDAO requestItemDAO;
    private ITrainingPostService trainingPostService;
    private final IPersonnelService personnelService;
    private final BpmsClientService bpmsClientService;
    private final IDepartmentService departmentService;
    private final ISynonymOAUserService synonymOAUserService;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IParameterValueService parameterValueService;
    private final IOperationalRoleService operationalRoleService;
    private final INeedsAssessmentService needsAssessmentService;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final ICompetenceRequestService competenceRequestService;
    private final INeedsAssessmentReportsService iNeedsAssessmentReportsService;
    private final IRequestItemProcessDetailService requestItemProcessDetailService;
    private final IRequestItemCoursesDetailService requestItemCoursesDetailService;
    private final RequestItemCoursesDetailBeanMapper requestItemCoursesDetailBeanMapper;

    @Autowired
    public void setTrainingPostService(@Lazy ITrainingPostService trainingPostService) {
        this.trainingPostService = trainingPostService;
    }

    @Override
    @Transactional
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItem create(RequestItem requestItem, Long id) {
        CompetenceRequest competenceRequest = competenceRequestService.get(requestItem.getCompetenceReqId());
        requestItem.setCompetenceReq(competenceRequest);
        RequestItem saved = requestItemDAO.save(requestItem);
//        saved.setNationalCode(getNationalCode(saved.getPersonnelNumber()));
        return saved;
    }

    @Override
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public RequestItemWithDiff update(RequestItem newData, Long id) {
        RequestItem requestItem = get(id);
        requestItem.setAffairs(newData.getAffairs());
        requestItem.setCompetenceReq(newData.getCompetenceReq());
        requestItem.setCompetenceReqId(newData.getCompetenceReqId());
        requestItem.setLastName(newData.getLastName());
        requestItem.setName(newData.getName());
        requestItem.setPersonnelNumber(newData.getPersonnelNumber());
        requestItem.setPersonnelNo2(newData.getPersonnelNo2());
        requestItem.setPost(newData.getPost());
        requestItem.setNationalCode(newData.getNationalCode());
        return getRequestDiff(requestItem);
    }

    @Override
    public RequestItem get(Long id) {
        return requestItemDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public Long getIdByProcessInstanceId(String processInstanceId) {
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(processInstanceId);
        return optionalRequestItem.map(RequestItem::getId).orElse(null);
    }

    public String getNationalCode(String personnelNumber) {
        Personnel personnel = personnelService.getByPersonnelNumber(personnelNumber);
        return personnel.getNationalCode();
    }

    @Override
//    @CacheEvict(value = "searchIRequestItemService", key = "{#id}", allEntries = true)
    public void delete(Long id) {
        requestItemDAO.deleteById(id);
    }

    @Override
    public List<RequestItem> getList() {
        return requestItemDAO.findAll();
    }

    @Override
    public Integer getTotalCount() {
        return Math.toIntExact(requestItemDAO.count());
    }

    @Override
    public Integer getTotalStartedProcessCount() {
        return Math.toIntExact(requestItemDAO.getTotalStartedProcessCount());
    }

    @Override
    public Integer getTotalCountForOneCompetenceReqId(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id).size();
    }

    @Override
//    @Cacheable(value = "searchIRequestItemService", key = "{#id}")
    public List<RequestItem> search(SearchDTO.SearchRq request, Long id) {
        List<RequestItem> list;
        if (request.getStartIndex() != null) {
            Page<RequestItem> all = requestItemDAO.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));
            list = all.getContent();
        } else {
            list = requestItemDAO.findAll(NICICOSpecification.of(request));
        }
        return list;

    }

    @Transactional(readOnly = true)
    @Override
    public List<RequestItem> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(requestItemDAO, request, educationLevel -> modelMapper.map(educationLevel, RequestItem.class)).getList();
    }

    @Override
    @Transactional
    public RequestItemDto createList(List<RequestItem> requestItems) {
        requestItems = requestItems.stream().filter(item -> item.getNationalCode() != null).collect(Collectors.toList());
        List<RequestItem> temp=new ArrayList<>();
        if (!requestItems.isEmpty()){
          Long competenceReqId=  requestItems.get(0).getCompetenceReqId();
            List<RequestItem> list = getListWithCompetenceRequest(competenceReqId);
            for (RequestItem requestItem:requestItems) {
                if (!(!list.isEmpty() && list.stream().anyMatch(q -> q.getNationalCode().equals(requestItem.getNationalCode()))))
                    temp.add(requestItem);
            }
            if (list.isEmpty())
                temp=requestItems;
        }
        RequestItemDto res = new RequestItemDto();
        List<RequestItemWithDiff> requestItemWithDiffList = new ArrayList<>();
        for (RequestItem requestItem : temp) {
            RequestItemWithDiff data = getRequestDiff(requestItem);
            if (data.isNationalCodeCorrect() || data.isPersonnelNo2Correct()) {
                requestItemWithDiffList.add(data);
            }

        }
        int wrongCount = getWrongCount(requestItemWithDiffList);
        res.setWrongCount(wrongCount);
        res.setList(requestItemWithDiffList);
        return res;
    }

    @Override
    public List<RequestItem> getListWithCompetenceRequest(Long id) {
        return requestItemDAO.findAllByCompetenceReqId(id);
    }

    @Override
    public List<RequestItemDTO.ExcelOutputInfo> getItemListWithCompetenceRequest(Long id) {

        List<RequestItemDTO.ExcelOutputInfo> infoList = new ArrayList<>();
        List<RequestItem> requestItems = requestItemDAO.findAllByCompetenceReqId(id);
        requestItems.forEach(item -> {
            RequestItemDTO.ExcelOutputInfo excelOutputInfo = requestItemBeanMapper.toRequestItemExcelOutputDto(item);
            infoList.add(excelOutputInfo);
        });
        return infoList;
    }

    @Override
    public List<Long> getAllRequestItemIdsWithCompetenceId(Long competenceId) {
        return requestItemDAO.findAllRequestItemIdsWithCompetenceId(competenceId);
    }

    @Override
    public RequestItemWithDiff validData(Long id) {
        Optional<RequestItem> requestItemOptional = requestItemDAO.findById(id);
        if (requestItemOptional.isPresent()) {
            RequestItem requestItem = requestItemOptional.get();
            return getRequestDiff(requestItem);
        } else
            throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    @Transactional
    public void updateOperationalRoles(Long id) {

        RequestItem requestItem = get(id);
        Optional<TrainingPost> optionalTrainingPost = trainingPostService.isTrainingPostExist(requestItem.getPost());
        TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        try {
            List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByPostIdsAndComplexIdAndObjectType(trainingPost.getId(), "MASTER_OF_PLANNING");
            List<Long> operationalRoleIds = operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList());
            requestItem.setOperationalRoleIds(new ArrayList<>());
            requestItem.setOperationalRoleIds(operationalRoleIds);
            requestItemDAO.save(requestItem);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
    }

    @Override
    @Transactional
    public void updateStartedRequestItemProcess(Long id, String processInstanceId) {
        RequestItem requestItem = get(id);
        requestItem.setProcessInstanceId(processInstanceId);
        requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChief"));
        requestItemDAO.save(requestItem);
    }

    @Override
    public BaseResponse getDefinitionKey(String definitionKey, String TenantId, int page, int size) {
        ProcessDefinitionRequestDTO processDefinitionRequestDTO = new ProcessDefinitionRequestDTO();
        processDefinitionRequestDTO.setTenantId(TenantId);
        Object object = bpmsClientService.searchProcess(processDefinitionRequestDTO, page, size);
        BpmsDefinitionDto bpmsDefinitionDto = objectMapper.convertValue(object, new TypeReference<>() {
        });
        Optional<BpmsContent> bPMSContent = bpmsDefinitionDto.getContent().stream().filter(x -> x.getName().trim().equals(definitionKey.trim())).findFirst();
        BaseResponse response = new BaseResponse();
        if (bPMSContent.isPresent()) {
            response.setStatus(200);
            response.setMessage(bPMSContent.get().getProcessDefinitionKey());
        } else {
            response.setStatus(409);
            response.setMessage("فرایند یافت نشد");
        }
        return response;
    }

    @Override
    public StartProcessWithDataDTO getRequestItemStartProcessDto(Long requestItemId, BpmsStartParamsDto params, String tenantId) {
        Map<String, Object> map = new HashMap<>();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findById(requestItemId);
        if (optionalRequestItem.isPresent()) {

            BaseResponse planningChiefResponse = getPlanningChiefNationalCode();
            if (planningChiefResponse.getStatus() == 200) {
                map.put("assignTo", planningChiefResponse.getMessage());
                map.put("userId", SecurityUtil.getUserId());
                map.put("assignFrom", SecurityUtil.getNationalCode());
                map.put("tenantId", tenantId);
                map.put("title", params.getData().get("title").toString());
                map.put("createBy", SecurityUtil.getFullName());
                map.put("requestItemId", params.getData().get("requestItemId").toString());
                map.put("requestNo", params.getData().get("requestNo").toString());
                StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
                startProcessDto.setProcessDefinitionKey(getDefinitionKey(params.getData().get("processDefinitionKey").toString(), tenantId, 0, 10).getMessage());
                startProcessDto.setVariables(map);
                return startProcessDto;
            } else
                throw new TrainingException(TrainingException.ErrorType.Forbidden);
        } else
            throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Override
    @Transactional
    public ProcessInstance startRequestItemProcessWithData(StartProcessWithDataDTO startProcessDto) {
        return bpmsClientService.startProcessWithData(startProcessDto);
    }

    @Override
    public RequestItemDTO.Info getRequestItemProcessDetailByProcessInstanceId(String processInstanceId) {
        Optional<RequestItem> requestItemOptional = requestItemDAO.findByProcessInstanceId(processInstanceId);
        return requestItemBeanMapper.toRequestItemDto(requestItemOptional.orElse(null));
    }

    @Override
    @Transactional
    public void cancelRequestItemProcess(ReviewTaskRequest reviewTaskRequest, String reason) {
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findFirstByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            requestItem.setReturnDetail(reason);
            requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPositionAppointmentExpert"));
            requestItemDAO.saveAndFlush(requestItem);
        }
        bpmsClientService.reviewTask(reviewTaskRequest);
    }

    @Override
    @Transactional
    public BaseResponse cancelParallelRequestItemProcess(ReviewTaskRequest reviewTaskRequest, String reason) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findFirstByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        BaseResponse planningChiefResponse = getPlanningChiefNationalCode();
        if (planningChiefResponse.getStatus() == 200) {
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignTo", planningChiefResponse.getMessage());
            if (optionalRequestItem.isPresent()) {
                RequestItem requestItem = optionalRequestItem.get();
                requestItem.setReturnDetail(reason);
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChief"));
                requestItemDAO.saveAndFlush(requestItem);
            }
            bpmsClientService.reviewTask(reviewTaskRequest);
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("عملیات با موفقیت انجام شد.");
        } else {
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        }
        return response;
    }

    @Override
    public BaseResponse reAssignRequestItemProcess(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        BaseResponse planningChiefResponse = getPlanningChiefNationalCode();
        if (planningChiefResponse.getStatus() == 200) {
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignTo", planningChiefResponse.getMessage());
            map.put("approved", true);

            if (optionalRequestItem.isPresent()) {
                RequestItem requestItem = optionalRequestItem.get();
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChief"));
                requestItemDAO.saveAndFlush(requestItem);
            }
            bpmsClientService.reviewTask(reviewTaskRequest);
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("عملیات با موفقیت انجام شد.");
        } else {
            response.setStatus(planningChiefResponse.getStatus());
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reAssignParallelRequestItemProcess(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            List<String> assigneeList = getPlanningExpertsAssigneeList(requestItem.getPost());

            if (assigneeList.size() == 0) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assigneeList", assigneeList);
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningExperts"));
                requestItemDAO.saveAndFlush(requestItem);
                response.setStatus(200);
            }
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 400) {
            response.setMessage("کارشناس ارشد برنامه ریزی برای پست پیشنهادی یافت نشد");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTask(ReviewTaskRequest reviewTaskRequestDto) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequestDto.getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            List<String> assigneeList = getPlanningExpertsAssigneeList(requestItem.getPost());

            if (assigneeList.size() == 0) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Map<String, Object> map = reviewTaskRequestDto.getVariables();
                map.put("assigneeList", assigneeList);
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningExperts"));
                requestItemDAO.saveAndFlush(requestItem);
                response.setStatus(200);
            }
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequestDto);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 400) {
            response.setMessage("کارشناس ارشد برنامه ریزی برای پست پیشنهادی یافت نشد");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewParallelRequestItemTask(BPMSReqItemCoursesDto bpmsReqItemCoursesDto, String userNationalCode) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(bpmsReqItemCoursesDto.getReviewTaskRequest().getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            BaseResponse planningChiefResponse = getPlanningChiefNationalCode();
            if (planningChiefResponse.getStatus() == 200) {

                RequestItem requestItem = optionalRequestItem.get();
                Map<String, Object> map = bpmsReqItemCoursesDto.getReviewTaskRequest().getVariables();
                RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), userNationalCode);

                if (requestItemProcessDetail == null) {
                    Long count = bpmsReqItemCoursesDto.getCourses().stream().filter(item -> item.getPriority().contains("انتصاب")).count();
                    RequestItemProcessDetailDTO.Create requestItemProcessDetailDTO = new RequestItemProcessDetailDTO.Create();
                    requestItemProcessDetailDTO.setRequestItemId(requestItem.getId());
                    requestItemProcessDetailDTO.setExpertsOpinionId(count > 0 ? parameterValueService.getId("needToPassCourse") : parameterValueService.getId("noObjection"));
                    requestItemProcessDetailDTO.setExpertNationalCode(userNationalCode);
                    requestItemProcessDetailDTO.setRoleName("planningExpert");
                    requestItemProcessDetail = requestItemProcessDetailService.create(requestItemProcessDetailDTO);
                }

                if (bpmsReqItemCoursesDto.getCourses().size() != 0) {
                    for (BPMSReqItemCoursesDetailDto reqItemCoursesDetailDto : bpmsReqItemCoursesDto.getCourses()) {
                        reqItemCoursesDetailDto.setRequestItemProcessDetailId(requestItemProcessDetail.getId());
                        RequestItemCoursesDetailDTO.Create create = modelMapper.map(reqItemCoursesDetailDto, RequestItemCoursesDetailDTO.Create.class);
                        requestItemCoursesDetailService.create(create);
                    }
                }

                List<RequestItemProcessDetail> requestItemProcessDetailList = requestItemProcessDetailService.findAllByRequestItemId(requestItem.getId());
                List<Long> expertsOpinionId = requestItemProcessDetailList.stream().map(RequestItemProcessDetail::getExpertsOpinionId).collect(Collectors.toList());
                map.put("assignTo", planningChiefResponse.getMessage());
                map.put("approved", true);
                Object assigneeObject = map.get("assigneeList");
                if (assigneeObject != null) {

                    List<String> assigneeList = (List<String>) assigneeObject;
                    if (assigneeList.size() == requestItemProcessDetailList.size()) {
                        RequestItemProcessDetailDTO.Create requestItemProcessDetailDTO = new RequestItemProcessDetailDTO.Create();
                        requestItemProcessDetailDTO.setRequestItemId(requestItem.getId());
                        requestItemProcessDetailDTO.setExpertsOpinionId(expertsOpinionId.contains(parameterValueService.getId("needToPassCourse")) ?
                                parameterValueService.getId("needToPassCourse") : parameterValueService.getId("noObjection"));
                        requestItemProcessDetailDTO.setExpertNationalCode(planningChiefResponse.getMessage());
                        requestItemProcessDetailDTO.setRoleName("planningChief");
                        requestItemProcessDetailService.create(requestItemProcessDetailDTO);
                        requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChiefToDetermineStatus"));
                        requestItemDAO.saveAndFlush(requestItem);
                    }
                    response.setStatus(200);
                } else {
                    response.setStatus(404);
                }
            } else
                response.setStatus(planningChiefResponse.getStatus());
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(bpmsReqItemCoursesDto.getReviewTaskRequest());
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 403) {
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskToDetermineStatus(ReviewTaskRequest reviewTaskRequest, Long chiefOpinionId, String userNationalCode) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            BaseResponse runChiefResponse = getRunChiefNationalCode();
            if (runChiefResponse.getStatus() == 200) {
                String mainRunChief = runChiefResponse.getMessage();

                RequestItem requestItem = optionalRequestItem.get();
                RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), userNationalCode);
                List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItem(requestItem.getId());


                Long needToPassId = parameterValueService.getId("needToPassCourse");
                List<Long> expertsOpinionId = requestItemProcessDetailService.findByRequestItemIdAndRoleName(requestItem.getId(), "planningExpert")
                        .stream().map(RequestItemProcessDetail::getExpertsOpinionId).collect(Collectors.toList());

                if (expertsOpinionId.stream().noneMatch(item -> item.equals(needToPassId)) && courses.size() == 0 && chiefOpinionId != null && chiefOpinionId.equals(needToPassId))
                    response.setStatus(HttpStatus.PRECONDITION_FAILED.value());
                else {

                    if (chiefOpinionId != null) {
                        requestItemProcessDetailService.updateOpinion(requestItemProcessDetail.getId(), chiefOpinionId);
                    }

                    if (courses.size() != 0) {
                        for (RequestItemCoursesDetailDTO.Info requestItemCoursesDetailDTO : courses) {
                            RequestItemCoursesDetailDTO.Create create = modelMapper.map(requestItemCoursesDetailDTO, RequestItemCoursesDetailDTO.Create.class);
                            create.setRequestItemProcessDetailId(requestItemProcessDetail.getId());
                            requestItemCoursesDetailService.create(create);
                        }
                    }

                    Map<String, Object> variables = reviewTaskRequest.getVariables();
                    if (requestItemProcessDetail.getExpertsOpinionId().equals(parameterValueService.getId("needToPassCourse"))) {
                        //  مانع
                        // رییس اجرا
                        variables.put("finalOpinion", "needToPassCourse");
                        variables.put("assignTo", mainRunChief);
                    } else {
                        // بلامانع
                        if (courses.stream().filter(item -> item.getPriority().contains("ضمن خدمت")).count() != 0) {
                            // دارای ضمن خدمت
                            // رییس اجرا و کارشناس انتصاب سمت
                            variables.put("finalOpinion", "noObjection");
                            variables.put("haveWhileServing", true);
                            variables.put("assignTo", mainRunChief);
                            variables.put("assignToAnother", reviewTaskRequest.getVariables().get("assignFrom"));
                        } else {
                            // بدون ضمن خدمت
                            // کارشناس انتصاب سمت
                            variables.put("finalOpinion", "noObjection");
                            variables.put("haveWhileServing", false);
                            variables.put("assignToAnother", reviewTaskRequest.getVariables().get("assignFrom"));
                        }
                    }
                    requestItem.setProcessStatusId(parameterValueService.getId("finalApprovalByPlanningChief"));
                    requestItemDAO.saveAndFlush(requestItem);
                    response.setStatus(200);
                }

            } else {
                response.setStatus(runChiefResponse.getStatus());
            }

        } else {
            response.setStatus(404);
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
            response.setMessage("رئیس اجرا تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        } else if (response.getStatus() == 412) {
            response.setMessage("بدلیل نظر همه کارشناسان مبنی بر بلامانع و عدم انتخاب حداقل یک دوره؛ امکان انتخاب نیاز به گذراندن دوره وجود ندارد");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunChief(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getSupervisorAssigneeList(courseCategoryInfos);
            if (coursesAssigneeList.stream().anyMatch(item -> item.getSupervisorAssigneeList().size() != 1)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Collection<String> supervisorAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                Collection<String> courseCodeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getCourseCode).collect(Collectors.toList());
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("supervisorAssigneeList", supervisorAssigneeList);
                map.put("noObjCoursesList", courseCodeList);
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByRunSupervisorToHoldingCourses"));
                requestItemDAO.saveAndFlush(requestItem);
                response.setStatus(200);
            }
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 400) {
            response.setMessage("برای بعضی از دوره ها سرپرست اجرا تعریف نشده است یا بیش از یک سرپرست تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunChiefNeedToPass(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getSupervisorAssigneeList(courseCategoryInfos);
            if (coursesAssigneeList.stream().anyMatch(item -> item.getSupervisorAssigneeList().size() != 1)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Map<String, Object> map = reviewTaskRequest.getVariables();
                List<RequestItemCoursesDetailDTO.CourseCategoryInfo> appointmentCoursesAssigneeList = coursesAssigneeList.stream().filter(item -> item.getPriority().contains("انتصاب سمت")).collect(Collectors.toList());
                List<RequestItemCoursesDetailDTO.CourseCategoryInfo> otherCoursesAssigneeList = coursesAssigneeList.stream().filter(item -> !item.getPriority().contains("انتصاب سمت")).collect(Collectors.toList());

                if (appointmentCoursesAssigneeList.size() != 0) {
                    // دوره های انتصاب سمت
                    Collection<String> appointmentAssigneeList = appointmentCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                    Collection<String> appCourseCodeList = appointmentCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getCourseCode).collect(Collectors.toList());
                    if (otherCoursesAssigneeList.size() != 0) {
                        // سایر دوره ها
                        Collection<String> otherAssigneeList = otherCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                        List<String> courseCodeList = otherCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getCourseCode).collect(Collectors.toList());
                        map.put("haveAppointment", true);
                        map.put("supervisorAssigneeList", appointmentAssigneeList);
                        map.put("appCoursesList", appCourseCodeList);
                        map.put("haveOthers", true);
                        map.put("supervisorAssigneeListOther", otherAssigneeList);
                        map.put("coursesList", courseCodeList);
                    } else {
                        map.put("haveAppointment", true);
                        map.put("supervisorAssigneeList", appointmentAssigneeList);
                        map.put("appCoursesList", appCourseCodeList);
                        map.put("haveOthers", false);
                    }
                } else {
                    // سایر دوره ها
                    Collection<String> otherAssigneeList = otherCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                    List<String> courseCodeList = otherCoursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getCourseCode).collect(Collectors.toList());
                    map.put("haveAppointment", false);
                    map.put("haveOthers", true);
                    map.put("supervisorAssigneeListOther", otherAssigneeList);
                    map.put("coursesList", courseCodeList);
                }
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByRunSupervisorToHoldingCourses"));
                requestItemDAO.saveAndFlush(requestItem);
                response.setStatus(200);

            }
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 400) {
            response.setMessage("برای بعضی از دوره ها سرپرست اجرا تعریف نشده است یا بیش از یک سرپرست تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewRequestItemTaskByRunSupervisor(ReviewTaskRequest reviewTaskRequest, String courseCode) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getExpertsAssigneeList(courseCategoryInfos);
//            if (coursesAssigneeList.stream().anyMatch(item -> item.getExpertsAssigneeList().size() == 0)) {
            if (coursesAssigneeList.stream().filter(item -> item.getCourseCode().equals(courseCode)).anyMatch(item -> item.getExpertsAssigneeList().size() != 1)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
//                Collection<String> expertsAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getExpertsAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                Collection<String> expertsAssigneeList = coursesAssigneeList.stream().filter(item -> item.getCourseCode().equals(courseCode)).map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getExpertsAssigneeList).flatMap(Collection::stream).collect(Collectors.toList());
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("expertsAssigneeList", expertsAssigneeList);
                map.put("requestItemId", requestItem.getId());
                response.setStatus(200);
            }
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                response.setMessage("عملیات موفقیت آمیز به پایان رسید");
            } catch (Exception e) {
                response.setStatus(404);
                response.setMessage("عملیات bpms انجام نشد");
            }
        } else if (response.getStatus() == 400) {
            response.setMessage("برای دوره موردنظر کارشناس اجرا تعریف نشده است یا بیش از یک کارشناس تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunExperts(ReviewTaskRequest reviewTaskRequest, String courseCode) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

//            RequestItem requestItem = optionalRequestItem.get();
//            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
//            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
//            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

//            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getSupervisorAssigneeList(courseCategoryInfos);
//            if (coursesAssigneeList.stream().anyMatch(item -> item.getSupervisorAssigneeList().size() == 0)) {
//                response.setStatus(HttpStatus.BAD_REQUEST.value());
//            } else {
//                Collection<String> supervisorAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
//                Map<String, Object> map = reviewTaskRequest.getVariables();
//                map.put("supervisorAssigneeList", supervisorAssigneeList);
//                map.put("requestItemId", requestItem.getId());
//                response.setStatus(200);
//            }
            response.setStatus(200);
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(reviewTaskRequest);
                requestItemCoursesDetailService.updateCoursesDetailAfterRunExpertManualReview(reviewTaskRequest.getProcessInstanceId(), courseCode);
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
    public void autoReviewRequestItemTaskByRunExperts(List<RequestItemCoursesDetailDTO.CompleteTaskDto> completeTaskDtoList) {

        BaseResponse response = new BaseResponse();
        completeTaskDtoList.forEach(item -> {
            Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(item.getProcessInstanceId());
            if (optionalRequestItem.isPresent()) {
                ReviewTaskRequest reviewTaskRequest = new ReviewTaskRequest();
                reviewTaskRequest.setProcessInstanceId(item.getProcessInstanceId());
                reviewTaskRequest.setTaskId(item.getTaskIdPerCourse());
                reviewTaskRequest.setUserName(SecurityUtil.getUsername());
                reviewTaskRequest.setApprove(true);
                try {
                    bpmsClientService.reviewTask(reviewTaskRequest);
                    RequestItemCoursesDetail requestItemCoursesDetail = requestItemCoursesDetailService.findById(item.getId());
                    requestItemCoursesDetail.setProcessState("تایید اتوماتیک کارشناس اجرا");
                    requestItemCoursesDetailService.save(requestItemCoursesDetail);
                    response.setStatus(HttpStatus.OK.value());
                } catch (Exception e) {
                    response.setStatus(HttpStatus.EXPECTATION_FAILED.value());
                }
            }
        });
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunSupervisorForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            BaseResponse runChiefResponse = getRunChiefNationalCode();
            if (runChiefResponse.getStatus() == 200) {
                String mainRunChief = runChiefResponse.getMessage();
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", mainRunChief);
                response.setStatus(200);
            } else {
                response.setStatus(runChiefResponse.getStatus());
            }
        } else {
            response.setStatus(404);
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
            response.setMessage("رئیس اجرا تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunChiefForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            BaseResponse planningChiefResponse = getPlanningChiefNationalCode();
            if (planningChiefResponse.getStatus() == 200) {
                RequestItem requestItem = optionalRequestItem.get();
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("assignTo", planningChiefResponse.getMessage());
                requestItem.setProcessStatusId(parameterValueService.getId("waitingFinalApprovalByPlanningChief(AfterRun)"));
                requestItemDAO.saveAndFlush(requestItem);
                response.setStatus(200);
            } else
                response.setStatus(planningChiefResponse.getStatus());
        } else {
            response.setStatus(404);
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
            response.setMessage("رئیس برنامه ریزی تعریف نشده است یا بیش از یک رئیس تعریف شده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByPlanningChiefForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItem(requestItem.getId());
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignToAnother", reviewTaskRequest.getVariables().get("assignFrom"));
            if (!requestItemProcessDetail.getExpertsOpinionId().equals(parameterValueService.getId("needToPassCourse")) &&
                    courses.stream().filter(item -> item.getPriority().contains("ضمن خدمت")).count() != 0)
                requestItem.setProcessStatusId(parameterValueService.getId("terminationOfTheProcess"));
            else
                requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPositionAppointmentExpert"));
            requestItemDAO.saveAndFlush(requestItem);
            response.setStatus(200);
        } else {
            response.setStatus(404);
        }

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
    @Transactional
    public BaseResponse reviewRequestItemTaskByAppointmentExpert(BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(bpmsReqItemSentLetterDto.getReviewTaskRequest().getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(requestItem.getId(), "planningChief");
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItem(requestItem.getId());
            requestItem.setLetterNumberSent(bpmsReqItemSentLetterDto.getLetterNumberSent());
            requestItem.setDateSent(bpmsReqItemSentLetterDto.getDateSent());
            if (requestItemProcessDetail.getExpertsOpinionId().equals(parameterValueService.getId("needToPassCourse")) ||
                    (!requestItemProcessDetail.getExpertsOpinionId().equals(parameterValueService.getId("needToPassCourse")) &&
                    courses.stream().filter(item -> item.getPriority().contains("ضمن خدمت")).count() == 0)) {
                requestItem.setProcessStatusId(parameterValueService.getId("terminationOfTheProcess"));
            }
            requestItemDAO.saveAndFlush(requestItem);
            response.setStatus(200);
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(bpmsReqItemSentLetterDto.getReviewTaskRequest());
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
    @Transactional
    public BaseResponse reviewRequestItemTaskByAppointmentExpertNoLetter(BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(bpmsReqItemSentLetterDto.getReviewTaskRequest().getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {
            response.setStatus(200);
        } else {
            response.setStatus(404);
        }

        if (response.getStatus() == 200) {
            try {
                bpmsClientService.reviewTask(bpmsReqItemSentLetterDto.getReviewTaskRequest());
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
    public List<BPMSReqItemProcessHistoryDto> getProcessInstanceHistoryById(String processInstanceId) {
        ProcessInstanceHistory processInstanceHistory = bpmsClientService.getProcessInstanceHistoryById(processInstanceId);
        return requestItemBeanMapper.toBPMSReqItemProcessHistoryDtoList(processInstanceHistory.getTaskHistoryDetailList());
    }

    @Override
    public BaseResponse getPlanningChiefNationalCode() {

        BaseResponse response = new BaseResponse();
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByComplexIdAndObjectType("HEAD_OF_PLANNING");
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
    public boolean getPlanningChiefNationalCodeWithCheckDepartment() {
        return operationalRoleService.getOperationalRolesByByComplexIdAndObjectTypeWithCheckDepartment("HEAD_OF_PLANNING");
    }

    @Override
    public BaseResponse getRunChiefNationalCode() {

        BaseResponse response = new BaseResponse();
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByComplexIdAndObjectType("CHIEF_EXECUTIVE_OFFICER");
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
    public List<String> getPlanningExpertsAssigneeList(String post) {

        List<String> assigneeList = new ArrayList<>();
        Optional<TrainingPost> optionalTrainingPost = trainingPostService.isTrainingPostExist(post);
        List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByPostIdsAndComplexIdAndObjectType(optionalTrainingPost.get().getId(), "MASTER_OF_PLANNING");
        List<Long> operationalRoleIds = operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList());
        Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoleIds);
        for (Long userId : userIds) {
            assigneeList.add(synonymOAUserService.getNationalCodeByUserId(userId));
        }
        return assigneeList;
    }

    @Override
    public List<RequestItemCoursesDetailDTO.CourseCategoryInfo> getSupervisorAssigneeList(List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos) {

        String complexTitle;
        Long complexId;
        Long departmentId = personnelService.getDepartmentIdByNationalCode(SecurityUtil.getNationalCode());
        if (departmentId != null) {
            complexTitle = departmentService.getComplexTitleById(departmentId);
            if (complexTitle == null) {
                complexTitle = "مدیر مجتمع مس سرچشمه";
            }
        } else {
            complexTitle = "مدیر مجتمع مس سرچشمه";
        }
        complexId = departmentService.getComplexIdByComplexTitle(complexTitle);

        courseCategoryInfos.forEach(item -> {
            List<String> supervisorAssigneeList = new ArrayList<>();
            List<Long> operationalRoleIds = operationalRoleService.getAllUserIdsByComplexAndCategoryAndSubCategory(complexId, "EXECUTIVE_SUPERVISOR", item.getCategoryId(), item.getSubCategoryId());
            Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoleIds);
            for (Long userId : userIds) {
                supervisorAssigneeList.add(synonymOAUserService.getNationalCodeByUserId(userId));
            }
            item.setSupervisorAssigneeList(supervisorAssigneeList);
        });
        return courseCategoryInfos;
    }

    @Override
    public List<RequestItemCoursesDetailDTO.CourseCategoryInfo> getExpertsAssigneeList(List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos) {

        String complexTitle;
        Long complexId;
        Long departmentId = personnelService.getDepartmentIdByNationalCode(SecurityUtil.getNationalCode());
        if (departmentId != null) {
            complexTitle = departmentService.getComplexTitleById(departmentId);
            if (complexTitle == null) {
                complexTitle = "مدیر مجتمع مس سرچشمه";
            }
        } else {
            complexTitle = "مدیر مجتمع مس سرچشمه";
        }
        complexId = departmentService.getComplexIdByComplexTitle(complexTitle);

        courseCategoryInfos.forEach(item -> {
            List<String> expertsAssigneeList = new ArrayList<>();
            List<Long> operationalRoleIds = operationalRoleService.getAllUserIdsByComplexAndCategoryAndSubCategory(complexId, "EXECUTION_EXPERT", item.getCategoryId(), item.getSubCategoryId());
            Set<Long> userIds = operationalRoleService.getAllUserIdsByIds(operationalRoleIds);
            for (Long userId : userIds) {
                expertsAssigneeList.add(synonymOAUserService.getNationalCodeByUserId(userId));
            }
            item.setExpertsAssigneeList(expertsAssigneeList);
        });
        return courseCategoryInfos;
    }

    @Override
    public void updateProcessStatus(Long requestItemId, String processStatus) {

        Optional<RequestItem> optionalRequestItem = requestItemDAO.findById(requestItemId);
        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            requestItem.setProcessStatusId(parameterValueService.getId(processStatus));
            requestItemDAO.saveAndFlush(requestItem);
        }
    }

    @Override
    public List<BPMSReqItemCoursesDetailDto> getNotPassedCourses(String processInstanceId) {

        SynonymPersonnel synonymPersonnel;
        SynonymPersonnel synonymPersonnelByNationalCode = null;
        SynonymPersonnel synonymPersonnelByPersonnelNo2 = null;
        List<BPMSReqItemCoursesDetailDto> courseNotPassedList = new ArrayList<>();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(processInstanceId);

        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            if (requestItem.getNationalCode() != null)
                synonymPersonnelByNationalCode = synonymPersonnelService.getByNationalCode(requestItem.getNationalCode());
            if (requestItem.getPersonnelNo2() != null)
                synonymPersonnelByPersonnelNo2 = synonymPersonnelService.getByPersonnelNo2(requestItem.getPersonnelNo2());

            if (synonymPersonnelByNationalCode != null)
                synonymPersonnel = synonymPersonnelByNationalCode;
            else
                synonymPersonnel = synonymPersonnelByPersonnelNo2;

            List<NeedsAssessmentDTO.CourseDetail> needsAssessmentDTOList = needsAssessmentService.findCoursesByTrainingPostCode(requestItem.getPost());
            List<BPMSReqItemCoursesDetailDto> courseList = modelMapper.map(needsAssessmentDTOList, new TypeToken<List<BPMSReqItemCoursesDetailDto>>() {
            }.getType());

            List<String> list = classService.findAllPersonnelClass(synonymPersonnel.getNationalCode(), synonymPersonnel.getPersonnelNo()).stream()
                    .filter(course -> course.getScoreStateId() == 400 || course.getScoreStateId() == 401).map(TclassDTO.PersonnelClassInfo::getCourseCode).collect(Collectors.toList());
            for (BPMSReqItemCoursesDetailDto course : courseList) {
                if (!list.contains(course.getCourseCode()))
                    courseNotPassedList.add(course);
            }
        }
        return courseNotPassedList.stream().filter(item -> item.getPriority().contains("ضروری") || item.getPriority().contains("انتصاب")).collect(Collectors.toList());
    }

    private int getWrongCount(List<RequestItemWithDiff> list) {
        int wrongCount = 0;
        for (RequestItemWithDiff data : list) {
            if (!(data.isPersonnelNumberCorrect() && data.isLastNameCorrect() && data.isNameCorrect() && data.isCurrentPostTitleCorrect() && data.isAffairsCorrect())) {
                wrongCount++;
            }
        }
        return wrongCount;
    }

    private RequestItemWithDiff getRequestDiff(RequestItem requestItem) {

        SynonymPersonnel synonymPersonnel = null;
        SynonymPersonnel synonymPersonnelByNationalCode = null;
        SynonymPersonnel synonymPersonnelByPersonnelNo2 = null;
        RequestItemWithDiff requestItemWithDiff = new RequestItemWithDiff();

        if (requestItem.getNationalCode() != null)
            synonymPersonnelByNationalCode = synonymPersonnelService.getByNationalCode(requestItem.getNationalCode());
        if (requestItem.getPersonnelNo2() != null)
            synonymPersonnelByPersonnelNo2 = synonymPersonnelService.getByPersonnelNo2(requestItem.getPersonnelNo2());

        if (synonymPersonnelByNationalCode != null) {
            synonymPersonnel = synonymPersonnelByNationalCode;
            requestItemWithDiff.setNationalCodeCorrect(true);
            requestItemWithDiff.setNationalCode(requestItem.getNationalCode());
            if (requestItem.getPersonnelNo2() != null && synonymPersonnel.getPersonnelNo2() != null && synonymPersonnel.getPersonnelNo2().trim().equals(requestItem.getPersonnelNo2().trim())) {
                requestItemWithDiff.setPersonnelNo2Correct(true);
                requestItemWithDiff.setPersonnelNo2(requestItem.getPersonnelNo2());
            } else {
                requestItemWithDiff.setPersonnelNo2Correct(false);
                requestItemWithDiff.setPersonnelNo2(requestItem.getPersonnelNo2());
                requestItemWithDiff.setCorrectPersonnelNo2(synonymPersonnel.getPersonnelNo2());
            }
        } else if (synonymPersonnelByPersonnelNo2 != null) {
            synonymPersonnel = synonymPersonnelByPersonnelNo2;
            requestItemWithDiff.setPersonnelNo2Correct(true);
            requestItemWithDiff.setPersonnelNo2(synonymPersonnel.getPersonnelNo2());
            requestItemWithDiff.setNationalCodeCorrect(false);
            requestItemWithDiff.setNationalCode(requestItem.getNationalCode());
            requestItemWithDiff.setCorrectNationalCode(synonymPersonnel.getNationalCode());
        }

        if (synonymPersonnel != null) {

            requestItemWithDiff.setPersonnelNumber(requestItem.getPersonnelNumber());
            requestItemWithDiff.setName(requestItem.getName());
            requestItemWithDiff.setLastName(requestItem.getLastName());
            requestItemWithDiff.setEducationLevel(requestItem.getEducationLevel());
            requestItemWithDiff.setEducationMajor(requestItem.getEducationMajor());
            requestItemWithDiff.setCurrentPostTitle(requestItem.getCurrentPostTitle());
            requestItemWithDiff.setPost(requestItem.getPost());
            requestItemWithDiff.setPostTitle(requestItem.getPostTitle());
            requestItemWithDiff.setAffairs(requestItem.getAffairs());
            Optional<TrainingPost> optionalTrainingPost = trainingPostService.isTrainingPostExist(requestItem.getPost());

            if (!optionalTrainingPost.isPresent()) {
                requestItemWithDiff.setOperationalRoleIds(null);
                requestItem.setOperationalRoleIds(null);
            } else {
                List<OperationalRole> operationalRoles = operationalRoleService.getOperationalRolesByByPostIdsAndComplexIdAndObjectType(optionalTrainingPost.get().getId(), "MASTER_OF_PLANNING");
                List<Long> operationalRoleIds = operationalRoles.stream().map(OperationalRole::getId).collect(Collectors.toList());
                requestItemWithDiff.setOperationalRoleIds(operationalRoleIds);
                requestItemWithDiff.setOperationalRoleTitles(operationalRoles.stream().map(OperationalRole::getTitle).collect(Collectors.toList()));
                requestItemWithDiff.setOperationalRoleUsers(operationalRoleIds.size() != 0 ? operationalRoleService.getOperationalRoleUserIdsByIds(operationalRoleIds) : new ArrayList<>());
                requestItem.setOperationalRoleIds(operationalRoleIds);
            }

            if (synonymPersonnel.getPersonnelNo() != null && requestItem.getPersonnelNumber() != null && synonymPersonnel.getPersonnelNo().trim().equals(requestItem.getPersonnelNumber().trim())) {
                requestItemWithDiff.setPersonnelNumberCorrect(true);
            } else {
                requestItemWithDiff.setCorrectPersonnelNumber(synonymPersonnel.getPersonnelNo());
                requestItemWithDiff.setPersonnelNumberCorrect(false);
            }
            if (synonymPersonnel.getFirstName() != null && requestItem.getName() != null && synonymPersonnel.getFirstName().trim().equals(requestItem.getName().trim())) {
                requestItemWithDiff.setNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectName(synonymPersonnel.getFirstName());
                requestItemWithDiff.setNameCorrect(false);
            }
            if (synonymPersonnel.getLastName() != null && requestItem.getLastName() != null && synonymPersonnel.getLastName().trim().equals(requestItem.getLastName().trim())) {
                requestItemWithDiff.setLastNameCorrect(true);
            } else {
                requestItemWithDiff.setCorrectLastName(synonymPersonnel.getLastName());
                requestItemWithDiff.setLastNameCorrect(false);
            }
            if (synonymPersonnel.getPostTitle() != null && requestItem.getCurrentPostTitle() != null && synonymPersonnel.getPostTitle().trim().equals(requestItem.getCurrentPostTitle().trim())) {
                requestItemWithDiff.setCurrentPostTitleCorrect(true);
            } else {
                requestItemWithDiff.setCorrectCurrentPostTitle(synonymPersonnel.getPostTitle());
                requestItemWithDiff.setCurrentPostTitleCorrect(false);
            }
            if (synonymPersonnel.getCcpAffairs() != null && requestItem.getAffairs() != null && synonymPersonnel.getCcpAffairs().trim().equals(requestItem.getAffairs().trim())) {
                requestItemWithDiff.setAffairsCorrect(true);
            } else {
                requestItemWithDiff.setCorrectAffairs(synonymPersonnel.getCcpAffairs());
                requestItemWithDiff.setAffairsCorrect(false);
            }

            RequestItem savedItem = create(requestItem, requestItem.getCompetenceReqId());
            requestItemWithDiff.setId(savedItem.getId());
            requestItemWithDiff.setCompetenceReqId(savedItem.getCompetenceReqId());
        } else {
            requestItemWithDiff.setNationalCodeCorrect(false);
            requestItemWithDiff.setPersonnelNo2Correct(false);
        }
        return requestItemWithDiff;
    }

    private RequestItemState getRequestState(String personnelNumber, boolean isPostExist,String post, String nationalCode) {
        if (isPostExist) {
            List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = iNeedsAssessmentReportsService.getCourseListForBpms(post, "Post", nationalCode, personnelNumber);
            if (needsAssessmentReportList.isEmpty()) {
                return RequestItemState.Unimpeded;
            } else {
                Long notPassedCodeId = parameterValueService.getId("false");
                boolean isNotPassedCodeIdExist = needsAssessmentReportList.stream().anyMatch(o -> o.getSkill().getCourse().getScoresState().equals(notPassedCodeId));
                if (isNotPassedCodeIdExist)
                    return RequestItemState.Impeded;
                else
                    return RequestItemState.Unimpeded;
            }
        } else {
            return RequestItemState.PostMissed;
        }
    }
}
