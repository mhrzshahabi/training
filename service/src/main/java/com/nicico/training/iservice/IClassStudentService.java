package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.List;

public interface IClassStudentService {

    ClassStudentDTO.Info get(Long id);


    List<ClassStudentDTO.Info> list();


    ClassStudentDTO.Info create(ClassStudentDTO.Create request);


    ClassStudentDTO.Info update(Long id, ClassStudentDTO.Update request);


    void delete(Long id);


    void delete(ClassStudentDTO.Delete request);

    SearchDTO.SearchRs<ClassStudentDTO.Info> search(SearchDTO.SearchRq request);





    List<ClassStudentDTO.Info> fillTable(Long id);


    List<ClassStudentDTO.Info> getStudent(Long classId);


    ClassStudentDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException;

    SearchDTO.SearchRs<ClassStudentDTO.Info> search1(SearchDTO.SearchRq request, Long classId);


    void add(Long classID, Long studentID);
}
