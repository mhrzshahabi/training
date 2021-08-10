package com.nicico.training.mapper.person;

import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.model.Teacher;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import response.teacher.dto.TeacherInCourseDto;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface PersonnelRegisterBeanMapper {
    PersonnelRegisteredDTO toPersonnelRegisteredDTO (PersonnelRegistered personnelRegistered);
    PersonnelRegistered toPersonnelRegistered (PersonnelRegisteredDTO personnelRegistered);

    default List<PersonnelRegisteredDTO> toPersonnelRegisteredDTOList(List<PersonnelRegistered> list){
        return list.stream().map(this::toPersonnelRegisteredDTO).collect(Collectors.toList());
    }

    default List<PersonnelRegistered> toPersonnelRegisteredList(List<PersonnelRegisteredDTO> list){
        return list.stream().map(this::toPersonnelRegistered).collect(Collectors.toList());
    }
}
