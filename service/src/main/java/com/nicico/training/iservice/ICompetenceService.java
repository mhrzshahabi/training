/*
ghazanfari_f, 9/7/2019, 10:55 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTOOld;

import java.util.List;

public interface ICompetenceService {

    CompetenceDTOOld.Info get(Long id);

    CompetenceDTOOld.Info create(CompetenceDTOOld.Create request);

    CompetenceDTOOld.Info update(Long id, CompetenceDTOOld.Update request);

    void delete(Long id);

    void delete(CompetenceDTOOld.Delete request);

    List<CompetenceDTOOld.Info> list();

    SearchDTO.SearchRs<CompetenceDTOOld.Info> search(SearchDTO.SearchRq request);

}
