package com.nicico.training.mapper.course;

import com.nicico.training.model.Course;
import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import org.mapstruct.*;
import request.course.CourseUpdateRequest;
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

    @Mapping(source = "runType", target = "ERunType", qualifiedByName = "toRunType")
    @Mapping(source = "levelType", target = "ELevelType", qualifiedByName = "toLevelType")
    @Mapping(source = "theoType", target = "ETheoType", qualifiedByName = "toTheoType")
    @Mapping(source = "technicalType", target = "ETechnicalType", qualifiedByName = "toTechnicalType")
    @Mapping(source = "duration", target = "theoryDuration")
    @Mapping(source = "issueTitle", target = "needText")
    @Mapping(source = "mainSkills", target = "skillMainObjectiveSet", ignore = true)
    Course updateCourse (CourseUpdateRequest request, @MappingTarget Course course);

    default List<CourseDto> toCourseDtoList(List<Course> courseList) {
        return courseList.stream().map(this::toCourseDto).collect(Collectors.toList());
    }

    @Named("toRunType")
    default ERunType toRunType(int id) {
        ERunType type = null;
        for (ERunType runType : ERunType.values()) {
            if(runType.getId() == id) {
                type =  runType;
                break;
            }
        }
        return type;
    }

    @Named("toLevelType")
    default ELevelType toLevelType(int id) {
        ELevelType type = null;
        for (ELevelType levelType : ELevelType.values()) {
            if(levelType.getId() == id) {
                type =  levelType;
                break;
            }
        }
        return type;
    }

    @Named("toTechnicalType")
    default ETechnicalType toTechnicalType(int id) {
        ETechnicalType type = null;
        for (ETechnicalType technicalType : ETechnicalType.values()) {
            if(technicalType.getId() == id) {
                type =  technicalType;
                break;
            }
        }
        return type;
    }

    @Named("toTheoType")
    default ETheoType toTheoType(int id) {
        ETheoType type = null;
        for (ETheoType theoType : ETheoType.values()) {
            if(theoType.getId() == id) {
                type =  theoType;
                break;
            }
        }
        return type;
    }
}
