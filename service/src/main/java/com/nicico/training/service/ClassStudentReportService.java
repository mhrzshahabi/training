package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Course;
import com.nicico.training.model.EqualCourse;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.CourseDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class ClassStudentReportService {

    private final ClassStudentDAO classStudentDAO;
    private final CourseDAO courseDAO;

    @Transactional(readOnly = true)
//    @Override
    public List<ClassStudent> searchCoursesOfStudentByNationalCode(String nationalCode) {
        if (nationalCode != null) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null);
            return classStudentDAO.findAll(NICICOSpecification.of(criteria));
        }
        return null;
    }

    @Transactional(readOnly = true)
//    @Override
    public Set<Long> getPassedCourseAndEQSIdsByNationalCode(String nationalCode) {
        List<Course> passedCourses = searchCoursesOfStudentByNationalCode(nationalCode).stream().map(classStudent -> classStudent.getTclass().getCourse()).collect(Collectors.toList());
        Set<Long> courseIds = passedCourses.stream().map(Course::getId).collect(Collectors.toSet());
        for (Course course : passedCourses) {
            for (EqualCourse equalCourse : course.getEqualCourses()) {
                courseIds.addAll(equalCourse.getEqualAndList());
            }
        }
        return courseIds;
    }

    @Transactional(readOnly = true)
//    @Override
    public Boolean isPassedCoursesOfStudentByNationalCode(Course isPassed, Set<Long> passedCourseIds) {

        if (passedCourseIds.contains(isPassed.getId()))
            return true;

        return isPassed.getEqualCourses().stream().anyMatch
                (eq -> eq.getEqualAndList().stream().allMatch
                        (aId -> isPassedCoursesOfStudentByNationalCode(courseDAO.getOne(aId), passedCourseIds)));
    }
}
