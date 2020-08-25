package com.nicico.training.mapper.needsassessment;

import com.nicico.training.model.NeedsAssessmentTemp;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;
import request.needsassessment.NeedsAssessmentUpdateRequest;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface NeedsAssessmentBeanMapper {

    NeedsAssessmentTemp toUpdatedNeedsTemp(NeedsAssessmentUpdateRequest request, @MappingTarget NeedsAssessmentTemp temp);
}
