package com.nicico.training.mapper.FeeItem;

import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.model.FeeItem;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface FeeItemMapper {
    FeeItem toEntity(FeeItemDTO.Create create);

    FeeItemDTO.Info toInfo(FeeItem feeItem);

    List<FeeItemDTO.Info> toInfos(List<FeeItem> feeItems);

    FeeItem update(FeeItemDTO.Create update, @MappingTarget FeeItem feeItem);
}
