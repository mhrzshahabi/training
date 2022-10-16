package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.*;
import dto.exam.ElsExamCreateDTO;
import dto.exam.ExamCreateDTO;
import org.mapstruct.*;
import org.springframework.transaction.annotation.Transactional;
import response.tclass.dto.TclassDto;
import java.util.List;

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
            @Mapping(target = " plannerName",source = "planner",ignore = false,qualifiedByName = "getSupervisorName"),
            @Mapping(target = "teacherInfo.teacherCode",source = "teacher.teacherCode"),
            @Mapping(target = "teacherInfo.teacherName",source = "teacher",qualifiedByName = "getTeacherName"),
            @Mapping(target = "classSessions",source = "classSessions", ignore = true,qualifiedByName = "toClassSessionDTOS"),
            @Mapping(target = "supervisorName",source = "supervisor",ignore = false,qualifiedByName = "getSupervisorName"),
            @Mapping(target = "classStatus",source = "tclass",qualifiedByName = "getClassStatus"),
            @Mapping(target = "classType",source = "tclass.teachingType")

    })
    TclassDTO.TClassTimeDetails toTcClassTimeDetail(Tclass tclass);

    List<TclassDTO.TClassTimeDetails> toTclassTimeDetailList(List<Tclass> tclasses);


    @Mappings({
            @Mapping(target = "classCode", source = "code"),
            @Mapping(target = "courseCode", source = "course.code"),
            @Mapping(target = "courseTitle", source = "course.titleFa"),
            @Mapping(target = "studentsCount", source = "classStudents" , qualifiedByName = "getStudentsCount"),
            @Mapping(target = "organizerName", source = "organizer.titleFa"),
            @Mapping(target = "teacherInfo.teacherCode", source = "teacher.teacherCode"),
            @Mapping(target = "teacherInfo.teacherName", source = "teacher", qualifiedByName = "getTeacherName"),
            @Mapping(target = "sessions", source = "classSessions", ignore = true, qualifiedByName = "toClassSessionDTOS"),
            @Mapping(target = "supervisorName", source = "supervisor", ignore = false, qualifiedByName = "getSupervisorName")
    })
    TclassDTO.TClassDataService getTClassDataService(Tclass tclass);

    @Mappings({
            @Mapping(target = "classId", source = "id"),
            @Mapping(target = "name", source = "titleClass"),
            @Mapping(target = "minimumAcceptScore", source = "acceptancelimit"),
            @Mapping(target = "examCode", source = "code")
    })
    ElsExamCreateDTO toExamCreateDTO(Tclass tclass);

    @Named("getStudentsCount")
    default Long getStudentsCount(Set<ClassStudent> classStudents){

        if(classStudents!=null)
        return (long) classStudents.size();
        else
            return 0L;
    }

   @Named("getSupervisorName")
    default String getName(Personnel personnel){

        String s = null;
        if(personnel!=null) {
            if (personnel.getFirstName()!=null && personnel.getLastName() != null) {
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
       if(teacher!=null && teacher.getPersonality()!=null) {
           String firstName=    teacher.getPersonality().getFirstNameFa();
           String lastName=teacher.getPersonality().getLastNameFa();
           if (firstName!=null && lastName != null) {
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

   @Named("getClassStatus")
    default String getClassStatus(Tclass tclass){
      switch (tclass.getClassStatus()){
          case "1":return "برنامه ریزی";
          case "2": return "در حال اجرا";
          case "3": return "پایان یافته";
          case"4": return "لغو شده";
          case"5":return "اختتام";
          default: return null;
      }

   }

    @AfterMapping
    default void setScoreAndQuestionCount(@MappingTarget ElsExamCreateDTO elsExamCreateDTO, Tclass tclass) {
        elsExamCreateDTO.setQuestionCount(0);

        if (tclass.getScoringMethod() != null) {
            if (tclass.getScoringMethod().equals("2")) {
                elsExamCreateDTO.setScore(100d);
            } else if (tclass.getScoringMethod().equals("3")) {
                elsExamCreateDTO.setScore(20d);
            }
        }
    }

}
