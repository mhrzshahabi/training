package com.nicico.training.mapper.teacher;

import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.TeacherInfoDTO;
import com.nicico.training.model.Category;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Teacher;
import com.nicico.training.service.CategoryService;
import org.mapstruct.*;
import response.teacher.dto.TeacherInCourseDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TeacherBeanMapper {
    TeacherInCourseDto toTeacherInCourseDto (Teacher teacher);


    default List<TeacherInCourseDto> toTeacherInCourseDtoList(List<Teacher> teacherList){
        return teacherList.stream().map(this::toTeacherInCourseDto).collect(Collectors.toList());
    }

    @Mappings({
            @Mapping(target = "teacherCode",source = "teacherCode"),
            @Mapping(target="nationalCode",source = "personality.nationalCode"),
            @Mapping(target = "firstName",source = "personality.firstNameFa"),
            @Mapping(target = "lastName",source = "personality.lastNameFa"),
            @Mapping(target = "fullName",source = "teacher",qualifiedByName = "getFullName"),
            @Mapping(target = "mobileNumber",source = "personality.contactInfo.mobile"),
            @Mapping(target = "emailAddress",source = "personality.contactInfo.email"),
            @Mapping(target="birthCertificateNumber",source = "personality.birthCertificate"),
            @Mapping(target = "teacherStatus",source = "teacher",qualifiedByName = "getTeacherStatus"),
            @Mapping(target="educationFields",source = "teacher",qualifiedByName = "getCategories")
    })
    TeacherInfoDTO toTeacherInfoDTO(Teacher teacher);

    List<TeacherInfoDTO> toTeacherInfoDTOs(List<Teacher> teachers);


    @Named("getFullName")
    default String getFullName(Teacher teacher){
        return teacher.getPersonality().getFirstNameFa()+" "+teacher.getPersonality().getLastNameFa();
    }
    @Named("getTeacherStatus")
    default String getTeacherStatus(Teacher teacher){
        String status;
        if(teacher.getPersonnelStatus()){
            status="داخلی";
        }else {
            status="بیرونی";
        }
        return status;
    }

    @Named("getCategories")
    default List<String> getCategories(Teacher teacher){
        List<String> categories=new ArrayList<>();
      Set<Category> categoriesSet=teacher.getCategories();
      if(categoriesSet!=null) {
          categoriesSet.stream().forEach(category -> {
              categories.add(category.getTitleFa());
          });
      }
      return categories;
    }


}
