package com.nicico.training.service;

import com.nicico.training.iservice.IPersonnelInformationService;
import com.nicico.training.model.Course;
import com.nicico.training.repository.CourseDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PersonnelInformationService implements IPersonnelInformationService {

    private final CourseDAO courseDAO;

    @Transactional
    @Override
    public Course findCourseById(Long courseId)
    {
        return courseDAO.findCourseByIdEquals(courseId);
    }
}
