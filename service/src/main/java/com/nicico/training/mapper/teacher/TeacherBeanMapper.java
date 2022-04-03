package com.nicico.training.mapper.teacher;

import com.nicico.training.dto.ElsTeacherInfoDto;
import com.nicico.training.dto.TeacherInfoDTO;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.Category;
import com.nicico.training.model.Teacher;
import org.mapstruct.*;
import response.teacher.dto.TeacherInCourseDto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN,uses = {TclassBeanMapper.class})
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
            @Mapping(target = "fullName",source = "teacher",qualifiedByName = "getTeacherName"),
            @Mapping(target = "mobileNumber",source = "personality.contactInfo.mobile"),
            @Mapping(target = "emailAddress",source = "personality.contactInfo.email"),
            @Mapping(target="birthCertificateNumber",source = "personality.birthCertificate"),
            @Mapping(target = "teacherStatus",source = "teacher",qualifiedByName = "getTeacherStatus"),
            @Mapping(target="educationFields",source = "teacher",qualifiedByName = "getCategories")
    })
    TeacherInfoDTO toTeacherInfoDTO(Teacher teacher);

    List<TeacherInfoDTO> toTeacherInfoDTOs(List<Teacher> teachers);



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

    @Mappings({
            @Mapping(target = "id", source = "id"),
            @Mapping(target = "firstName", source = "personality.firstNameFa"),
            @Mapping(target = "lastName", source = "personality.lastNameFa"),
            @Mapping(target = "fatherName", source = "personality.fatherName"),
            @Mapping(target = "nationalCode", source = "personality.nationalCode"),
            @Mapping(target = "birthDate", source = "personality.birthDate", qualifiedByName = "getBirthDate"),
            @Mapping(target = "mobileNumber", source = "personality.contactInfo.mobile"),
            @Mapping(target = "teachingBackground", source = "teachingBackground"),
            @Mapping(target = "iban", source = "iban"),
            @Mapping(target = "email", source = "personality.contactInfo.email"),
    })
    ElsTeacherInfoDto toElsTeacherInfoDto(Teacher teacher);

    @Named("getBirthDate")
    default Long getBirthDate(String birthDate) {
        if (birthDate != null) {
            Date date = getEpochDate(birthDate, "04:30");
            return (date.getTime() * 1000);
        } else {
            return null;
        }
    }

    @Mappings({
            @Mapping(target = "fatherName", source = "personality.fatherName"),
            @Mapping(target = "birthDate", source = "personality.birthDate"),
            @Mapping(target = "teachingBackgroundInMonth", source = "teachingBackground", qualifiedByName = "getBackgroundInMonth"),
            @Mapping(target = "teachingBackgroundInYear", source = "teachingBackground", qualifiedByName = "getBackgroundInYear"),
            @Mapping(target = "iban", source = "iban"),
            @Mapping(target = "email", source = "personality.contactInfo.email"),
    })
    ElsTeacherInfoDto.Resume toElsTeacherResumeDto(Teacher teacher);


    @Named("getBackgroundInMonth")
    default String getBackgroundInMonth(Long teachingBackground) {
        if (teachingBackground != null) {
            Long mounth = teachingBackground % 12;
            return mounth.toString();
        } else {
            return null;
        }
    }
    @Named("getBackgroundInYear")
    default String getBackgroundInYear(Long teachingBackground) {
        if (teachingBackground != null) {
            Long year = teachingBackground / 12;
            return year.toString();
        } else {
            return null;
        }
    }

}
