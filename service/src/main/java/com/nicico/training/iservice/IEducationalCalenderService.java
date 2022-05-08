package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompanyDTO;
import com.nicico.training.dto.EducationalCalenderDTO;
import org.springframework.transaction.annotation.Transactional;

public interface IEducationalCalenderService {

    @Transactional
    SearchDTO.SearchRs<EducationalCalenderDTO.Info> search(SearchDTO.SearchRq searchRq);

   EducationalCalenderDTO create(EducationalCalenderDTO request);

    void delete(Long id);
}
