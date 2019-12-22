package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.model.PersonalInfo;

import java.util.List;

public interface IPersonalInfoService {
    PersonalInfoDTO.Info get(Long id);

    List<PersonalInfoDTO.Info> list();

    PersonalInfoDTO.Info create(PersonalInfoDTO.Create request);

    PersonalInfoDTO.Info update(Long id, PersonalInfoDTO.Update request);

    void delete(Long id);

    void delete(PersonalInfoDTO.Delete request);

    SearchDTO.SearchRs<PersonalInfoDTO.Info> search(SearchDTO.SearchRq request);

    PersonalInfoDTO.Info getOneByNationalCode(String nationalCode);

    PersonalInfoDTO.Info createOrUpdate(PersonalInfoDTO.Create request);

    PersonalInfoDTO.Info modify(Long id);

    PersonalInfo getPersonalInfo(Long id);
}
