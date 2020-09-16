package com.nicico.training.mapper.course;

import com.nicico.training.model.Course;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import response.course.dto.CourseDto;

import java.util.List;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface CourseBeanMapper {

    @Mapping(source = "ERunType", target = "runType")
    @Mapping(source = "ELevelType", target = "levelType")
    @Mapping(source = "ETheoType", target = "theoType")
    @Mapping(source = "ETechnicalType", target = "technicalType")
    @Mapping(source = "theoryDuration", target = "duration")
    @Mapping(source = "needText", target = "issueTitle")
    CourseDto toCourseDto(Course course);

    default List<CourseDto> toCourseDtoList(List<Course> courseList) {
        return courseList.stream().map(this::toCourseDto).collect(Collectors.toList());
    }
}
