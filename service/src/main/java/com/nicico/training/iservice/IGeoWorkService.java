package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GeoWorkDTO;

public interface IGeoWorkService {
    SearchDTO.SearchRs<GeoWorkDTO> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<GeoWorkDTO> getCompanyList(SearchDTO.SearchRq request);
}