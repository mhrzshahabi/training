package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.Personnel;

import java.util.List;

public interface IPersonnelService {

    List<PersonnelDTO.Info> list();

    PersonnelDTO.Info get(String personnelNo);

    Personnel getPersonnel(String personnelNo);

    SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq rq);

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request);

    List<PersonnelDTO.Info> getByPostCode(Long postId);

    List<Personnel> getByPostCode(String postCode);

    List<PersonnelDTO.Info> getByJobNo(String jobNo);

    PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

}
