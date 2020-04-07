package com.nicico.training.iservice;

import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TclassDTO;

public interface IPersonnelInformationService {

    CourseDTO.CourseDetailInfo findCourseById(Long courseId);

    TclassDTO.ClassDetailInfo findClassById(Long classId);
}
