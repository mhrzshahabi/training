package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IClassStudentReportService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Course;
import com.nicico.training.model.EqualCourse;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class ClassStudentReportService implements IClassStudentReportService {

    private final ClassStudentDAO classStudentDAO;

    @Transactional(readOnly = true)
//    @Override
    public List<ClassStudent> searchPassedCoursesOfStudentByNationalCode(String nationalCode) {
        if (nationalCode != null) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteria.getCriteria().add(makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null));
            criteria.getCriteria().add(makeNewCriteria("scoresState", Arrays.asList(400L, 401L), EOperator.equals, null));
            return classStudentDAO.findAll(NICICOSpecification.of(criteria));
        }
        return null;
    }

    @Transactional(readOnly = true)
//    @Override
    public Set<Long> getPassedCoursesIdsOfStudentByNationalCode(String nationalCode) {
        if (nationalCode == null)
            return null;
        return searchPassedCoursesOfStudentByNationalCode(nationalCode).stream().map(classStudent -> classStudent.getTclass().getCourse().getId()).collect(Collectors.toSet());

    }

    @Transactional(readOnly = true)
    public List<ClassStudent> searchClassRegisterOfStudentByNationalCode(String nationalCode) {
        if (nationalCode != null) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteria.getCriteria().add(makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null));
            return classStudentDAO.findAll(NICICOSpecification.of(criteria));
        }
        return null;
    }


    @Transactional(readOnly = true)
//    @Override
    public Set<Long> getPassedCourseAndEQSIdsByNationalCode(String nationalCode) {
        List<Course> passedCourses = searchPassedCoursesOfStudentByNationalCode(nationalCode).stream().map(classStudent -> classStudent.getTclass().getCourse()).collect(Collectors.toList());
        Set<Long> equalCourseIds = new HashSet<>();
        for (Course course : passedCourses) {
            getEqualCourseIds(course, equalCourseIds);
        }
        return equalCourseIds;
    }

    private void getEqualCourseIds(Course course, Set<Long> equalCourseIds) {
        if (equalCourseIds.contains(course.getId()))
            return;
        equalCourseIds.add(course.getId());
        for (EqualCourse equalCourses : course.getEqualCourses()) {
            for (Course eqCourse : equalCourses.getEqualAndList())
                getEqualCourseIds(eqCourse, equalCourseIds);
        }
    }


    @Transactional(readOnly = true)
//    @Override
    public Boolean isPassed(Course course, Map<Long, Boolean> isPassed) {
        if (isPassed.containsKey(course.getId()))
            return isPassed.get(course.getId());
        isPassed.put(course.getId(), false);
        Boolean result = course.getEqualCourses().stream().anyMatch
                (eq -> eq.getEqualAndList().stream().allMatch
                        (aId -> isPassed(aId, isPassed)));
        if (result)
            isPassed.replace(course.getId(), true);
        return result;
    }

    @Transactional(readOnly = true)
//    @Override
    public Boolean isPassed(Course course, String nationalCode) {
        Set<Long> passedCourseIds = getPassedCoursesIdsOfStudentByNationalCode(nationalCode);
        Map<Long, Boolean> Passed = passedCourseIds.stream().collect(Collectors.toMap(id -> id, id -> true));
        return isPassed(course, Passed);
    }
}
