package com.nicico.training.mapper.paymentDocMapper;

import com.nicico.training.dto.PaymentDTO;
import com.nicico.training.model.PaymentDoc;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface PaymentDocMapper {


    @Mappings({
            @Mapping(target = "agreementId", source = "agreement.id"),
            @Mapping(target = "agreement", source = "agreement"),
            @Mapping(target = "paymentDocStatus", source = "paymentDocStatus.titleFa")
    })
      PaymentDTO.Info toDtoInfo(PaymentDoc paymentDoc);

      //    List<EducationalDecisionDTO.Info> toDtosInfos(List<EducationalDecision> educationalDecisions);

//    EducationalDecision toModel(EducationalDecisionDTO educationalDecisionDto);
//    List<EducationalDecision> toModels(List<EducationalDecisionDTO> educationalDecisionDtos);

}
