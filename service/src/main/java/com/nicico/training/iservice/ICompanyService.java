package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.PersonalInfoDTO;

import java.util.List;

public interface ICompanyService {
    CompanyDTO.Info get(Long id);

    List<CompanyDTO.Info> list();

    CompanyDTO.Info create(CompanyDTO.Create request);

    PersonalInfoDTO.Info getOneByNationalCode(String nationalCode);

    CompanyDTO.Info update(Long id, CompanyDTO.Update request);

    void delete(Long id);

    void delete(CompanyDTO.Delete request);

    SearchDTO.SearchRs<CompanyDTO.Info> search(SearchDTO.SearchRq request);
}
