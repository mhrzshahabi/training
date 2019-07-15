package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.CountryDTO;

import java.util.List;

public interface ICountryService {
    CountryDTO.Info get(Long id);

    List<CountryDTO.Info> list();

    CountryDTO.Info create(CountryDTO.Create request);

    CountryDTO.Info update(Long id, CountryDTO.Update request);

    void delete(Long id);

    void delete(CountryDTO.Delete request);

    SearchDTO.SearchRs<CountryDTO.Info> search(SearchDTO.SearchRq request);

    //------------------------
}
