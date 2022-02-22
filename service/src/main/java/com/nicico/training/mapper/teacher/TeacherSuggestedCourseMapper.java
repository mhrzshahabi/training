package com.nicico.training.mapper.teacher;

import com.nicico.training.dto.ElsSuggestedCourse;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.model.TeacherSuggestedCourse;
import org.checkerframework.checker.units.qual.C;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public  abstract class TeacherSuggestedCourseMapper {
    @Autowired
    protected ICategoryService categoryService;
    @Autowired
    protected ISubcategoryService subcategoryService;


    public ElsSuggestedCourse toElsSuggestedCourse(TeacherSuggestedCourse teacherSuggestedCourse) {
        List<Long> categoryIds=new ArrayList<>();
        List<Long> subcategoryIds=new ArrayList<>();
        ElsSuggestedCourse elsSuggestedCourse=new ElsSuggestedCourse();
        elsSuggestedCourse.setId(teacherSuggestedCourse.getId());
        elsSuggestedCourse.setCourseTitle(teacherSuggestedCourse.getCourseTitle());
        elsSuggestedCourse.setDescription(teacherSuggestedCourse.getDescription());
        teacherSuggestedCourse.getCategories().stream().forEach(category -> {
            categoryIds.add(category.getId());
        });
        teacherSuggestedCourse.getSubcategories().stream().forEach(subcategory -> {
            subcategoryIds.add(subcategory.getId());
        });


        elsSuggestedCourse.setCategories(categoryIds);
        elsSuggestedCourse.setSubcategories(subcategoryIds);
       return elsSuggestedCourse;

    }
    public List<ElsSuggestedCourse> toElsSuggestedCourses(List<TeacherSuggestedCourse> teacherSuggestedCourses){
        List<ElsSuggestedCourse> result=new ArrayList<>();
        teacherSuggestedCourses.stream().forEach(teacherSuggestedCourse -> {
            ElsSuggestedCourse els=new ElsSuggestedCourse();
            els.setId(teacherSuggestedCourse.getId());
            els.setCourseTitle(teacherSuggestedCourse.getCourseTitle());
            els.setDescription(teacherSuggestedCourse.getDescription());
            result.add(els);

        });
        return result;

    }

}
