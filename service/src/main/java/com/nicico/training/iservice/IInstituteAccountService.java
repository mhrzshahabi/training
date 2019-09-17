package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.InstituteAccountDTO;

import java.util.List;

public interface IInstituteAccountService {
    InstituteAccountDTO.Info get(Long id);

    List<InstituteAccountDTO.Info> list();

    InstituteAccountDTO.Info create(InstituteAccountDTO.Create request);

    InstituteAccountDTO.Info update(Long id, InstituteAccountDTO.Update request);

    void delete(Long id);

    void delete(InstituteAccountDTO.Delete request);

    SearchDTO.SearchRs<InstituteAccountDTO.Info> search(SearchDTO.SearchRq request);

}
