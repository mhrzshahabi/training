package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CommitteeDTO;

import java.util.List;

public interface ICommitteeService {

    CommitteeDTO.Info get(Long id);

    List<CommitteeDTO.Info> list();

    CommitteeDTO.Info create(CommitteeDTO.Create request);

    CommitteeDTO.Info update(Long id, CommitteeDTO.Update request);

    void delete(Long id);

    void delete(CommitteeDTO.Delete request);

    SearchDTO.SearchRs<CommitteeDTO.Info> search(SearchDTO.SearchRq request);
}
