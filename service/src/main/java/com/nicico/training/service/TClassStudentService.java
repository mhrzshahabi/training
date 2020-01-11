package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TClassStudentDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.Student;
import com.nicico.training.model.TClassStudent;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.TClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TClassStudentService implements ITClassStudentService {

    private final TClassStudentDAO TClassStudentDAO;
    private final ITclassService tclassService;
    private final IStudentService studentService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public TClassStudent getTClassStudent(Long id) {
        Optional<TClassStudent> optionalStudent = TClassStudentDAO.findById(id);
        return optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TClassStudentDTO.TClassStudentInfo> searchClassStudents(SearchDTO.SearchRq request, Long classId) {
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
        return SearchUtil.search(TClassStudentDAO, request, classStudent -> mapper.map(classStudent, TClassStudentDTO.TClassStudentInfo.class));
    }

    @Transactional
    @Override
    public void registerStudents(List<TClassStudentDTO.Create> request, Long classId) {

        Tclass tclass = tclassService.getTClass(classId);

        for (TClassStudentDTO.Create create : request) {

            Student student = studentService.getStudentByPersonnelNo(create.getPersonnelNo());
            if (student == null) {
                student = new Student();
                if (create.getRegisterTypeId() == 1) {
                    mapper.map(personnelService.getByPersonnelCode(create.getPersonnelNo()), student);
                } else if (create.getRegisterTypeId() == 2) {
                    mapper.map(personnelRegisteredService.getByPersonnelCode(create.getPersonnelNo()), student);
                }
            }

            TClassStudent tClassStudent = new TClassStudent();
            tClassStudent.setApplicantCompanyName(create.getApplicantCompanyName());
            tClassStudent.setPresenceTypeId(create.getPresenceTypeId());
            tClassStudent.setTclass(tclass);
            tClassStudent.setStudent(student);

            TClassStudentDAO.saveAndFlush(tClassStudent);
        }
    }

    @Transactional
    @Override
    public TClassStudentDTO.TClassStudentInfo update(Long id, TClassStudentDTO.Update request) {
        TClassStudent tClassStudent = getTClassStudent(id);
        TClassStudent updating = new TClassStudent();
        mapper.map(tClassStudent, updating);
        mapper.map(request, updating);
        return mapper.map(TClassStudentDAO.saveAndFlush(updating), TClassStudentDTO.TClassStudentInfo.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        TClassStudentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(TClassStudentDTO.Delete request) {
        final List<TClassStudent> studentList = TClassStudentDAO.findAllById(request.getIds());
        TClassStudentDAO.deleteAll(studentList);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

}
