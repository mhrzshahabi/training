package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.modelmapper.TypeToken;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

    private final ClassStudentDAO classStudentDAO;
    private final ITclassService tclassService;
    private final IStudentService studentService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;


    @Transactional(readOnly = true)
    @Override
    public ClassStudent getClassStudent(Long id) {
        Optional<ClassStudent> optionalStudent = classStudentDAO.findById(id);
        return optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public List<ClassStudentDTO.ClassStudentInfo> getClassesOfStudent(Long id) {
        List<ClassStudent> classStudentList = classStudentDAO.findByStudentId(id);
        return new ModelMapper().map(classStudentList, new TypeToken<List<ClassStudentDTO.CoursesOfStudent>>(){}.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> searchClassesOfStudent(SearchDTO.SearchRq request, String nationalCode, Class<T> infoType) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (nationalCode != null) {
            list.add(makeNewCriteria("student.nationalCode", nationalCode, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(classStudentDAO, request, e -> mapper.map(e, infoType));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> searchClassStudents(SearchDTO.SearchRq request, Long classId, Class<T> infoType) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (classId != null) {
            list.add(makeNewCriteria("tclassId", classId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(classStudentDAO, request, e -> mapper.map(e, infoType));
    }

    @Transactional
    @Override
    public void registerStudents(List<ClassStudentDTO.Create> request, Long classId) {

        Tclass tclass = tclassService.getTClass(classId);

        for (ClassStudentDTO.Create create : request) {

            Student student = studentService.getStudentByPersonnelNo(create.getPersonnelNo());
            if (student == null) {
                student = new Student();
                if (create.getRegisterTypeId() == 1) {
                    mapper.map(personnelService.getByPersonnelCode(create.getPersonnelNo()), student);
                } else if (create.getRegisterTypeId() == 2) {
                    mapper.map(personnelRegisteredService.getByPersonnelCode(create.getPersonnelNo()), student);
                }
            }

            ClassStudent classStudent = new ClassStudent();
            classStudent.setApplicantCompanyName(create.getApplicantCompanyName());
            classStudent.setPresenceTypeId(create.getPresenceTypeId());
            classStudent.setTclass(tclass);
            classStudent.setStudent(student);

            classStudentDAO.saveAndFlush(classStudent);
        }
    }

    @Transactional
    @Override
    public <E, T> T update(Long id, E request, Class<T> infoType) {
        ClassStudent classStudent = getClassStudent(id);
        ClassStudent updating = new ClassStudent();
        mapper.map(classStudent, updating);
        mapper.map(request, updating);
        return mapper.map(classStudentDAO.saveAndFlush(updating), infoType);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        classStudentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(ClassStudentDTO.Delete request) {
        final List<ClassStudent> studentList = classStudentDAO.findAllById(request.getIds());
        classStudentDAO.deleteAll(studentList);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    @Transactional
    @Override
    public int setStudentFormIssuance(Map<String, Integer> formIssuance) {
        return classStudentDAO.setStudentFormIssuance(Long.parseLong(formIssuance.get("idClassStudent").toString()), formIssuance.get("reaction"), formIssuance.get("learning"), formIssuance.get("behavior"), formIssuance.get("results"));
    }

    @Transactional
    @Override
    public void setTotalStudentWithOutScore(Long classId)
     {
      classStudentDAO.setTotalStudentWithOutScore(classId);
     }

     @Transactional
     @Override
     public List<Long> getScoreState(Long classId)
     {
        final List<Long> classStudentList=classStudentDAO.getScoreState(classId);
         return classStudentList;

     }
}
