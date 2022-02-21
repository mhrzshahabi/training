package com.nicico.training.mapper.teacher;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.TimeZone;
import com.ibm.icu.util.ULocale;
import com.nicico.training.dto.ElsTeacherCertification;
import com.nicico.training.dto.ElsTeacherCertificationsDto;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITeacherCertificationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherCertification;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.datetime.DateFormatterRegistrar;

import javax.persistence.metamodel.IdentifiableType;
import java.sql.Timestamp;
import java.time.ZoneId;
import java.util.ArrayList;
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
    protected ITeacherCertificationService teacherCertificationService;
    @Autowired
    protected ITeacherService teacherService;

   public  List< ElsTeacherCertificationsDto> toElsTeacherCertifications(List<TeacherCertification> teacherCertifications){
     List<ElsTeacherCertificationsDto> list=new ArrayList<>();
       teacherCertifications.stream().forEach(teacherCertification -> {
           ElsTeacherCertificationsDto dto=new ElsTeacherCertificationsDto();
           dto.setCourseTitle(teacherCertification.getCourseTitle());
           dto.setCompanyName(teacherCertification.getCompanyName());
           dto.setCertification(teacherCertification.getCertificationStatusDetail());
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
        Date date=new Date(elsTeacherCertification.getCourseDate());
        String persianDate=convertToPersianDate(date);
        teacherCertification.setStartDate(persianDate);
        teacherCertification.setCertificationStatus(elsTeacherCertification.getCertificationStatus());
        teacherCertification.setCertificationStatusDetail(elsTeacherCertification.getCertification());

        teacherCertification.setTeacherId(teacherId);
      Teacher teacher=  teacherService.getTeacher(teacherId);
        teacherCertification.setTeacher(teacher);


        return teacherCertification;


    }

    private String convertToPersianDate(Date _date) {
        Long date = _date.getTime();
        ULocale PERSIAN_LOCALE = new ULocale("fa_IR");
        ZoneId IRAN_ZONE_ID = ZoneId.of("Asia/Tehran");

        SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd", PERSIAN_LOCALE );
        df.setTimeZone(TimeZone.getTimeZone("GMT+3:30"));
        return df.format(date);
    }


}
