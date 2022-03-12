package com.nicico.training.service;

import com.nicico.training.dto.ElsPresentableResponse;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.TeacherPresentableCourseDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.acls.model.NotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherPresentableCourseService implements ITeacherPresentableCourseService {
    @Autowired
    private final TeacherPresentableCourseDAO dao;
    @Autowired
    private final ICourseService courseService;
    @Autowired
    private final ICategoryService categoryService;
    @Autowired
    private final ISubcategoryService subcategoryService;
    @Autowired
    private final ITeacherService teacherService;
    @Autowired
    private final CourseDAO courseDAO;
    @Autowired
    private final IGoalService goalService;

    @Autowired
    private final ISyllabusService syllabusService;

    @Transactional
    @Override
    public TeacherPresentableCourse savePresentableCourse(ElsPresentableResponse elsPresentableCourse) {

        Set<Category> categories = categoryService.getCategoriesByIds(elsPresentableCourse.getCategoryIds());
        Set<Subcategory> subcategories = subcategoryService.getSubcategoriesByIds(elsPresentableCourse.getSubCategoryIds());

        Course course = courseService.getCourse(elsPresentableCourse.getCourseId());
        Long teacherId = teacherService.getTeacherIdByNationalCode(elsPresentableCourse.getNationalCode());
        Teacher teacher = teacherService.getTeacher(teacherId);
        ;
        TeacherPresentableCourse teacherPresentableCourse = new TeacherPresentableCourse();
        teacherPresentableCourse.setCourseTitle(course.getTitleFa());
        teacherPresentableCourse.setCategories(categories);
        teacherPresentableCourse.setCourse(course);
        teacherPresentableCourse.setCourseId(course.getId());
        teacherPresentableCourse.setCategories(categories);
        teacherPresentableCourse.setSubCategories(subcategories);


        teacherPresentableCourse.setTeacherId(teacherId);
        teacherPresentableCourse.setTeacher(teacher);
        teacherPresentableCourse.setDescription(elsPresentableCourse.getDescription());


        return dao.save(teacherPresentableCourse);


    }

    @Override
    public void deletePresentableCourse(Long id) {
    dao.deleteById(id);

    }

    @Override
    @Transactional
    public ElsPresentableResponse editPresentableCourse(ElsPresentableResponse elsPresentableCourse) {

        Long id = elsPresentableCourse.getId();
        TeacherPresentableCourse saved = new TeacherPresentableCourse();

        Optional<TeacherPresentableCourse> teacherPresentableCourse = dao.findById(id);
        if (teacherPresentableCourse.isPresent()) {
            teacherPresentableCourse.get().setDescription(elsPresentableCourse.getDescription());

            Course course=   courseService.getCourse(elsPresentableCourse.getCourseId());
           elsPresentableCourse.setCourseTitle(course.getTitleFa());
            saved = dao.save(teacherPresentableCourse.get());
        } else {
            throw new  NotFoundException("not edited");

        }


        return elsPresentableCourse;
    }

    @Override
    public List<ElsPresentableResponse> getAllByNationalCode(String nationalCode) {
        Long teacherId=teacherService.getTeacherIdByNationalCode(nationalCode);
        List<ElsPresentableResponse> responses=new ArrayList<>();

       List<TeacherPresentableCourse> presentableCourseList= dao.findAllByTeacherId(teacherId);
       if(presentableCourseList!=null && presentableCourseList.size()>0){

           presentableCourseList.stream().forEach(teacherPresentableCourse -> {
               List<String> categoryTitles=new ArrayList<>();
               List<String>  subcategoryTitles=new ArrayList<>();
               List<String> preCourseTitle=new ArrayList<>();
               List<String> syllabusTitles=new ArrayList<>();

               ElsPresentableResponse response = new ElsPresentableResponse();
               response.setId(teacherPresentableCourse.getId());
               response.setCourseId(teacherPresentableCourse.getCourseId());

               response.setDescription(teacherPresentableCourse.getDescription());
               Course course = courseService.getCourse(teacherPresentableCourse.getCourseId());
               List<Long> categoryIds = dao.findAllCatById(teacherPresentableCourse.getId());
               response.setCategoryIds(categoryIds);

               Set<Category> categories = categoryService.getCategoriesByIds(categoryIds);

               if (categories != null) {
                   categories.stream().forEach(category -> {
                       categoryTitles.add(category.getTitleFa());
                   });
                   response.setCategoryTitles(categoryTitles);
               }
               List<Long> subcategoryIds = dao.findAllSubById(course.getId());
               response.setSubCategoryIds(subcategoryIds);

               Set<Subcategory> subcategories = subcategoryService.getSubcategoriesByIds(subcategoryIds);

               if (subcategories != null) {
                   subcategories.stream().forEach(subcategory -> {
                       subcategoryTitles.add(subcategory.getTitleFa());
                   });
                   if (subcategoryTitles != null)
                       response.setSubCategoryTitles(subcategoryTitles);
               }

               response.setCourseDuration(course.getTheoryDuration().toString());
               List<Long> courseIds = courseDAO.findAllPrecourseBy(course.getId());
               if (courseIds != null && courseIds.size() > 0) {
                   courseIds.stream().forEach(id -> {
                       if(courseDAO.findById(id).isPresent())
                       preCourseTitle.add(courseDAO.findById(id).get().getTitleFa());
                   });
               }
               if (preCourseTitle != null)
                   response.setPreCourseTitles(preCourseTitle);
               if (course.getHasGoal()) {
                   List<Goal> goals = new ArrayList<>();
                   List<Long> goalIds = courseDAO.findAllGoalId(course.getId());
                   if (goalIds != null && goalIds.size() > 0) {
                       goalIds.stream().forEach(goalId -> {
                           Goal goal = goalService.getById(goalId);
                           goals.add(goal);
                       });
                   }

                   goals.stream().forEach(goal -> {
                       Set<Syllabus> syllabusSet = syllabusService.getByGoal(goal.getId());
                       if (syllabusSet.stream().count() > 0L) {
                           syllabusSet.stream().forEach(syllabus -> {
                               syllabusTitles.add(syllabus.getTitleFa());
                           });
                       }
                   });
               }
               if (syllabusTitles != null)
                   response.setCourseSyllabusTitles(syllabusTitles);
               responses.add(response);

           });

       }
       return responses;

    }
}