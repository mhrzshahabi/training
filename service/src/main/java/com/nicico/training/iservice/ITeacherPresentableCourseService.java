package com.nicico.training.iservice;

import com.nicico.training.dto.ElsPresentableResponse;
import com.nicico.training.model.TeacherPresentableCourse;

import java.util.List;

public interface ITeacherPresentableCourseService {
    TeacherPresentableCourse savePresentableCourse(ElsPresentableResponse elsPresentableCourse);

    void deletePresentableCourse(Long id);

    ElsPresentableResponse editPresentableCourse(ElsPresentableResponse elsPresentableCourse);

    List<ElsPresentableResponse> getAllByNationalCode(String nationalCode);
}
