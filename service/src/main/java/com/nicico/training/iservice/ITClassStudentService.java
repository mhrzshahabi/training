package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TClassStudentDTO;
import com.nicico.training.model.TClassStudent;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.List;

public interface ITClassStudentService {

    TClassStudent getTClassStudent(Long id);

    SearchDTO.SearchRs<TClassStudentDTO.TClassStudentInfo> searchClassStudents(SearchDTO.SearchRq request, Long classId);

    void registerStudents(List<TClassStudentDTO.Create> request, Long classId);

    TClassStudentDTO.TClassStudentInfo update(Long id, TClassStudentDTO.Update request);

    void delete(Long id);

    void delete(TClassStudentDTO.Delete request);

//    TClassStudentDTO.Info get(Long id);
//
//
//    List<TClassStudentDTO.Info> list();
//
//
//    TClassStudentDTO.Info create(TClassStudentDTO.Create request);
//
//

//
//
//    void delete(Long id);
//
//

//
//    SearchDTO.SearchRs<TClassStudentDTO.Info> search(SearchDTO.SearchRq request);
//
//
//    List<TClassStudentDTO.Info> fillTable(Long id);
//
//
//    List<TClassStudentDTO.Info> getStudent(Long classId);
//
//
//    TClassStudentDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException;
//

//
//
//    void add(Long classID, Long studentID);
}
