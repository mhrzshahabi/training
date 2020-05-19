package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CommitteeDTO;
import com.nicico.training.dto.PersonnelDTO;

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

    void addMember(Long committeeId, String personInfiId);

    void removeMember(Long committeeId, String personInfiId);

    void removeMembers(Long committeeId, Set<String> personIds);

    void addMembers(Long committeeId, Set<String> personInfiIds);

    List<PersonnelDTO.Info> getMembers(Long committeeId);

//    Set<PersonalInfoDTO.Info> unAttachMember(Long committeeId);

    boolean checkForDelete(Long CommitteeId);

    String findConflictCommittee(Long category, Long subcategory);

    String findConflictWhenEdit(Long category, Long subcategory, Long id);
}
