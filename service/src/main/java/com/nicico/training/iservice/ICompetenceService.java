/*
ghazanfari_f, 9/7/2019, 10:55 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;

import java.util.List;

public interface ICompetenceService {

    CompetenceDTO.Info get(Long id);

    CompetenceDTO.Info create(CompetenceDTO.Create request);

    CompetenceDTO.Info update(Long id, CompetenceDTO.Update request);

    void delete(Long id);

    void delete(CompetenceDTO.Delete request);

    List<CompetenceDTO.Info> list();

    SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request);

}
