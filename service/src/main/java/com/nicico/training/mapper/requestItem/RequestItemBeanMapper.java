package com.nicico.training.mapper.requestItem;


import com.nicico.training.dto.RequestItemDTO;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.enums.RequestItemState;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Qualifier;
import java.util.Arrays;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface RequestItemBeanMapper {

    @Mapping(source = "state", target = "state", qualifiedByName = "strToState")
    RequestItem toRequestItem (RequestItemDTO.Create request);

    @Mapping(source = "state", target = "state", qualifiedByName = "StateToStr")
    RequestItemDTO.Info toRequestItemDto(RequestItem requestItem);


    @Qualifier("StateToStr")
    default String StateToStr(RequestItemState state) {
        if (state!=null)
        return state.getTitleFa();
        else return "";
    }
//
    @Qualifier("strToState")
    default RequestItemState strToState(String title) {
        return Arrays.stream(RequestItemState.values())
                .filter(e -> e.getTitleFa().equals(title))
                .findFirst()
                .orElse(null);
    }

    List<RequestItemDTO.Info> toRequestItemDTODtos(List<RequestItem> requestItemList);
    List<RequestItem> toRequestItemDtos(List<RequestItemDTO.Create> requestItemList);
}
