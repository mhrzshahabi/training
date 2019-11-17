package com.nicico.training.service;
/* com.nicico.training.service
@Author:roya
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.TrainingPlace;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.repository.TrainingPlaceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class TclassService implements ITclassService {

    private final ModelMapper modelMapper;
    private final TclassDAO tclassDAO;
    private final StudentDAO studentDAO;
    private final TeacherDAO teacherDAO;
    private final TrainingPlaceDAO trainingPlaceDAO;

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
        List<Long> list = request.getTrainingPlaceIds();
        List<TrainingPlace> allById = trainingPlaceDAO.findAllById(list);
        Set<TrainingPlace> set = new HashSet<>(allById);
        final Tclass tclass = modelMapper.map(request, Tclass.class);
        tclass.setTrainingPlaceSet(set);
//        TclassDTO.Info tclass = modelMapper.map(request, TclassDTO.Info.class);
        return save(tclass);
    }

    @Transactional
    @Override
    public TclassDTO.Info update(Long id, TclassDTO.Update request) {
        final Optional<Tclass> cById = tclassDAO.findById(id);
        final Tclass tclass = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        List<Long> trainingPlaceIds = request.getTrainingPlaceIds();
        List<TrainingPlace> allById = trainingPlaceDAO.findAllById(trainingPlaceIds);
        Set<TrainingPlace> set = new HashSet<>(allById);
        Tclass updating = new Tclass();
//        request.setTrainingPlaceSet(null);
        modelMapper.map(tclass, updating);
        modelMapper.map(request, updating);
        updating.setTrainingPlaceSet(set);
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
            if (!currentStudent.contains(student))
                otherStudent.add(student);
        }

        List<StudentDTO.Info> studentInfoSet = new ArrayList<>();
        Optional.of(otherStudent)
                .ifPresent(students ->
                        students.forEach(student ->
                                studentInfoSet.add(modelMapper.map(student, StudentDTO.Info.class))
                        ));
        return studentInfoSet;
    }

    @Transactional
    @Override
    public void removeStudent(Long studentId, Long classId) {
        Tclass tclass = tclassDAO.getOne(classId);
        Student student = studentDAO.getOne(studentId);
        tclass.getStudentSet().remove(student);
    }

    @Transactional
    @Override
    public void addStudent(Long studentId, Long classId) {
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


    @Transactional
    @Override
    public Long getEndGroup(Long courseId, Long termId) {
        List<Tclass> classes = tclassDAO.findByCourseIdAndTermId(courseId, termId);
        Long max = 0L;
        for (Tclass aClass : classes) {
            if(aClass.getGroup()>max){
                max= aClass.getGroup();
            }
        }
        return max+1;
    }


}
