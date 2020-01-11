package com.nicico.training.service;

import com.google.gson.JsonObject;
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
public class TClassStudentService implements ITClassStudentService {

    private final TClassStudentDAO TClassStudentDAO;
    private final ITclassService tclassService;
    private final IStudentService studentService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;
    private final TclassDAO tclassDAO;

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


//            Optional<Personnel> optionalPersonnel = personnelDAO.findOneByPersonnelNo(personnelId);
//            optionalPersonnel.ifPresent(personnel -> {
//                StudentDTO.Create create = modelMapper.map(personnel, StudentDTO.Create.class);
//                StudentDTO.Info info = studentService.create(modelMapper.map(personnel, StudentDTO.Create.class));
//                addStudent(info.getId(), classId);
//
//            });
        }

//        for (String personnelId : personsIds) {
//            Optional<PersonnelRegistered> optionalPersonnelReg = personnelRegisteredDAO.findOneByPersonnelNo(personnelId);
//            optionalPersonnelReg.ifPresent(personnel -> {
//                StudentDTO.Create create = modelMapper.map(personnel, StudentDTO.Create.class);
//                StudentDTO.Info info = studentService.create(modelMapper.map(personnel, StudentDTO.Create.class));
//                addStudent(info.getId(), classId);
//            });
//        }
//        List<Student> gAllById = studentDAO.findAllById(request.getIds());
////        for (Student student : gAllById) {
////            tclass.getStudentSet().add(student);
////        }
//        Tclass tclass = tclassDAO.getOne(classId);
//        Student student = studentDAO.getOne(studentId);
//        tclass.getStudentSet().add(student);

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

//    @Transactional(readOnly = true)
//    @Override
//    public TClassStudentDTO.Info get(Long id) {
//        final Optional<TClassStudent> optionalStudent = TClassStudentDAO.findById(id);
//        final TClassStudent ClassStudent = optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
//        return mapper.map(ClassStudent, TClassStudentDTO.Info.class);
//    }
//
//    @Transactional
//    @Override
//    public List<TClassStudentDTO.Info> list() {
//        List<TClassStudent> StudentList = TClassStudentDAO.findAll();
//        return mapper.map(StudentList, new TypeToken<List<TClassStudentDTO.Info>>() {
//        }.getType());
//    }
//
//    @Transactional
//    @Override
//    public TClassStudentDTO.Info create(TClassStudentDTO.Create request) {
//        TClassStudent Student = mapper.map(request, TClassStudent.class);
////        return mapper.map(TClassStudentDAO.saveAndFlush(Student), TClassStudentDTO.Info.class);
//        return null;
//    }
//

//
//    @Transactional
//    @Override
//    public void delete(Long id) {
//        TClassStudentDAO.deleteById(id);
//    }
//

    //
//    @Transactional
//    @Override
//    public SearchDTO.SearchRs<TClassStudentDTO.Info> search(SearchDTO.SearchRq request) {
//        return SearchUtil.search(TClassStudentDAO, request, scores -> mapper.map(scores, TClassStudentDTO.Info.class));
//    }
//
//    @Transactional(readOnly = true)
//    @Override
//    public List<TClassStudentDTO.Info> fillTable(Long id) {
//        int flag = 0;
//        List<TClassStudent> classStudentList = new ArrayList<>();
//
//
////        List<Long> class_student = TClassStudentDAO.getStudent(id);//لیست ای دی های دانش اموزان کلاس را میگیرد
////        List<Long> listR = TClassStudentDAO.getstudentIdRegister(id);//لیست ای دی های دانش اموزان موجود برای این کلاس که داخل جدول classStudent  است را می دهد
//
////        for (Long x : class_student) {
////            flag = 0;
////            for (Long y : listR) {
////                if (x == y) {
////                    flag = 1;
////                }
////            }
////            if (flag == 0) {
////                ClassStudent classStudent = new ClassStudent();
////                classStudent.setTclassId(id);
////                classStudent.setStudentId(x);
////
//////                TClassStudentDAO.saveAndFlush(classStudent);
////            }
////        }
//
////        List<ClassStudent> save = TClassStudentDAO.saveAll(classStudentList);
////        return mapper.map(save, new TypeToken<List<TClassStudentDTO.Info>>() {
////        }.getType());
//        return null;
//
//    }
//
//    @Transactional
//    @Override
//    public List<TClassStudentDTO.Info> getStudent(Long classId) {
//
////        List<ClassStudent> classStudentList = TClassStudentDAO.getAllByTclassId(classId);
////        return mapper.map(classStudentList, new TypeToken<List<TClassStudentDTO.Info>>() {
////        }.getType());
//        return null;
//    }
//
//    @Transactional
//    @Override
//    public TClassStudentDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException {
//        Long id = Long.parseLong(body.get("id").get(0));
//        TClassStudent classStudent = TClassStudentDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ClassCheckListNotFound));
//        Set<String> strings = body.keySet();
//
//        if (strings.contains("scoresState")) {
//            String scoresState = body.get("scoresState").get(0);
//            classStudent.setScoresState(scoresState);
//        }
//
//        if (strings.contains("score")) {
//            String score = body.get("score").get(0);
//            classStudent.setScore(Float.valueOf(score));
//        }
//
//        TClassStudentDTO.Info update = update(id, mapper.map(classStudent, TClassStudentDTO.Update.class));
//        return mapper.map(classStudent, TClassStudentDTO.Info.class);
//    }
//
//
//    @Transactional(readOnly = true)
//    @Override
//    public SearchDTO.SearchRs<TClassStudentDTO.TClassStudentInfo> searchClassStudents(SearchDTO.SearchRq request, Long classId) {
//        request = (request != null) ? request : new SearchDTO.SearchRq();
//        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
//        if (classId != null) {
//            list.add(makeNewCriteria("tclassId", classId, EOperator.equals, null));
//            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
//            if (request.getCriteria() != null) {
//                if (request.getCriteria().getCriteria() != null)
//                    request.getCriteria().getCriteria().add(criteriaRq);
//                else
//                    request.getCriteria().setCriteria(list);
//            } else
//                request.setCriteria(criteriaRq);
//        }
//        return SearchUtil.search(TClassStudentDAO, request, classStudent -> mapper.map(classStudent, TClassStudentDTO.TClassStudentInfo.class));
//    }
//
    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }
//
//     @Transactional
//     @Override
//    public void add(Long classID, Long studentID) {
//       JsonObject request = new JsonObject();
//        request.addProperty("tclassId", classID);
//        request.addProperty("studentId", studentID);
//         TClassStudent classStudent=new TClassStudent();
//         classStudent.setStudentId(studentID);
//         classStudent.setTclassId(classID);
//        // ClassStudent Student = mapper.map(request, ClassStudent.class);
////           TClassStudentDAO.save(classStudent);
//    }

}
