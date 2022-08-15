package com.nicico.training.mapper.teacher;

import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.TeacherExperienceInfo;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TeacherExperienceMapper {

    @Mappings({
            @Mapping(source = "teacherRank.id", target = "teacherRank"),
            @Mapping(source = "teacherRank.title", target = "teacherRankTitle"),
    })
    TeacherExperienceInfoDTO.ExcelInfo mapToDTO(TeacherExperienceInfo teacherExperienceInfo);
}
