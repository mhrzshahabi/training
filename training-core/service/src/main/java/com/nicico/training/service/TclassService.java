package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.activiti.config.json.ResultSetConverter;
import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TclassService implements ITclassService {

    private final ModelMapper modelMapper;
    private final TclassDAO tclassDAO;
    private final StudentDAO studentDAO;

    @Autowired
    EntityManager entityManager;

    @Autowired
    ResultSetConverter resultSetConverter;

    @Transactional(readOnly = true)
    @Override
    public TclassDTO.Info get(Long id) {
        final Optional<Tclass> gById = tclassDAO.findById(id);
        final Tclass tclass = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));
        return modelMapper.map(tclass, TclassDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<TclassDTO.Info> list() {
        final List<Tclass> gAll = tclassDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<TclassDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public TclassDTO.Info create(TclassDTO.Create request) {
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        return save(tclass);
    }

    @Transactional
    @Override
    public TclassDTO.Info update(Long id, TclassDTO.Update request) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Tclass updating = new Tclass();
        modelMapper.map(tclass, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        tclassDAO.deleteById(id);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(tclassDAO, request, tclass -> modelMapper.map(tclass, TclassDTO.Info.class));
    }

    // ------------------------------

    private TclassDTO.Info save(Tclass tclass) {
        final Tclass saved = tclassDAO.saveAndFlush(tclass);
        return modelMapper.map(saved, TclassDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<StudentDTO.Info> getStudents(Long classID) {
        final Optional<Tclass> ssById = tclassDAO.findById(classID);
        final Tclass tclass = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));

        List<StudentDTO.Info> studentInfoSet = new ArrayList<>();
        Optional.ofNullable(tclass.getStudentSet())
                .ifPresent(students ->
                        students.forEach(student ->
                                studentInfoSet.add(modelMapper.map(student, StudentDTO.Info.class))
                        ));
        return studentInfoSet;
    }

    @Transactional(readOnly = true)
    @Override
    public List<StudentDTO.Info> getOtherStudents(Long classID) {
        final Optional<Tclass> ssById = tclassDAO.findById(classID);
        final Tclass tclass = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));

        List<Student> currentStudent = tclass.getStudentSet();
        List<Student> allStudent = studentDAO.findAll();
        List<Student> otherStudent = new ArrayList<>();

        for (Student student : allStudent) {
                if(!currentStudent.contains(student))
                    otherStudent.add(student);
        }

        List<StudentDTO.Info> studentInfoSet = new ArrayList<>();
        Optional.ofNullable(otherStudent)
                .ifPresent(students ->
                        students.forEach(student ->
                                studentInfoSet.add(modelMapper.map(student, StudentDTO.Info.class))
                        ));
        return studentInfoSet;
    }

    @Transactional
    @Override
    public void removeStudent (Long studentId,Long classId) {
        Tclass tclass = tclassDAO.getOne(classId);
        Student student = studentDAO.getOne(studentId);
        tclass.getStudentSet().remove(student);
    }

    @Transactional
    @Override
    public void addStudent (Long studentId,Long classId) {
        Tclass tclass = tclassDAO.getOne(classId);
        Student student = studentDAO.getOne(studentId);
        tclass.getStudentSet().add(student);
    }

    @Transactional
    @Override
    public void delete(TclassDTO.Delete request) {
        final List<Tclass> gAllById = tclassDAO.findAllById(request.getIds());
        tclassDAO.deleteAll(gAllById);
    }

    @Transactional
    @Override
    public void addStudents(StudentDTO.Delete request, Long classId) {
        Tclass tclass = tclassDAO.getOne(classId);
        List<Student> gAllById = studentDAO.findAllById(request.getIds());
        for (Student student : gAllById) {
            tclass.getStudentSet().add(student);
        }
    }


}
