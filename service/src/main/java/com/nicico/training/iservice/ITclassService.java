package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ITclassService {

    @Transactional
    void addStudents(Long classId, List<String> personsIds);

    TclassDTO.Info get(Long id);

    List<TclassDTO.Info> list();

    TclassDTO.Info create(TclassDTO.Create request);

    TclassDTO.Info update(Long id, TclassDTO.Update request);

    void delete(Long id);

    void delete(TclassDTO.Delete request);

    SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request);

    List<StudentDTO.Info> getStudents(Long classID);

    List<StudentDTO.Info> getOtherStudents(Long classID);

    void removeStudent(Long studentId,Long classId);

    void addStudent(Long studentId,Long classId);

    void addStudents(StudentDTO.Delete  request, Long classId);

    @Transactional
    Long getEndGroup(Long courseId, Long termId);
}
