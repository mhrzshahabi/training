package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.model.Student;
import response.tclass.ElsStudentAttendanceListResponse;

import java.util.List;

public interface IStudentService {

    StudentDTO.Info get(Long id);

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
}
