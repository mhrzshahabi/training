package com.nicico.training.mapper.requestItem;

import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.IParameterValueService;
import com.nicico.training.iservice.ISynonymPersonnelService;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.enums.RequestItemState;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;
import response.requestItem.RequestItemWithDiff;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class RequestItemBeanMapper {

    @Autowired
    protected IParameterValueService parameterValueService;
    @Autowired
    protected IOperationalRoleService operationalRoleService;
    @Autowired
    protected ISynonymPersonnelService synonymPersonnelService;


    @Mapping(source = "state", target = "state", qualifiedByName = "strToState")
    public abstract RequestItem toRequestItem (RequestItemDTO.Create request);

    @Mappings({
            @Mapping(source = "state", target = "state", qualifiedByName = "StateToStr"),
            @Mapping(source = "processStatusId", target = "processStatusTitle", qualifiedByName = "processStatusIdToTitle"),
            @Mapping(source = "operationalRoleIds", target = "operationalRoleTitles", qualifiedByName = "operationalRoleIdsToTitles")
    })
    public abstract RequestItemDTO.Info toRequestItemDto(RequestItem requestItem);

    @Mapping(source = "state", target = "state", qualifiedByName = "StateToStr")
    abstract RequestItemDTO.Info toRequestItemDiffDto(RequestItemWithDiff requestItemWithDiff);

    @Named("operationalRoleIdsToTitles")
    protected List<String> operationalRoleIdsToTitles(List<Long> operationalRoleIds) {
        if (operationalRoleIds.size() != 0)
            return operationalRoleService.getOperationalRoleTitlesByIds(operationalRoleIds);
        else return new ArrayList<>();
    }

    @Named("processStatusIdToTitle")
    protected String processStatusIdToTitle(Long processStatusId) {
        if (processStatusId != null)
            return parameterValueService.getInfo(processStatusId).getTitle();
        else return "";
    }

    @Named("StateToStr")
    protected String StateToStr(RequestItemState state) {
        if (state!=null)
        return state.getTitleFa();
        else return "";
    }

    @Named("strToState")
    protected RequestItemState strToState(String title) {
        return Arrays.stream(RequestItemState.values())
                .filter(e -> e.getTitleFa().equals(title))
                .findFirst()
                .orElse(null);
    }

    abstract List<RequestItemDTO.Info> toRequestItemDiffDTODtos(List<RequestItemWithDiff> requestItemWithDiffList);
    public abstract List<RequestItemDTO.Info> toRequestItemDTODtos(List<RequestItem> requestItemList);
    public abstract List<RequestItem> toRequestItemDtos(List<RequestItemDTO.Create> requestItemList);
}
