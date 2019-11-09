package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalUnitDTO;

import java.util.List;

public interface IOperationalUnitService {

    OperationalUnitDTO.Info get(Long id);

    List<OperationalUnitDTO.Info> list();

    OperationalUnitDTO.Info create(OperationalUnitDTO.Create request);

    OperationalUnitDTO.Info update(Long id, OperationalUnitDTO.Update request);

    void delete(Long id);

    void delete(OperationalUnitDTO.Delete request);

    SearchDTO.SearchRs<OperationalUnitDTO.Info> search(SearchDTO.SearchRq request);

}
