package com.nicico.training.mapper.ClassFee;

import com.nicico.training.dto.ClassFeeDTO;
import com.nicico.training.model.ClassFee;
import com.nicico.training.model.enums.ClassFeeStatus;
import org.mapstruct.*;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface ClassFeeMapper {

    ClassFee toEntity(ClassFeeDTO.Create create);

    @Mapping(target = "classFeeStatus", qualifiedByName = "enumToInt")
    ClassFeeDTO.Info toInfo(ClassFee classFee);

    ClassFeeDTO.Info toInfo(ClassFeeDTO.Create request);

    ClassFee update(ClassFeeDTO.Create update, @MappingTarget ClassFee classFee);

    @Named("enumToInt")
    default Integer enumToInt(ClassFeeStatus classFeeStatus) {
        for (ClassFeeStatus status : ClassFeeStatus.values()) {
            if (status.getKey().equals(classFeeStatus.getKey())) {
                return status.getKey();
            }
        }
        return null;
    }
}
