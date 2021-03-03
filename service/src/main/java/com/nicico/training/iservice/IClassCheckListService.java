package com.nicico.training.iservice;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassCheckListDTO;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.List;

public interface IClassCheckListService {

    ClassCheckListDTO.Info get(Long id);


    List<ClassCheckListDTO.Info> list();


    ClassCheckListDTO.Info create(ClassCheckListDTO.Create request);


    ClassCheckListDTO.Info update(Long id, ClassCheckListDTO.Update request);


    void delete(Long id);


    void delete(ClassCheckListDTO.Delete request);


    SearchDTO.SearchRs<ClassCheckListDTO.Info> search(SearchDTO.SearchRq request);

    List<ClassCheckListDTO.Info> fillTable(Long classId, Long checklist_id);

    TotalResponse<ClassCheckListDTO.Info> newSearch(MultiValueMap criteria);


    ClassCheckListDTO.Info updateDescription(Long id, ClassCheckListDTO.Update request) throws IOException;



    ClassCheckListDTO.Info updateDescription2(ClassCheckListDTO.Info request) throws IOException;

    ClassCheckListDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException;

    void deleteByClassIdAndCheckListId(Long classId, Long checkListId);


}
