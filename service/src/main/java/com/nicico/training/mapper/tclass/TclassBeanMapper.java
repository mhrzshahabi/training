package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.mapper.ClassSession.ClassSessionMapper;
import com.nicico.training.mapper.teacher.TeacherBeanMapper;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import org.mapstruct.*;
import org.springframework.transaction.annotation.Transactional;
import response.tclass.dto.TclassDto;

import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
@Transactional
public interface TclassBeanMapper {


    TclassDto toTclassResponse (Tclass tclass);
    TclassDTO.TClassCurrentTerm toTClassCurrentTerm (Tclass tclass);
    @Mappings({
            @Mapping(target = "classCode",source = "code"),
            @Mapping(target= "courseCode",source = "course.code"),
            @Mapping(target ="courseTitleFa",source = "course.titleFa"),
            @Mapping(target = "termTitleFa",source = "term.titleFa"),
          @Mapping(target = "studentsCount",source = "classStudents" ,qualifiedByName = "getStudentsCount"),
            @Mapping(target = "organizer",source = "organizer.titleFa"),
            @Mapping(target = " plannerName",source = "planner",ignore = false,qualifiedByName = "getName"),
            @Mapping(target = "teacherInfo.teacherCode",source = "teacher.teacherCode"),
            @Mapping(target = "teacherInfo.teacherName",source = "teacher",qualifiedByName = "getTeacherName"),
            @Mapping(target = "classSessions",source = "classSessions", ignore = false,qualifiedByName = "toClassSessionDTOS"),
            @Mapping(target = "supervisorName",source = "supervisor",ignore = false,qualifiedByName = "getName")

    })
    TclassDTO.TClassTimeDetails toTcClassTimeDetail(Tclass tclass);

    @Named("getStudentsCount")
    default Long getStudentsCount(Set<ClassStudent> classStudents){

        if(classStudents!=null)
        return classStudents.stream().count();
        else
            return 0L;
    }
   @Named("getSupervisorName")
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

}
