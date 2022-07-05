package com.nicico.training.mapper.requestItem;

import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.RequestItemProcessDetail;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class RequestItemBeanMapper {

    @Autowired
    protected IParameterValueService parameterValueService;
    @Autowired
    protected IOperationalRoleService operationalRoleService;
    @Autowired
    protected ISynonymPersonnelService synonymPersonnelService;
    @Autowired
    protected IRequestItemService requestItemService;
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

    @Mapping(source = "id", target = "planningChiefOpinion", qualifiedByName = "idToPlanningChiefOpinion")
    public abstract RequestItemDTO.ExcelOutputInfo toRequestItemExcelOutputDto(RequestItem requestItem);

    abstract RequestItemDTO.Info toRequestItemDiffDto(RequestItemWithDiff requestItemWithDiff);

    @Named("idToPlanningChiefOpinion")
    protected String idToPlanningChiefOpinion(Long id) {
        String chiefNationalCode = requestItemService.getPlanningChiefNationalCode();
        RequestItemProcessDetail requestItemProcessDetail = requestItemProcessDetailService.findByRequestItemIdAndExpertNationalCode(id, chiefNationalCode);
        if (requestItemProcessDetail != null)
            return parameterValueService.getInfo(requestItemProcessDetail.getExpertsOpinionId()).getTitle();
        else return "";
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

    public abstract List<RequestItemDTO.Info> toRequestItemDTODtos(List<RequestItem> requestItemList);
    public abstract List<RequestItem> toRequestItemDtos(List<RequestItemDTO.Create> requestItemList);
}
