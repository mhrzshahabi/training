package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;

import java.util.List;

public interface IClassStudentService {

    ClassStudentDTO.Info get(Long id);


    List<ClassStudentDTO.Info> list();


    ClassStudentDTO.Info create(ClassStudentDTO.Create request);


    ClassStudentDTO.Info update(Long id, ClassStudentDTO.Update request);


    void delete(Long id);


    void delete(ClassStudentDTO.Delete request);

    SearchDTO.SearchRs<ClassStudentDTO.Info> search(SearchDTO.SearchRq request);
}
