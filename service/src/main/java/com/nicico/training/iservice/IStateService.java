package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CityDTO;
import com.nicico.training.dto.StateDTO;

import java.util.List;

public interface IStateService {
    StateDTO.Info get(Long id);

    List<StateDTO.Info> list();

    StateDTO.Info create(StateDTO.Create request);

    StateDTO.Info update(Long id, StateDTO.Update request);

    void delete(Long id);

    void delete(StateDTO.Delete request);


    SearchDTO.SearchRs<StateDTO.Info> search(SearchDTO.SearchRq request);

    List<CityDTO.Info> listByStateId(Long stateId);
}
