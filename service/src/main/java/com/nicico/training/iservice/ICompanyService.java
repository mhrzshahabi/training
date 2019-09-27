package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.TermDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ICompanyService {
    CompanyDTO.Info get(Long id);
    List<CompanyDTO.Info> list();
    CompanyDTO.Info create(CompanyDTO.Create request);
    CompanyDTO.Info update(Long id, CompanyDTO.Update request);
    void delete(Long id);
    void delete(CompanyDTO.Delete request);
    SearchDTO.SearchRs<CompanyDTO.Info> search(SearchDTO.SearchRq request);
}
