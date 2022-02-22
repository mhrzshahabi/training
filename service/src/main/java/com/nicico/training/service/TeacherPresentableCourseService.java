package com.nicico.training.service;

import com.nicico.training.dto.ElsPresentableCourse;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.TeacherPresentableCourseDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    @Override
    @Transactional
    public TeacherPresentableCourse savePresentableCourse(ElsPresentableCourse elsPresentableCourse) {
       Category category= categoryService.getCategory(elsPresentableCourse.getCategoryIds().get(0));
        Subcategory subcategory=subcategoryService.getById(elsPresentableCourse.getSubCategoryIds().get(0));
      Course course=  courseService.getCourse(elsPresentableCourse.getCourseId());
    Long teacherId=  teacherService.getTeacherIdByNationalCode(elsPresentableCourse.getNationalCode());
    Teacher teacher=teacherService.getTeacher(teacherId);
        ;
        TeacherPresentableCourse teacherPresentableCourse=new TeacherPresentableCourse();
        teacherPresentableCourse.setCourseTitle(course.getTitleFa());
        teacherPresentableCourse.setCourseId(course.getId());
        teacherPresentableCourse.setCourse(course);
        teacherPresentableCourse.setCategoryId(category.getId());
        teacherPresentableCourse.setCategory(category);
        teacherPresentableCourse.setSubCategoryId(subcategory.getId());
        teacherPresentableCourse.setSubCategory(subcategory);
        teacherPresentableCourse.setTeacherId(teacherId);
        teacherPresentableCourse.setTeacher(teacher);
        teacherPresentableCourse.setDescription(elsPresentableCourse.getDescription());

        TeacherPresentableCourse saved=dao.save(teacherPresentableCourse);
        return saved;



    }
}
