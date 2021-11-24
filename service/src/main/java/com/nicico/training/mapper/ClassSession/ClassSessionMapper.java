package com.nicico.training.mapper.ClassSession;

import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

import java.util.Set;

@Mapper(componentModel = "spring")
public interface ClassSessionMapper {



    ClassSessionDTO.AttendanceClearForm toClassSessionDTO(ClassSession classSession);

    Set<ClassSessionDTO.AttendanceClearForm> toClassSessionDTOS(Set<ClassSession> classSessions);
}
