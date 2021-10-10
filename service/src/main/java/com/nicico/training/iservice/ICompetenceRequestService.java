package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.model.CompetenceRequest;

import java.util.List;

public interface ICompetenceRequestService {

    CompetenceRequest create(CompetenceRequest competenceRequest);

    CompetenceRequest update(CompetenceRequest competenceRequest, Long id);
   
    CompetenceRequest get(Long id);

    void delete(Long id);

    List<CompetenceRequest> getList();

    Integer getTotalCount();

    List<CompetenceRequest> search(SearchDTO.SearchRq request);
}
