package com.nicico.training.mapper.paymentDocMapper;

import com.nicico.training.dto.PaymentDocClassDTO;
import com.nicico.training.model.PaymentDocClass;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface PaymentDocClassMapper {


    @Mappings({
            @Mapping(target = "code", source = "classCode")
    })
    PaymentDocClassDTO.Info toDtoInfo(PaymentDocClass paymentDocClass);



}
