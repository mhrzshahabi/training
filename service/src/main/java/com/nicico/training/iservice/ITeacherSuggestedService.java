package com.nicico.training.iservice;

import com.nicico.training.dto.ElsSuggestedCourse;
import com.nicico.training.model.TeacherSuggestedCourse;
import response.BaseResponse;

import java.util.List;

public interface ITeacherSuggestedService {
    TeacherSuggestedCourse saveSuggestion(ElsSuggestedCourse elsSuggestedCourse);

    BaseResponse deleteSuggestedCourse(Long id,Long teacherId);

    ElsSuggestedCourse editSuggestedService(ElsSuggestedCourse elsSuggestedCourse);

    List<TeacherSuggestedCourse> findAllTeacherSuggested(Long teacherId);

    ElsSuggestedCourse getById(Long id);

    List<ElsSuggestedCourse> findAllTeacherSuggestedDtoList(String nationalCode);
}
