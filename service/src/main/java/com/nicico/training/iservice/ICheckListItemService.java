package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CheckListItemDTO;

import java.io.IOException;
import java.util.List;

public interface ICheckListItemService {

    CheckListItemDTO.Info get(Long id);


    List<CheckListItemDTO.Info> list();


    CheckListItemDTO.Info create(CheckListItemDTO.Create request);

    CheckListItemDTO.Info update(Long id, CheckListItemDTO.Update request);


    void delete(Long id);


    void delete(CheckListItemDTO.Delete request);


    SearchDTO.SearchRs<CheckListItemDTO.Info> search(SearchDTO.SearchRq request);


    CheckListItemDTO.Info updateDescription(Long id, CheckListItemDTO.Update request) throws IOException;


    CheckListItemDTO.Info is_Delete(Long id, CheckListItemDTO.Update request);







}
