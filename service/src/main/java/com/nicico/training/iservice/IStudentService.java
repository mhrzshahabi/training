package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.enums.ExamsType;
import com.nicico.training.model.Student;
import org.springframework.data.domain.Page;
import response.tclass.ElsStudentAttendanceListResponse;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

public interface IStudentService {

    StudentDTO.Info get(Long id);

    Optional<Student> getOptional(Long id);

    StudentDTO.ClassStudentInfo getLastStudentByNationalCode(String nationalCode);

    Student getStudent(Long id);

    Student getStudentByPersonnelNo(String personnelNo);

    List<StudentDTO.Info> list();

    StudentDTO.Info create(StudentDTO.Create request);

    StudentDTO.Info update(Long id, StudentDTO.Update request);

    void delete(Long id);

    void delete(StudentDTO.Delete request);

    SearchDTO.SearchRs<StudentDTO.Info> search(SearchDTO.SearchRq request);

    List<Student> getStudentList(List<Long> absentStudents);

    ElsStudentAttendanceListResponse getStudentAttendanceList(String classCode, String nationalCode);

    List<Map<String, Object>> findAllExamsByNationalCode(String nationalCode, ExamsType type);

    Set<String> findAllRoleByNationalCode(String nationalCode);

    List<Student> getStudentByNationalCode(String nationalCode);

    StudentDTO.PreparationInfo getStudentPreparationInfoByNationalCode(String nationalCode);

    void updateHasPreparationTestByNationalCodes(List<String> nationalCodes, boolean hasPreparation);

    Page<Student> getAllActiveStudents(Integer page, Integer size);

    List<Student> getAllStudentsOfClassByClassCode(String classCode);

    List<Long> findOneClassByNationalCodeInClass(String nationalCode, Long classId);

    StudentDTO.TrainingCertificationDetail getTrainingCertificationDetail(String nationalCode, Long classId);

    void changeContactInfo(List<Long> id);

    List<?> getAllStudentsOfExam(Long testQuestionId);

    StudentDTO.Info update(Long id, StudentDTO.UpdateForSyncData request);

    List<Student> getStudentByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName);

    List<Student> getTestStudentList();

    StudentDTO.Info save(Student student);
}
