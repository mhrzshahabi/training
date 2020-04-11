package com.nicico.training.iservice;

import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TclassDTO;

import java.util.List;

public interface IPersonnelInformationService {

    CourseDTO.CourseDetailInfo findCourseById(Long courseId);

    TclassDTO.ClassDetailInfo findClassById(Long classId);

    List<TclassDTO.Info> findClassesByCourseId(Long courseId);
}
