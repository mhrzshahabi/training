package com.nicico.training.iservice;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.bpmsclient.model.flowable.process.StartProcessWithDataDTO;
import com.nicico.bpmsclient.model.request.ReviewTaskRequest;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.model.RequestItem;
import dto.bpms.*;
import response.BaseResponse;
import response.requestItem.RequestItemDto;
import response.requestItem.RequestItemWithDiff;

import java.util.List;

public interface IRequestItemService {

    RequestItem create(RequestItem competenceRequest,Long id);

    RequestItemWithDiff update(RequestItem requestItem, Long id);

    RequestItem get(Long id);

    Long getIdByProcessInstanceId(String processInstanceId);

    void delete(Long id);

    List<RequestItem> getList();

    Integer getTotalCount();

    Integer getTotalStartedProcessCount();

    Integer getTotalCountForOneCompetenceReqId(Long id);

    List<RequestItem> search(SearchDTO.SearchRq request, Long id);

    List<RequestItem> search(SearchDTO.SearchRq request);

    RequestItemDto createList(List<RequestItem> requestItem);

    List<RequestItem> getListWithCompetenceRequest(Long id);

    List<RequestItemDTO.ExcelOutputInfo> getItemListWithCompetenceRequest(Long id);

    List<Long> getAllRequestItemIdsWithCompetenceId(Long competenceId);

    RequestItemWithDiff validData(Long id);

    void updateOperationalRoles(Long id);

    void updateStartedRequestItemProcess(Long id, String processInstanceId);

    BaseResponse getDefinitionKey(String definitionKey, String TenantId,int page,int size);

    StartProcessWithDataDTO getRequestItemStartProcessDto(Long requestItemId, BpmsStartParamsDto params, String tenantId);

    ProcessInstance startRequestItemProcessWithData(StartProcessWithDataDTO startProcessDto);

    RequestItemDTO.Info getRequestItemProcessDetailByProcessInstanceId(String processInstanceId);

    void cancelRequestItemProcess(ReviewTaskRequest reviewTaskRequest, String reason);

    BaseResponse cancelParallelRequestItemProcess(ReviewTaskRequest reviewTaskRequest, String reason);

    BaseResponse reAssignRequestItemProcess(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reAssignParallelRequestItemProcess(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTask(ReviewTaskRequest reviewTaskRequestDto);

    BaseResponse reviewParallelRequestItemTask(BPMSReqItemCoursesDto bpmsReqItemCoursesDto, String userNationalCode);

    BaseResponse reviewRequestItemTaskToDetermineStatus(ReviewTaskRequest reviewTaskRequest, Long chiefOpinionId, String userNationalCode);

    BaseResponse reviewRequestItemTaskByRunChief(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTaskByRunChiefNeedToPass(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTaskByRunSupervisor(ReviewTaskRequest reviewTaskRequest, String courseCode);

    BaseResponse reviewRequestItemTaskByRunExperts(ReviewTaskRequest reviewTaskRequest, String courseCode);

    void autoReviewRequestItemTaskByRunExperts(List<RequestItemCoursesDetailDTO.CompleteTaskDto> completeTaskDtoList);

    BaseResponse reviewRequestItemTaskByRunSupervisorForApproval(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTaskByRunChiefForApproval(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTaskByPlanningChiefForApproval(ReviewTaskRequest reviewTaskRequest);

    BaseResponse reviewRequestItemTaskByAppointmentExpert(BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto);

    BaseResponse reviewRequestItemTaskByAppointmentExpertNoLetter(BPMSReqItemSentLetterDto bpmsReqItemSentLetterDto);

    List<BPMSReqItemProcessHistoryDto> getProcessInstanceHistoryById(String processInstanceId);

    BaseResponse getPlanningChiefNationalCode();

    BaseResponse getRunChiefNationalCode();

    List<String> getPlanningExpertsAssigneeList(String post);

    List<RequestItemCoursesDetailDTO.CourseCategoryInfo> getSupervisorAssigneeList(List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos);

    List<RequestItemCoursesDetailDTO.CourseCategoryInfo> getExpertsAssigneeList(List<RequestItemCoursesDetailDTO.CourseCategoryInfo> courseCategoryInfos);

    void updateProcessStatus(Long requestItemId, String processStatus);

    List<BPMSReqItemCoursesDetailDto> getNotPassedCourses(String processInstanceId);
    boolean getPlanningChiefNationalCodeWithCheckDepartment();
}
