package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IClassStudentService {

    ClassStudent getClassStudent(Long id);

    <T> SearchDTO.SearchRs<T> searchClassStudents(SearchDTO.SearchRq request, Long classId, Class<T> infoType);

    void registerStudents(List<ClassStudentDTO.Create> request, Long classId);

    <E, T> T update(Long id, E request, Class<T> infoType);

    void delete(Long id);

    void delete(ClassStudentDTO.Delete request);

}
