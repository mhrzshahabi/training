package com.nicico.training.service;

import com.nicico.training.iservice.ICourseAuditService;
import com.nicico.training.model.CourseAudit;
import com.nicico.training.repository.CourseAuditDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CourseAuditService implements ICourseAuditService {
    private final CourseAuditDAO courseAuditDAO;

    @Override
    public List<CourseAudit> changeList(Long courseId) {
        return courseAuditDAO.getCourseAuditsById(courseId);
    }
}
