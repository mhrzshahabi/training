package com.nicico.training.service;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.bpmsclient.service.BpmsClientService;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.dto.RequestItemProcessDetailDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.ICompetenceRequestService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.mapper.requestItem.RequestItemBeanMapper;
import com.nicico.training.mapper.requestItem.RequestItemCoursesDetailBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.RequestItemState;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.RequestItemDAO;
import dto.bpms.BPMSReqItemCoursesDetailDto;
import dto.bpms.BPMSReqItemCoursesDto;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
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
    private final PersonnelDAO personnelDAO;
    private final IBpmsService iBpmsService;
    private final RequestItemDAO requestItemDAO;
    private final IPersonnelService personnelService;
    private final BpmsClientService bpmsClientService;
    private final ITrainingPostService trainingPostService;
    private final ISynonymOAUserService synonymOAUserService;
    private final RequestItemBeanMapper requestItemBeanMapper;
    private final IParameterValueService parameterValueService;
    private final IOperationalRoleService operationalRoleService;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final ICompetenceRequestService competenceRequestService;
    private final INeedsAssessmentReportsService iNeedsAssessmentReportsService;
    private final IRequestItemProcessDetailService requestItemProcessDetailService;
    private final IRequestItemCoursesDetailService requestItemCoursesDetailService;
    private final RequestItemCoursesDetailBeanMapper requestItemCoursesDetailBeanMapper;

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

    @Override
    @Transactional
    public RequestItemDto createList(List<RequestItem> requestItems) {
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
    public StartProcessWithDataDTO getRequestItemStartProcessDto(Long requestItemId, BpmsStartParamsDto params, String tenantId) {
        Map<String, Object> map = new HashMap<>();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findById(requestItemId);
        if (optionalRequestItem.isPresent()) {
            map.put("assignTo", getPlanningChiefNationalCode());
            map.put("userId", SecurityUtil.getUserId());
            map.put("assignFrom", SecurityUtil.getNationalCode());
            map.put("tenantId", tenantId);
            map.put("title", params.getData().get("title").toString());
            map.put("createBy", SecurityUtil.getFullName());
            map.put("requestItemId", params.getData().get("requestItemId").toString());
            map.put("requestNo", params.getData().get("requestNo").toString());
            map.put("requestLetterNumber", params.getData().get("requestLetterNumber").toString());
            StartProcessWithDataDTO startProcessDto = new StartProcessWithDataDTO();
            startProcessDto.setProcessDefinitionKey(iBpmsService.getDefinitionKey(params.getData().get("processDefinitionKey").toString(), tenantId, 0, 10).getMessage());
            startProcessDto.setVariables(map);
            return startProcessDto;
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
    public void reAssignRequestItemProcess(ReviewTaskRequest reviewTaskRequest) {

        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());
        Map<String, Object> map = reviewTaskRequest.getVariables();

        map.put("assignTo", getPlanningChiefNationalCode());
        map.put("approved", true);

        if (optionalRequestItem.isPresent()) {
            RequestItem requestItem = optionalRequestItem.get();
            requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChief"));
            requestItemDAO.saveAndFlush(requestItem);
        }

        bpmsClientService.reviewTask(reviewTaskRequest);
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
                String processStatus = parameterValueService.getInfo(requestItem.getProcessStatusId()).getCode();
                if (processStatus.equals("waitingReviewByPlanningChief")) {
                    requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningExperts"));
                    requestItemDAO.saveAndFlush(requestItem);
                    response.setStatus(200);
                }
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
    public BaseResponse reviewParallelRequestItemTask(BPMSReqItemCoursesDto bpmsReqItemCoursesDto, Long expertOpinionId, String userNationalCode) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(bpmsReqItemCoursesDto.getReviewTaskRequest().getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), userNationalCode);
            if (requestItemProcessDetail == null) {
                RequestItemProcessDetailDTO.Create requestItemProcessDetailDTO = new RequestItemProcessDetailDTO.Create();
                requestItemProcessDetailDTO.setRequestItemId(requestItem.getId());
                requestItemProcessDetailDTO.setExpertsOpinionId(expertOpinionId);
                requestItemProcessDetailDTO.setExpertNationalCode(userNationalCode);
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
            Object object = bpmsReqItemCoursesDto.getReviewTaskRequest().getVariables().get("assigneeList");
            if (object != null) {
                List<String> assigneeList = (List<String>) object;
                if (assigneeList.size() == requestItemProcessDetailList.size()) {
                    requestItem.setProcessStatusId(parameterValueService.getId("waitingReviewByPlanningChiefToDetermineStatus"));
                    requestItemDAO.saveAndFlush(requestItem);
                }
                response.setStatus(200);
            } else {
                response.setStatus(404);
            }
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

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), userNationalCode);
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItem(requestItem.getId());


            if (requestItemProcessDetail == null) {
                RequestItemProcessDetailDTO.Create requestItemProcessDetailDTO = new RequestItemProcessDetailDTO.Create();
                requestItemProcessDetailDTO.setRequestItemId(requestItem.getId());
                requestItemProcessDetailDTO.setExpertsOpinionId(chiefOpinionId);
                requestItemProcessDetailDTO.setExpertNationalCode(userNationalCode);
                requestItemProcessDetail = requestItemProcessDetailService.create(requestItemProcessDetailDTO);
            }

            if (courses.size() != 0) {
                for (RequestItemCoursesDetailDTO.Info requestItemCoursesDetailDTO : courses) {
                    RequestItemCoursesDetailDTO.Create create = modelMapper.map(requestItemCoursesDetailDTO, RequestItemCoursesDetailDTO.Create.class);
                    create.setRequestItemProcessDetailId(requestItemProcessDetail.getId());
                    requestItemCoursesDetailService.create(create);
                }
            }

            Map<String, Object> variables = reviewTaskRequest.getVariables();
            String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
            // String mainRunChief = "ابراهیم نژاد";
            String mainRunChief = "0938091972";
            if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
                // mainRunChief = "hajizadeh_mh";
                mainRunChief = "3149622123";
            }

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
    public BaseResponse reviewRequestItemTaskByRunChief(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), getPlanningChiefNationalCode());
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getSupervisorAssigneeList(courseCategoryInfos);
            if (coursesAssigneeList.stream().anyMatch(item -> item.getSupervisorAssigneeList().size() == 0)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Collection<String> supervisorAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("supervisorAssigneeList", supervisorAssigneeList);
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
            response.setMessage("برای بعضی از دوره ها سرپرست اجرا تعریف نشده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    public BaseResponse reviewRequestItemTaskByRunSupervisor(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), getPlanningChiefNationalCode());
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getExpertsAssigneeList(courseCategoryInfos);
            if (coursesAssigneeList.stream().anyMatch(item -> item.getExpertsAssigneeList().size() == 0)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Collection<String> expertsAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getExpertsAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
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
            response.setMessage("برای بعضی از دوره ها کارشناس اجرا تعریف نشده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunExperts(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), getPlanningChiefNationalCode());
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItemProcessDetailId(requestItemProcessDetail.getId());
            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos = requestItemCoursesDetailBeanMapper.toCourseCategoryInfoDTOList(courses);

            List<RequestItemCoursesDetailDTO.CourseCategoryInfo> coursesAssigneeList = getSupervisorAssigneeList(courseCategoryInfos);
            if (coursesAssigneeList.stream().anyMatch(item -> item.getSupervisorAssigneeList().size() == 0)) {
                response.setStatus(HttpStatus.BAD_REQUEST.value());
            } else {
                Collection<String> supervisorAssigneeList = coursesAssigneeList.stream().map(RequestItemCoursesDetailDTO.CourseCategoryInfo::getSupervisorAssigneeList).flatMap(Collection::stream).collect(Collectors.toSet());
                Map<String, Object> map = reviewTaskRequest.getVariables();
                map.put("supervisorAssigneeList", supervisorAssigneeList);
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
            response.setMessage("برای بعضی از دوره ها سرپرست اجرا تعریف نشده است");
        } else {
            response.setStatus(406);
            response.setMessage("تغییر وضعیت درخواست انجام نشد");
        }
        return response;
    }

    @Override
    @Transactional
    public BaseResponse reviewRequestItemTaskByRunSupervisorForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
            // String mainRunChief = "ابراهیم نژاد";
            String mainRunChief = "0938091972";
            if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
                // mainRunChief = "hajizadeh_mh";
                mainRunChief = "3149622123";
            }
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignTo", mainRunChief);
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
    public BaseResponse reviewRequestItemTaskByRunChiefForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            Map<String, Object> map = reviewTaskRequest.getVariables();
            map.put("assignTo", getPlanningChiefNationalCode());
            requestItem.setProcessStatusId(parameterValueService.getId("waitingFinalApprovalByPlanningChief(AfterRun)"));
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
    public BaseResponse reviewRequestItemTaskByPlanningChiefForApproval(ReviewTaskRequest reviewTaskRequest) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequest.getProcessInstanceId());

        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), getPlanningChiefNationalCode());
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
    public BaseResponse reviewRequestItemTaskByAppointmentExpert(ReviewTaskRequest reviewTaskRequestDto, String letterNumberSent) {

        BaseResponse response = new BaseResponse();
        Optional<RequestItem> optionalRequestItem = requestItemDAO.findByProcessInstanceId(reviewTaskRequestDto.getProcessInstanceId());
        if (optionalRequestItem.isPresent()) {

            RequestItem requestItem = optionalRequestItem.get();
            RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(requestItem.getId(), getPlanningChiefNationalCode());
            List<RequestItemCoursesDetailDTO.Info> courses = requestItemCoursesDetailService.findAllByRequestItem(requestItem.getId());
            requestItem.setLetterNumberSent(letterNumberSent);
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
                bpmsClientService.reviewTask(reviewTaskRequestDto);
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
    public String getPlanningChiefNationalCode() {
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
//        String mainConfirmBoss = "ahmadi_z";
        String mainConfirmBoss = "3621296476";
        if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
//            mainConfirmBoss = "pourfathian_a";
            mainConfirmBoss = "3149622123";
//            mainConfirmBoss = "hajizadeh_mh";
        }
        return mainConfirmBoss;
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
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
        Long complexId;
        if (complexTitle != null) {
            if (complexTitle.contains("حوزه مدیرعامل"))
                complexId = 58910L;
            else if (complexTitle.contains("استان کرمان"))
                complexId = 24740L;
            else if (complexTitle.contains("آذربایجان"))
                complexId = 22190L;
            else if (complexTitle.contains("شهربابک"))
                complexId = 66470L;
            else if (complexTitle.contains("سرچشمه"))
                complexId = 85930L;
            else
                complexId = 38060L; // صندوق بازنشستگی
        } else
            complexId = 85930L;

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
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
        Long complexId;
        if (complexTitle != null) {
            if (complexTitle.contains("حوزه مدیرعامل"))
                complexId = 58910L;
            else if (complexTitle.contains("استان کرمان"))
                complexId = 24740L;
            else if (complexTitle.contains("آذربایجان"))
                complexId = 22190L;
            else if (complexTitle.contains("شهربابک"))
                complexId = 66470L;
            else if (complexTitle.contains("سرچشمه"))
                complexId = 85930L;
            else
                complexId = 38060L; // صندوق بازنشستگی
        } else
            complexId = 85930L;

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
        RequestItemWithDiff requestItemWithDiff = new RequestItemWithDiff();

        SynonymPersonnel synonymPersonnelByNationalCode = synonymPersonnelService.getByNationalCode(requestItem.getNationalCode());
        SynonymPersonnel synonymPersonnelByPersonnelNo2 = synonymPersonnelService.getByPersonnelNo2(requestItem.getPersonnelNo2());

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
