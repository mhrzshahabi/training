package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.iservice.IEvaluationAnalysisService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassStudentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

    private final ClassStudentDAO classStudentDAO;
    private final AttendanceDAO attendanceDAO;
    private final ITclassService tclassService;
    private final StudentService studentService;
//    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private final ViewActivePersonnelService activePersonnelService;



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
    public Map<String, String> registerStudents(List<ClassStudentDTO.Create> request, Long classId) {
        List<String> invalStudents = new ArrayList<>();
        Tclass tclass = tclassService.getTClass(classId);

        for (ClassStudentDTO.Create c : request) {
            List<Student> list = studentService.getStudentByPostCodeAndPersonnelNoAndDepartmentCodeAndFirstNameAndLastName(c.getPostCode(), c.getPersonnelNo(), c.getDepartmentCode(), c.getFirstName(), c.getLastName());
            Student student = null;
            int size = list.size();
            for (int i=0; i<size; i++) {
                if(Objects.equals(1, list.get(i).getActive())){
                    student = list.get(i);
                    break;
                }
                if(i==size-1) {
                    student = list.get(i);
                }
            }
            if(student == null) {
                student = new Student();
                if (c.getRegisterTypeId() == 1) {
                    mapper.map(activePersonnelService.getByPersonnelCode(c.getPersonnelNo()), student);
                    student.setDeleted(null);
                } else if (c.getRegisterTypeId() == 2) {
                    mapper.map(personnelRegisteredService.getByPersonnelCode(c.getPersonnelNo()), student);
                }

                /*SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
//                SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
                SearchDTO.CriteriaRq rq = makeNewCriteria("nationalCode", student.getNationalCode(), EOperator.equals, null);
                SearchDTO.SearchRs<StudentDTO.Info> search = studentService.search(searchRq.setCriteria(rq));
                List<StudentDTO.Info> studentsByNationalCode = search.getList();*/
                List<Student> studentByNationalCode = studentService.getStudentByNationalCode(student.getNationalCode());

                for (Student student1 : studentByNationalCode) {
                    student1.setActive(0);
                }

            }
            ClassStudent classStudent = new ClassStudent();
            if(c.getApplicantCompanyName() != null)
                classStudent.setApplicantCompanyName(c.getApplicantCompanyName());
            else {
                invalStudents.add(student.getFirstName()+ " " + student.getLastName());
                continue;
            }
            if(c.getPresenceTypeId() != null)
                classStudent.setPresenceTypeId(c.getPresenceTypeId());
            classStudent.setTclass(tclass);
            classStudent.setStudent(student);
            classStudentDAO.saveAndFlush(classStudent);
        }
        String nameList = new String();
        if(invalStudents.size() > 0) {
            for (String name : invalStudents) {
                nameList += name + " , ";
            }
        }else
            nameList = null;
        Map<String, String> map = new HashMap();
        map.put("names", nameList);
        map.put("accepted", new Integer(request.size() - invalStudents.size()).toString());
        return map;
    }

    @Transactional
    @Override
    public void saveOrUpdate(ClassStudent classStudent) {
        ClassStudent tclass = classStudentDAO.save(classStudent);
        evaluationAnalysisService.updateLearningEvaluation(tclass.getTclassId(),tclass.getTclass().getScoringMethod());
    }

    @Transactional
    @Override
    public String delete(Long id) {

        ClassStudent classSession = classStudentDAO.getClassStudentById(id);
        if (attendanceDAO.checkAttendanceByStudentIdAndClassId(classSession.getStudentId(), classSession.getTclassId()) > 0) {
            return "فراگير «<b>" + classSession.getStudent().getFirstName() + " " + classSession.getStudent().getLastName() + "</b>» بدلیل داشتن حضور و غیاب قابل حذف نیست.";
        } else {
            classStudentDAO.deleteById(id);
            return "";
        }

    }

    @Transactional
    @Override
    public void delete(ClassStudentDTO.Delete request) {
        final List<ClassStudent> studentList = classStudentDAO.findAllById(request.getIds());
        classStudentDAO.deleteAll(studentList);
    }

    @Transactional
    @Override
    public int setStudentFormIssuance(Map<String, String> formIssuance) {
        Long classId = Long.parseLong(formIssuance.get("idClassStudent").toString());
        if(formIssuance.get("evaluationAudienceType") != null)
            classStudentDAO.setStudentFormIssuanceAudienceType(classId,Long.parseLong(formIssuance.get("evaluationAudienceType")));
        if(formIssuance.get("evaluationAudienceId") != null)
            classStudentDAO.setStudentFormIssuanceAudienceId(classId,Long.parseLong(formIssuance.get("evaluationAudienceId")));
        return classStudentDAO.setStudentFormIssuance(classId, Integer.parseInt(formIssuance.get("reaction")), Integer.parseInt(formIssuance.get("learning")), Integer.parseInt(formIssuance.get("behavior")), Integer.parseInt(formIssuance.get("results")));
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

    @Transactional
    public Long getClassIdByClassStudentId(Long classStudentId) {
        ClassStudent classSession = classStudentDAO.getClassStudentById(classStudentId);
        return classSession.getTclassId();
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchEvaluationAnalysistLearning(SearchDTO.SearchRq request, Long classId) {
        Tclass tClass = tclassService.getTClass(classId);
        SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> result =  SearchUtil.search(classStudentDAO, request,classStudent -> mapper.map(classStudent,
                ClassStudentDTO.evaluationAnalysistLearning.class));
        for (ClassStudentDTO.evaluationAnalysistLearning t : result.getList()) {
            if(tClass.getScoringMethod() != null && tClass.getScoringMethod().equalsIgnoreCase("3")){
                if(t.getScore() != null)
                    t.setScore(t.getScore()*5);
            }
        }
        return result;
    }

    @Transactional
    public void setPeresenceTypeId(Long peresenceTypeId, Long id) {
        classStudentDAO.setPeresenceTypeId(peresenceTypeId, id);
    }

}
