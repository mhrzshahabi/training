package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CheckListItemDTO;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.List;

public interface ICheckListItemService {
    @Transactional(readOnly = true)
    CheckListItemDTO.Info get(Long id);

    @Transactional
    List<CheckListItemDTO.Info> list();

    @Transactional
    CheckListItemDTO.Info create(CheckListItemDTO.Create request);

    @Transactional
    CheckListItemDTO.Info update(Long id, CheckListItemDTO.Update request);

    @Transactional
    void delete(Long id);

    @Transactional
    void delete(CheckListItemDTO.Delete request);

    @Transactional
    SearchDTO.SearchRs<CheckListItemDTO.Info> search(SearchDTO.SearchRq request);

    @Transactional
    CheckListItemDTO.Info updateDescription(Long id, CheckListItemDTO.Update request) throws IOException;

//    @Transactional
//    CheckListItemDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException;
}
