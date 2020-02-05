package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.model.Course;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class ClassStudentReportService {

    private final ClassStudentDAO classStudentDAO;

    @Transactional(readOnly = true)
//    @Override
    public List<Course> searchCoursesOfStudentByNationalCode(String nationalCode) {
        if (nationalCode != null) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null);
            return classStudentDAO.findAll(NICICOSpecification.of(criteria)).stream().map(classStudent -> classStudent.getTclass().getCourse()).collect(Collectors.toList());
        }
        return null;
    }
}
