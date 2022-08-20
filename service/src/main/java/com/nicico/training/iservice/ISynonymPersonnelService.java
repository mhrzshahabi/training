package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.model.SynonymPersonnel;

import java.util.Optional;

public interface ISynonymPersonnelService {

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria nicicoCriteria);
    SearchDTO.SearchRs  searchStatistic(SearchDTO.CriteriaRq criteriaRq);

    ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

    Optional<SynonymPersonnel> getByPostCode(String postCode);

    SynonymPersonnel getByNationalCode(String nationalCode);

    SynonymPersonnel getById(Long nationalCode);

    SynonymPersonnel getByPersonnelNo2(String personnelNo2);

}
