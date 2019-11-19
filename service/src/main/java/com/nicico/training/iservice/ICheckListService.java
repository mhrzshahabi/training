package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CheckListDTO;
import com.nicico.training.dto.CheckListItemDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ICheckListService {

    CheckListDTO.Info get(Long id);


    List<CheckListDTO.Info> list();

    CheckListDTO.Info create(CheckListDTO.Create request);


    CheckListDTO.Info update(Long id, CheckListDTO.Update request);


    void delete(Long id);


    void delete(CheckListDTO.Delete request);


    SearchDTO.SearchRs<CheckListDTO.Info> search(SearchDTO.SearchRq request);

    List<CheckListItemDTO.Info> getCheckListItem(Long CheckListId);

    boolean checkForDelete(Long checkListId);

    @Transactional
    List<CheckListDTO.Info> getCheckList(Long id);
}
