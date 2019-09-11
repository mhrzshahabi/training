/*
ghazanfari_f, 9/7/2019, 10:55 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;

import java.util.List;

public interface ICompetenceService {

    CompetenceDTO.MinInfo get(Long id);

    List<CompetenceDTO.Info> list();

    CompetenceDTO.MinInfo create(CompetenceDTO.Create request);

    CompetenceDTO.Info update(Long id, CompetenceDTO.Update request);

    void delete(Long id);

    void delete(CompetenceDTO.Delete request);

    SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request);
}
