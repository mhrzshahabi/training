package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassCheckListDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.model.ClassCheckList;
import com.nicico.training.model.ClassStudent;

import com.nicico.training.model.Tclass;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

  private final ClassStudentDAO classStudentDAO;
    private final ModelMapper mapper;
    private final TclassDAO tclassDAO;

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

    @Transactional(readOnly = true)
    @Override
    public List<ClassStudentDTO.Info> fillTable(Long id) {
           int flag=0;
          List<ClassStudent> classStudentList = new ArrayList<>();


          List <Long> class_student = classStudentDAO.getStudent(id);//لیست ای دی های دانش اموزان کلاس را میگیرد
          List<Long> listR=classStudentDAO.getstudentIdRegister(id);//لیست ای دی های دانش اموزان موجود برای این کلاس که داخل جدول classStudent  است را می دهد

        for (Long x:class_student) {
                 flag=0;
            for (Long y:listR) {
                if(x==y)
                {
                flag=1;
                }
            }
            if(flag ==0)
            {
             ClassStudent classStudent=new ClassStudent();
            classStudent.setTclassId(id);
            classStudent.setStudentId(x);

         classStudentDAO.saveAndFlush(classStudent);
            }
        }

           List<ClassStudent> save = classStudentDAO.saveAll(classStudentList);
           return mapper.map(save, new TypeToken<List<ClassStudentDTO.Info>>() {}.getType());

         }

    @Transactional
    @Override
    public List<ClassStudentDTO.Info> getStudent(Long classId) {

        List<ClassStudent> classStudentList=classStudentDAO.getAllByTclassId(classId);
        return mapper.map(classStudentList, new TypeToken<List<ClassStudentDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ClassStudentDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException {
        Long id = Long.parseLong(body.get("id").get(0));
        ClassStudent classStudent = classStudentDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ClassCheckListNotFound));
        Set<String> strings = body.keySet();

            if (strings.contains("scoresState")) {
            String scoresState = body.get("scoresState").get(0);
            classStudent.setScoresState(scoresState);
        }

        if (strings.contains("score")) {
            String score = body.get("score").get(0);
            classStudent.setScore(Float.valueOf(score));
        }

        ClassStudentDTO.Info update = update(id, mapper.map(classStudent, ClassStudentDTO.Update.class));
        return mapper.map(classStudent, ClassStudentDTO.Info.class);
    }


}
