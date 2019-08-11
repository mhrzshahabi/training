package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CityDTO;

import java.util.List;

public interface ICityService {
    CityDTO.Info get(Long id);

    List<CityDTO.Info> list();

    CityDTO.Info create(CityDTO.Create request);

    CityDTO.Info update(Long id, CityDTO.Update request);

    void delete(Long id);

    void delete(CityDTO.Delete request);

    SearchDTO.SearchRs<CityDTO.Info> search(SearchDTO.SearchRq request);

    //------------------------
}
