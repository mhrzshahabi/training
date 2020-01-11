package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;

import java.util.List;

public interface IClassStudentService {

    ClassStudent getClassStudent(Long id);

    <T> SearchDTO.SearchRs<T> searchClassStudents(SearchDTO.SearchRq request, Long classId, Class<T> infoType);

    void registerStudents(List<ClassStudentDTO.Create> request, Long classId);

    <E> ClassStudentDTO.ClassStudentInfo update(Long id, E request);

    void delete(Long id);

    void delete(ClassStudentDTO.Delete request);

}
