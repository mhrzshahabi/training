package com.nicico.training.iservice;

import com.nicico.training.model.CourseAudit;

import java.util.List;

public interface ICourseAuditService {

    List<CourseAudit> changeList(Long courseId);
}
