package com.nicico.training.mapper.student;

import com.nicico.training.dto.StudentDTO;
import com.nicico.training.model.Student;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface StudentMapper {

    List<StudentDTO.LmsInfo> toStudentLmsInfoDto(List<Student> list);
}
