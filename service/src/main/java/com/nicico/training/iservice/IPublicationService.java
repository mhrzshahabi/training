package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PublicationDTO;
import com.nicico.training.model.Publication;


public interface IPublicationService {

    PublicationDTO.Info get(Long id);

    Publication getPublication(Long id);

    PublicationDTO.Info update(Long id, PublicationDTO.Update request);

    SearchDTO.SearchRs<PublicationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addPublication(PublicationDTO.Create request, Long teacherId);

    void deletePublication(Long teacherId, Long publicationId);
}
