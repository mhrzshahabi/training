package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CommitteeOfExpertsDTO;
import com.nicico.training.dto.CommitteeOfExpertsUsersDTO;
import com.nicico.training.model.CommitteeOfExperts;
import response.BaseResponse;

import java.util.List;

public interface ICommitteeOfExpertsService {

    SearchDTO.SearchRs<CommitteeOfExpertsDTO.Info> search(SearchDTO.SearchRq request);

    BaseResponse create(CommitteeOfExperts committeeOfExperts);
    BaseResponse addPart(CommitteeOfExpertsDTO.CreatePartOfPersons req);

    void delete(Long id);

    CommitteeOfExperts get(Long id);

    BaseResponse edit(CommitteeOfExperts toModel);

    List<CommitteeOfExpertsUsersDTO.Info> listOfParts(Long id);
}
