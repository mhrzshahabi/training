package com.nicico.training.mapper.teacher;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.TimeZone;
import com.ibm.icu.util.ULocale;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.ElsTeacherCertification;
import com.nicico.training.dto.ElsTeacherCertificationDate;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.*;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.DateFormat;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeacherCertificationMapper {
    @Autowired
    protected ICategoryService categoryService;
    @Autowired
    protected ISubcategoryService subcategoryService;

    @Autowired
    protected ITeacherService teacherService;

   public  List<ElsTeacherCertificationDate> toElsTeacherCertifications(List<TeacherCertification> teacherCertifications){
     List<ElsTeacherCertificationDate> list=new ArrayList<>();
       teacherCertifications.stream().forEach(teacherCertification -> {
           ElsTeacherCertificationDate dto=new ElsTeacherCertificationDate();
           dto.setCourseTitle(teacherCertification.getCourseTitle());
           dto.setCompanyName(teacherCertification.getCompanyName());
           dto.setId(teacherCertification.getId());
           dto.setCertificationStatus(teacherCertification.getCertificationStatus());

           dto.setCourseDate(teacherCertification.getStartDate());
           list.add(dto);
       });
       return list;
    }

    public TeacherCertification toTeacherCertification(ElsTeacherCertification elsTeacherCertification,Long teacherId){

        TeacherCertification teacherCertification=new TeacherCertification();
        teacherCertification.setCourseTitle(elsTeacherCertification.getCourseTitle());
        teacherCertification.setCompanyName(elsTeacherCertification.getCompanyName());
        if(elsTeacherCertification.getCategoryIds()!=null && elsTeacherCertification.getCategoryIds().size()>0){

             Set<Category> categories= categoryService.getCategoriesByIds(elsTeacherCertification.getCategoryIds());
             if(categories!=null)
            teacherCertification.setCategories(categories);
        }

        if(elsTeacherCertification.getSubcategoryIds()!=null && elsTeacherCertification.getSubcategoryIds().size()>0){

               Set<Subcategory> subcategories= subcategoryService.getSubcategoriesByIds(elsTeacherCertification.getSubcategoryIds());
               if(subcategories!=null)
                   teacherCertification.setSubCategories(subcategories);

        }

        String persianDate=convertToPersianDate(elsTeacherCertification.getCourseDate());
        teacherCertification.setStartDate(persianDate);
        teacherCertification.setCertificationStatus(elsTeacherCertification.getCertificationStatus());


        teacherCertification.setTeacherId(teacherId);
      Teacher teacher=  teacherService.getTeacher(teacherId);
        teacherCertification.setTeacher(teacher);


        return teacherCertification;


    }


    private String convertToPersianDate(Long courseLongDate) {

        if (courseLongDate != null && courseLongDate != 0) {
            long time = courseLongDate;
            Date date = new Date(time);
            java.util.Calendar calendar = java.util.Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(java.util.Calendar.HOUR_OF_DAY, 4);
            calendar.add(Calendar.MINUTE, 30);
            date = calendar.getTime();
            DateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
            String pDate = DateUtil.convertMiToKh(dateFormat.format(date));
            return pDate;
        } else {
            return null;
        }

    }




}
