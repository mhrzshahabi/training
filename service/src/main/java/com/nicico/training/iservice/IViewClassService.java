package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassDTO;
import com.nicico.training.model.ViewClass;

import java.util.List;

public interface IViewClassService {

    ViewClass get(Long id);

    List<ViewClass> list();

    SearchDTO.SearchRs<ViewClassDTO> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

}
