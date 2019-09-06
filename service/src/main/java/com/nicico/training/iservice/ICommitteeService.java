package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.model.PersonalInfo;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

public interface ICommitteeService {

    CommitteeDTO.Info get(Long id);

    List<CommitteeDTO.Info> list();

    CommitteeDTO.Info create(CommitteeDTO.Create request);

    CommitteeDTO.Info update(Long id, CommitteeDTO.Update request);

    void delete(Long id);

    void delete(CommitteeDTO.Delete request);

    SearchDTO.SearchRs<CommitteeDTO.Info> search(SearchDTO.SearchRq request);
     void addMember(Long committeeId, Long personInfiId);
     void removeMember(Long committeeId, Long personInfiId);
     void removeMembers(Long committeeId,Set<Long> personIds);
      void addMembers(Long committeeId, Set<Long> personInfiIds);
     List<PersonalInfoDTO.Info> getMembers(Long committeeId);
     Set<PersonalInfoDTO.Info> unAttachMember(Long committeeId);
      boolean checkForDelete(Long CommitteeId);
}
