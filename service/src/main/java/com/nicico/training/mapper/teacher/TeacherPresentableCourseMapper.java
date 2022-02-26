package com.nicico.training.mapper.teacher;

import com.nicico.training.dto.ElsPresentableResponse;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.model.*;
import com.nicico.training.repository.CourseDAO;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeacherPresentableCourseMapper {
    @Autowired
    protected CourseDAO courseDAO;
    @Autowired
    protected IGoalService goalService;
    @Transactional
    public ElsPresentableResponse toElsPresentableCourse(TeacherPresentableCourse teacherPresentableCourse) {
        ElsPresentableResponse response=new ElsPresentableResponse();
        List<String> categoryTitles=new ArrayList<>();
        List<String> subcategoryTitles=new ArrayList<>();
        List<String> preCourseTitle=new ArrayList<>();
        List<String> syllabusTitles=new ArrayList<>();
        response.setId(teacherPresentableCourse.getId());
        if(teacherPresentableCourse.getCourseId()!=null)
        response.setCourseId(teacherPresentableCourse.getCourseId());

        response.setDescription(teacherPresentableCourse.getDescription());
       Set<Category > categories= teacherPresentableCourse.getCategories();
       if(categories!=null) {
           categories.stream().forEach(category -> {
               categoryTitles.add(category.getTitleFa());
           });
           response.setCategoryTitles(categoryTitles);
       }

       Set<Subcategory> subcategories=teacherPresentableCourse.getSubCategories();
       if(subcategories!=null) {
           subcategories.stream().forEach(subcategory -> {
               subcategoryTitles.add(subcategory.getTitleFa());
           });
           if (subcategoryTitles != null)
               response.setSubCategoryTitles(subcategoryTitles);
       }
       Course course=teacherPresentableCourse.getCourse();
        response.setCourseDuration(teacherPresentableCourse.getCourse().getTheoryDuration().toString());
       List<Long> courseIds=courseDAO.findAllPrecourseBy(course.getId());
       if(courseIds!=null && courseIds.size()>0) {
           courseIds.stream().forEach(id -> {
              preCourseTitle.add(courseDAO.getById(id).getTitleFa());
           });
       }
       if(preCourseTitle!=null)
       response.setPreCourseTitles(preCourseTitle);
       if(course.getHasGoal() ){
           List<Goal> goals=new ArrayList<>();
          List<Long> goalIds= courseDAO.findAllGoalId(course.getId());
          if(goalIds!=null && goalIds.size()>0){
              goalIds.stream().forEach(goalId->{
                 Goal goal= goalService.getById(goalId);
                 goals.add(goal);
              });
          }

          goals.stream().forEach(goal -> {
            Set<Syllabus> syllabusSet=  goal.getSyllabusSet();
            if(syllabusSet.stream().count()>0L){
                syllabusSet.stream().forEach(syllabus -> {
                    subcategoryTitles.add(syllabus.getTitleFa());
                });
            }
          });
       }
       if(subcategoryTitles!=null)
       response.setCourseSyllabusTitles(syllabusTitles);
      return response;

    }

}
