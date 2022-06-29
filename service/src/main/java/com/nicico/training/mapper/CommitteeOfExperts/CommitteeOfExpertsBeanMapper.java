package com.nicico.training.mapper.CommitteeOfExperts;

import com.nicico.training.dto.CommitteeOfExpertsDTO;
import com.nicico.training.model.CommitteeOfExperts;
import org.mapstruct.*;
import org.springframework.transaction.annotation.Transactional;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
@Transactional
public interface CommitteeOfExpertsBeanMapper {


    CommitteeOfExperts toModel(CommitteeOfExpertsDTO.Create req);

    CommitteeOfExpertsDTO toDto(CommitteeOfExperts committeeOfExperts);
}
