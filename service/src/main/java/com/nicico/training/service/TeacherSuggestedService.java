package com.nicico.training.service;

import com.nicico.training.dto.ElsSuggestedCourse;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.iservice.ITeacherSuggestedService;
import com.nicico.training.mapper.teacher.TeacherSuggestedCourseMapper;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherSuggestedCourse;
import com.nicico.training.repository.TeacherSuggestedCourseDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class TeacherSuggestedService implements ITeacherSuggestedService {
    @Autowired
    private  final TeacherSuggestedCourseDAO dao;
    @Autowired
    private final ICategoryService categoryService;
    @Autowired
    private final ISubcategoryService subcategoryService;
    private final ITeacherService teacherService;
    private final TeacherSuggestedCourseMapper teacherSuggestedCourseMapper;
    @Override
    public TeacherSuggestedCourse saveSuggestion(ElsSuggestedCourse elsSuggestedCourse) {
        TeacherSuggestedCourse teacherSuggestedCourse=new TeacherSuggestedCourse();
        teacherSuggestedCourse.setCourseTitle(elsSuggestedCourse.getCourseTitle());
        if (elsSuggestedCourse.getCategories() != null && elsSuggestedCourse.getCategories().size() > 0) {

            Set<Category> categories = categoryService.getCategoriesByIds(elsSuggestedCourse.getCategories());
            if (categories != null)
                teacherSuggestedCourse.setCategories(categories);
        }

        if (elsSuggestedCourse.getSubcategories() != null && elsSuggestedCourse.getSubcategories().size() > 0) {

            Set<Subcategory> subcategories = subcategoryService.getSubcategoriesByIds(elsSuggestedCourse.getSubcategories());
            if (subcategories != null)
               teacherSuggestedCourse.setSubcategories(subcategories);

        }
        teacherSuggestedCourse.setDescription(elsSuggestedCourse.getDescription());
       Long teacherId= teacherService.getTeacherIdByNationalCode(elsSuggestedCourse.getNationalCode());
        Teacher teacher=teacherService.getTeacher(teacherId);
       teacherSuggestedCourse.setTeacherId(teacherId);
       teacherSuggestedCourse.setTeacher(teacher);

       TeacherSuggestedCourse saved=dao.save(teacherSuggestedCourse);

       return saved;

    }

    @Override
    @Transactional
    public BaseResponse deleteSuggestedCourse(Long id,Long teacherId) {
        BaseResponse baseResponse=new BaseResponse();
        try{
           TeacherSuggestedCourse teacherSuggestedCourse= dao.getById(id);
            dao.delete(teacherSuggestedCourse);
            baseResponse.setStatus(200);
            baseResponse.setMessage("successfully deleted!");
        }catch (Exception e){
            baseResponse.setMessage("not deleted");
            baseResponse.setStatus(406);

        }
        return baseResponse;
    }

    @Override
    @Transactional
    public ElsSuggestedCourse editSuggestedService(ElsSuggestedCourse elsSuggestedCourse) {
        try{
        TeacherSuggestedCourse suggestedCourse= dao.getById(elsSuggestedCourse.getId());
        suggestedCourse.setCourseTitle(elsSuggestedCourse.getCourseTitle());
        suggestedCourse.setDescription(elsSuggestedCourse.getDescription());
        dao.save(suggestedCourse);

           elsSuggestedCourse.setStatus(200);
           elsSuggestedCourse.setMessage("successfully modified!");
           return  elsSuggestedCourse;
       }catch (Exception e){
            elsSuggestedCourse.setMessage("not modified!");
            elsSuggestedCourse.setStatus(406);
            return elsSuggestedCourse;
        }

    }

    @Override
    public List<TeacherSuggestedCourse> findAllTeacherSuggested(Long teacherId) {
       return  dao.findAllByTeacherId(teacherId);
    }

    @Override
    public ElsSuggestedCourse getById(Long id) {
        ElsSuggestedCourse response=new ElsSuggestedCourse();
       Optional< TeacherSuggestedCourse> optional=dao.findById(id);
       if(optional.isPresent()){
           response.setId(optional.get().getId());
           response.setCourseTitle(optional.get().getCourseTitle());
           response.setDescription(optional.get().getDescription());
           response.setCategories(dao.getCategoriesBySuggestedId(id));
           response.setSubcategories(dao.getSubcategories(id));
           response.setStatus(200);
           response.setMessage("successfully get");

       }else{
           response.setStatus(406);
           response.setMessage("get failed");
       }
       return response;
    }

    @Override
    @Transactional
    public List<ElsSuggestedCourse> findAllTeacherSuggestedDtoList(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<TeacherSuggestedCourse> teacherSuggestedCourses = dao.findAllByTeacherId(teacherId);
        List<ElsSuggestedCourse> dtos = teacherSuggestedCourseMapper.toElsSuggestedCourses(teacherSuggestedCourses);
        return dtos;
    }
}
