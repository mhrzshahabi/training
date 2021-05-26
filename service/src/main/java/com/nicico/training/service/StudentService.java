package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.iservice.IStudentService;
import com.nicico.training.model.Student;
import com.nicico.training.repository.StudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class StudentService implements IStudentService {

    private final ModelMapper modelMapper;
    private final StudentDAO studentDAO;

    @Transactional(readOnly = true)
    @Override
    public StudentDTO.Info get(Long id) {
        final Optional<Student> gById = studentDAO.findById(id);
        final Student student = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
        return modelMapper.map(student, StudentDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Student getStudent(Long id) {
        final Optional<Student> gById = studentDAO.findById(id);
        return gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.StudentNotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public Student getStudentByPersonnelNo(String personnelNo) {
        final Optional<Student> student = studentDAO.findByPersonnelNo(personnelNo);
        return student.orElse(null);
    }

    @Transactional(readOnly = true)
    public List<Student> getStudentByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName) {
        List<Student> list = studentDAO.findByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(postId, personnelNo, depId, fName, lName);
        return list;
    }
    @Transactional(readOnly = true)
    public List<Student> getStudentByNationalCode(String nationalCode) {
        List<Student> list = studentDAO.findByNationalCode(nationalCode);
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<StudentDTO.Info> list() {
        final List<Student> gAll = studentDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<StudentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public StudentDTO.Info create(StudentDTO.Create request) {
        final Student student = modelMapper.map(request, Student.class);
        return save(student);
    }

    @Transactional
    @Override
    public StudentDTO.Info update(Long id, StudentDTO.Update request) {
        final Optional<Student> cById = studentDAO.findById(id);
        final Student student = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Student updating = new Student();
        modelMapper.map(student, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        studentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(StudentDTO.Delete request) {
        final List<Student> gAllById = studentDAO.findAllById(request.getIds());
        studentDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<StudentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(studentDAO, request, student -> modelMapper.map(student, StudentDTO.Info.class));
    }

    @Override
    public List<Student> getStudentList(List<Long> absentStudents) {
        List<Student>students=new ArrayList<>();
        for (Long id:absentStudents)
        {
            students.add(getStudent(id));
        }
        return students;
    }

    // ------------------------------

    private StudentDTO.Info save(Student student) {
        final Student saved = studentDAO.saveAndFlush(student);
        return modelMapper.map(saved, StudentDTO.Info.class);
    }

}
