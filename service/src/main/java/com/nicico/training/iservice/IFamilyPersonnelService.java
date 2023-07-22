package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.FamilyPersonnelDTO;
import com.nicico.training.model.FamilyPersonnel;

import java.util.function.Function;

public interface IFamilyPersonnelService {

    SearchDTO.SearchRs<FamilyPersonnelDTO.Info> search(SearchDTO.SearchRq searchRq, Function converter);

    FamilyPersonnel getById(Long id);
}
