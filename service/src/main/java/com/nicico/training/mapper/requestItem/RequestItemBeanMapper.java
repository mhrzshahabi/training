package com.nicico.training.mapper.requestItem;

import com.nicico.bpmsclient.model.flowable.task.TaskHistory;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.RequestItemProcessDetail;
import com.nicico.training.repository.PersonnelDAO;
import dto.bpms.BPMSReqItemProcessHistoryDto;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;
import response.requestItem.RequestItemWithDiff;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class RequestItemBeanMapper {

    @Autowired
    protected PersonnelDAO personnelDAO;
    @Autowired
    protected ISynonymOAUserService synonymOAUserService;
    @Autowired
    protected IParameterValueService parameterValueService;
    @Autowired
    protected IOperationalRoleService operationalRoleService;
    @Autowired
    protected ISynonymPersonnelService synonymPersonnelService;
    @Autowired
    protected ICompetenceRequestService competenceRequestService;
    @Autowired
    protected IRequestItemProcessDetailService requestItemProcessDetailService;


    public abstract RequestItem toRequestItem (RequestItemDTO.Create request);

    @Mappings({
            @Mapping(source = "processStatusId", target = "processStatusTitle", qualifiedByName = "processStatusIdToTitle"),
            @Mapping(source = "id", target = "planningChiefOpinion", qualifiedByName = "idToPlanningChiefOpinion"),
            @Mapping(source = "operationalRoleIds", target = "operationalRoleTitles", qualifiedByName = "operationalRoleIdsToTitles"),
            @Mapping(source = "operationalRoleIds", target = "operationalRoleUsers", qualifiedByName = "operationalRoleIdsToUserIds")
    })
    public abstract RequestItemDTO.Info toRequestItemDto(RequestItem requestItem);

    @Mappings({
            @Mapping(source = "competenceReqId", target = "requestNo", qualifiedByName = "toRequestNo"),
            @Mapping(source = "competenceReqId", target = "requestDate", qualifiedByName = "toRequestDate"),
            @Mapping(source = "competenceReqId", target = "applicant", qualifiedByName = "toApplicant"),
            @Mapping(source = "competenceReqId", target = "requestType", qualifiedByName = "toRequestType"),
            @Mapping(source = "competenceReqId", target = "letterNumber", qualifiedByName = "toLetterNumber")
    })
    public abstract RequestItemDTO.ReportInfo toRequestItemReportInfoDto(RequestItem requestItem);
    public abstract List<RequestItemDTO.ReportInfo> toRequestItemReportInfoDtoList(List<RequestItem> requestItemList);

    @Mappings({
            @Mapping(source = "assignee", target = "assignee", qualifiedByName = "toAssigneeName")
    })
    public abstract BPMSReqItemProcessHistoryDto toBPMSReqItemProcessHistoryDto(TaskHistory taskHistory);
    public abstract List<BPMSReqItemProcessHistoryDto> toBPMSReqItemProcessHistoryDtoList(List<TaskHistory> taskHistoryList);

    @Mapping(source = "id", target = "planningChiefOpinion", qualifiedByName = "idToPlanningChiefOpinion")
    public abstract RequestItemDTO.ExcelOutputInfo toRequestItemExcelOutputDto(RequestItem requestItem);

    abstract RequestItemDTO.Info toRequestItemDiffDto(RequestItemWithDiff requestItemWithDiff);

    @Named("idToPlanningChiefOpinion")
    protected String idToPlanningChiefOpinion(Long id) {

        RequestItemProcessDetail requestItemProcessDetail;
        requestItemProcessDetail = requestItemProcessDetailService.findFirstByRequestItemIdAndRoleName(id, "planningChief");
        if (requestItemProcessDetail == null) {
            String chiefNationalCode = getOldPlanningChiefNationalCode();
            requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(id, chiefNationalCode);
        }

        if (requestItemProcessDetail != null)
            return parameterValueService.getInfo(requestItemProcessDetail.getExpertsOpinionId()).getTitle();
        else return "";
    }

    private String getOldPlanningChiefNationalCode() {
        String complexTitle = personnelDAO.getComplexTitleByNationalCode(SecurityUtil.getNationalCode());
//        String mainConfirmBoss = "ahmadi_z";
        String mainConfirmBoss = "3621296476";
        if ((complexTitle != null) && (complexTitle.equals("شهر بابک"))) {
//            mainConfirmBoss = "pourfathian_a";
            mainConfirmBoss = "3149097517";
//            mainConfirmBoss = "hajizadeh_mh";
        } else if ((complexTitle != null) && (complexTitle.equals("سونگون"))) {
            mainConfirmBoss = "6049618348";
        }
        return mainConfirmBoss;
    }

    @Named("operationalRoleIdsToTitles")
    protected List<String> operationalRoleIdsToTitles(List<Long> operationalRoleIds) {
        if (operationalRoleIds.size() != 0)
            return operationalRoleService.getOperationalRoleTitlesByIds(operationalRoleIds);
        else return new ArrayList<>();
    }

    @Named("operationalRoleIdsToUserIds")
    protected List<Long> operationalRoleIdsToUserIds(List<Long> operationalRoleIds) {
        if (operationalRoleIds.size() != 0)
            return operationalRoleService.getOperationalRoleUserIdsByIds(operationalRoleIds);
        else return new ArrayList<>();
    }

    @Named("processStatusIdToTitle")
    protected String processStatusIdToTitle(Long processStatusId) {
        if (processStatusId != null)
            return parameterValueService.getInfo(processStatusId).getTitle();
        else return "";
    }

    @Named("toRequestNo")
    protected Long toRequestNo(Long competenceReqId) {
        if (competenceReqId != null)
            return competenceRequestService.get(competenceReqId).getId();
        else return null;
    }

    @Named("toRequestDate")
    protected String toRequestDate(Long competenceReqId) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if (competenceReqId != null) {
            Date requestDate = competenceRequestService.get(competenceReqId).getRequestDate();
            if (requestDate != null)
                return DateUtil.convertMiToKh(formatter.format(requestDate));
            else return "";
        } else return "";
    }

    @Named("toApplicant")
    protected String toApplicant(Long competenceReqId) {
        if (competenceReqId != null)
            return competenceRequestService.get(competenceReqId).getApplicant();
        else return null;
    }

    @Named("toRequestType")
    protected String toRequestType(Long competenceReqId) {
        if (competenceReqId != null)
            return competenceRequestService.get(competenceReqId).getRequestType().getTitleFa();
        else return null;
    }

    @Named("toLetterNumber")
    protected String toLetterNumber(Long competenceReqId) {
        if (competenceReqId != null)
            return competenceRequestService.get(competenceReqId).getLetterNumber();
        else return null;
    }

    @Named("toAssigneeName")
    protected String toAssigneeName(String assignee) {
        if (assignee != null)
            return synonymOAUserService.getFullNameByNationalCode(assignee);
        else return null;
    }

    public abstract List<RequestItemDTO.Info> toRequestItemDTODtos(List<RequestItem> requestItemList);
    public abstract List<RequestItem> toRequestItemDtos(List<RequestItemDTO.Create> requestItemList);
}
