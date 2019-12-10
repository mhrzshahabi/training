package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

    private final ClassStudentDAO classStudentDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public ClassStudentDTO.Info get(Long id) {
        final Optional<ClassStudent> optionalStudent = classStudentDAO.findById(id);
        final ClassStudent ClassStudent = optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(ClassStudent, ClassStudentDTO.Info.class);
    }

    @Transactional
    @Override
    public List<ClassStudentDTO.Info> list() {
        List<ClassStudent> StudentList = classStudentDAO.findAll();
        return mapper.map(StudentList, new TypeToken<List<ClassStudentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ClassStudentDTO.Info create(ClassStudentDTO.Create request) {
        ClassStudent Student = mapper.map(request, ClassStudent.class);
        return mapper.map(classStudentDAO.saveAndFlush(Student), ClassStudentDTO.Info.class);
    }

    @Transactional
    @Override
    public ClassStudentDTO.Info update(Long id, ClassStudentDTO.Update request) {
        Optional<ClassStudent> optionalStudent = classStudentDAO.findById(id);
        ClassStudent currentCheckList = optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        ClassStudent classStudent = new ClassStudent();
        mapper.map(currentCheckList, classStudent);
        mapper.map(request, classStudent);
        return mapper.map(classStudentDAO.saveAndFlush(classStudent), ClassStudentDTO.Info.class);
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
    public SearchDTO.SearchRs<ClassStudentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classStudentDAO, request, scores -> mapper.map(scores, ClassStudentDTO.Info.class));
    }


}
