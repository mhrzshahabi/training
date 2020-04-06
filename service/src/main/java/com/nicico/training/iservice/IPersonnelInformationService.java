package com.nicico.training.iservice;

import com.nicico.training.model.Course;

public interface IPersonnelInformationService {

    Course findCourseById(Long courseId);
}
