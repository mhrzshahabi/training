package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;

import java.util.List;

public interface IClassStudentService {

    ClassStudent getTClassStudent(Long id);

    SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchClassStudents(SearchDTO.SearchRq request, Long classId);

    void registerStudents(List<ClassStudentDTO.Create> request, Long classId);

    ClassStudentDTO.ClassStudentInfo update(Long id, ClassStudentDTO.Update request);

    void delete(Long id);

    void delete(ClassStudentDTO.Delete request);

}
