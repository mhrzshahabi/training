package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TClassStudentDTO;
import com.nicico.training.model.TClassStudent;

import java.util.List;

public interface ITClassStudentService {

    TClassStudent getTClassStudent(Long id);

    SearchDTO.SearchRs<TClassStudentDTO.TClassStudentInfo> searchClassStudents(SearchDTO.SearchRq request, Long classId);

    void registerStudents(List<TClassStudentDTO.Create> request, Long classId);

    TClassStudentDTO.TClassStudentInfo update(Long id, TClassStudentDTO.Update request);

    void delete(Long id);

    void delete(TClassStudentDTO.Delete request);

}
