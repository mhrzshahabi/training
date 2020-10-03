package com.nicico.training.mapper.teacher;

import com.nicico.training.model.Teacher;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import response.teacher.dto.TeacherInCourseDto;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TeacherBeanMapper {
    TeacherInCourseDto toTeacherInCourseDto (Teacher teacher);

    default List<TeacherInCourseDto> toTeacherInCourseDtoList(List<Teacher> teacherList){
        return teacherList.stream().map(this::toTeacherInCourseDto).collect(Collectors.toList());
    }
}
