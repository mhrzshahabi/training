package com.nicico.training.mapper.student;

import com.nicico.training.dto.StudentDTO;
import com.nicico.training.model.FamilyPersonnel;
import com.nicico.training.model.Student;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface StudentMapper {

    @Mappings({
            @Mapping(target = "firstName",source = "familyFirstName"),
            @Mapping(target = "lastName",source = "familyLastName"),
            @Mapping(target = "fatherName",source = "familyFatherName"),
            @Mapping(target = "nationalCode",source = "familyNationalCode")
    })
    Student  toStudent(FamilyPersonnel familyPersonnel);

    List<StudentDTO.LmsInfo> toStudentLmsInfoDto(List<Student> list);
}
