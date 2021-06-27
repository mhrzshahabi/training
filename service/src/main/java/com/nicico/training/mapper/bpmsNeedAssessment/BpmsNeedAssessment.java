package com.nicico.training.mapper.bpmsNeedAssessment;


import com.nicico.training.model.NeedsAssessment;
import dto.BpmsNeedAssessmentDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring" )
public interface BpmsNeedAssessment {

    NeedsAssessment toNeedAssessment(BpmsNeedAssessmentDto bpmsNeedAssessmentDto);



    BpmsNeedAssessmentDto ToBpmsNeedAssessmentDto(NeedsAssessment needsAssessment);


    List<NeedsAssessment> toNeedAssessments(List<BpmsNeedAssessmentDto> bpmsNeedAssessmentDtos);



    List<BpmsNeedAssessmentDto> ToBpmsNeedAssessmentDtos(List<NeedsAssessment> needsAssessments);


}
