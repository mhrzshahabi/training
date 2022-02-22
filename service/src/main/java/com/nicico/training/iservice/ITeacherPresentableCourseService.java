package com.nicico.training.iservice;

import com.nicico.training.dto.ElsPresentableCourse;
import com.nicico.training.model.TeacherPresentableCourse;

public interface ITeacherPresentableCourseService {
    TeacherPresentableCourse savePresentableCourse(ElsPresentableCourse elsPresentableCourse);
}
