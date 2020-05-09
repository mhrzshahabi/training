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

import java.util.*;
import java.util.function.Function;

import static com.nicico.training.service.BaseService.makeNewCriteria;

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
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(classStudentDAO, request, converter);
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
            if(create.getApplicantCompanyName() != null)
                classStudent.setApplicantCompanyName(create.getApplicantCompanyName());
            if(create.getPresenceTypeId() != null)
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

    @Transactional
    @Override
    public int setStudentFormIssuance(Map<String, Integer> formIssuance) {
        return classStudentDAO.setStudentFormIssuance(Long.parseLong(formIssuance.get("idClassStudent").toString()), formIssuance.get("reaction"), formIssuance.get("learning"), formIssuance.get("behavior"), formIssuance.get("results"));
    }

    @Transactional
    @Override
    public void setTotalStudentWithOutScore(Long classId) {
        classStudentDAO.setTotalStudentWithOutScore(classId);
    }

    @Transactional
    @Override
    public List<Long> getScoreState(Long classId) {
        return classStudentDAO.getScoreState(classId);
    }

    @Transactional
    public ClassStudent findByClassIdAndStudentId(Long classId, Long studentId) {
        return classStudentDAO.findByTclassIdAndStudentId(classId, studentId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

    }

    //*********************************
    @Transactional
    public Long getClassIdByClassStudentId(Long classStudentId) {
        ClassStudent classSession = classStudentDAO.getClassStudentById(classStudentId);
        return classSession.getTclassId();
    }
}
