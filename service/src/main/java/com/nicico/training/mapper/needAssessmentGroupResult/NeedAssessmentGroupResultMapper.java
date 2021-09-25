package com.nicico.training.mapper.needAssessmentGroupResult;


import com.nicico.training.model.NeedAssessmentGroupResult;
import com.nicico.training.utility.persianDate.PersianDate;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import request.needsassessment.NeedAssessmentGroupJobPromotionResponseDto;

import java.sql.Timestamp;
import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface NeedAssessmentGroupResultMapper {

    List<NeedAssessmentGroupJobPromotionResponseDto.Info> toResultDtoList(List<NeedAssessmentGroupResult> needAssessmentGroupResults);


    @Mapping(source = "createDate", target = "createDate", qualifiedByName = "toPersianCalendar")
    NeedAssessmentGroupJobPromotionResponseDto.Info toResultDto(NeedAssessmentGroupResult needAssessmentGroupResult);

    @Named("toPersianCalendar")
    default String toPersianCalendar(Timestamp createDate) {
        String persianDate = PersianDate.of(createDate);
        return persianDate;
    }
}
