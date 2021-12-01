package com.nicico.training.mapper.ClassSession;

import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.model.*;
import org.mapstruct.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring")
@Transactional
public interface ClassSessionMapper {



    ClassSessionDTO.AttendanceClearForm toClassSessionDTO(ClassSession classSession);

    Set<ClassSessionDTO.AttendanceClearForm> toClassSessionDTOS(Set<ClassSession> classSessions);

    @Mappings({
            @Mapping(target = "classCode",source = "tclass.code"),
            @Mapping(target = "courseCode",source = "tclass.course.code"),
            @Mapping(target = "courseTitleFa",source = "tclass.course.titleFa"),
            @Mapping(target = "group",source = "tclass.group"),
            @Mapping(target = "sessionDate",source = "sessionDate"),
            @Mapping(target = "sessionStartHour",source = "sessionStartHour"),
            @Mapping(target = "sessionEndHour",source = "sessionEndHour"),
            @Mapping(target = "studentsCount", source = "tclass.classStudents" , qualifiedByName = "getStudentsCount"),
            @Mapping(target = "teacherInfo.teacherCode", source = "tclass.teacher.teacherCode"),
            @Mapping(target = "teacherInfo.teacherName", source = "tclass.teacher", qualifiedByName = "getTeacherName"),
            @Mapping(target = "supervisorName", source = "tclass.supervisor", ignore = false, qualifiedByName = "getPersonnelName"),
            @Mapping(target = "plannerName", source = "tclass.planner", ignore = false, qualifiedByName = "getPersonnelName")
    })
    ClassSessionDTO.TClassSessionsDetail toClassSessionDetails(ClassSession classSession);

    List<ClassSessionDTO.TClassSessionsDetail> toClassSessionDetailsList(List<ClassSession> classSessions);

    @Named("getStudentsCount")
    default Long getStudentsCount(Set<ClassStudent> classStudents){

        if(classStudents!=null)
            return classStudents.stream().count();
        else
            return 0L;
    }

    @Named("getTeacherName")
    default String getTeacherName(Teacher teacher){
        String s = null;
        String firstName=    teacher.getPersonality().getFirstNameFa();
        String lastName=teacher.getPersonality().getLastNameFa();

        if(teacher!=null) {
            if (firstName.equals(null) && lastName != null) {
                s =lastName;
            }
            if (lastName == null && firstName != null) {
                s = firstName;
            }
            if (firstName != null && lastName != null) {
                s = firstName + " " + lastName;
            }
            if (firstName== null && lastName== null) {
                s = " ";
            }
        }
        return s;
    }

    @Named("getPersonnelName")
    default String getName(Personnel personnel){

        String s = null;
        if(personnel!=null) {
            if (personnel.getFirstName().equals(null) && personnel.getLastName() != null) {
                s = personnel.getLastName();
            }
            if (personnel.getLastName() == null && personnel.getFirstName() != null) {
                s = personnel.getLastName();
            }
            if (personnel.getFirstName() != null && personnel.getLastName() != null) {
                s = personnel.getFirstName() + " " + personnel.getLastName();
            }
            if (personnel.getFirstName() == null && personnel.getLastName() == null) {
                s = " ";
            }
        }
        return s;
    }

}
