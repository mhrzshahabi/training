package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.model.PersonalInfo;

import java.util.List;
import java.util.Map;

public interface IPersonalInfoService {
    PersonalInfoDTO.Info get(Long id);

    PersonalInfo getPersonalInfo(Long id);

    List<PersonalInfoDTO.Info> list();

    PersonalInfoDTO.Info create(PersonalInfoDTO.Create request);

    PersonalInfoDTO.Info safeCreate(PersonalInfoDTO.SafeCreate request);

    PersonalInfoDTO.Info safeUpdate(Long id,PersonalInfoDTO.SafeUpdate request);

    PersonalInfoDTO.Info update(Long id, PersonalInfoDTO.Update request);

    void delete(Long id);

    void delete(PersonalInfoDTO.Delete request);

    SearchDTO.SearchRs<PersonalInfoDTO.Info> search(SearchDTO.SearchRq request);

    PersonalInfoDTO.Info getOneByNationalCode(String nationalCode);

    PersonalInfoDTO.Info createOrUpdate(PersonalInfoDTO.CreateOrUpdate request);

    void modify(PersonalInfoDTO.CreateOrUpdate request, PersonalInfo personalInfo);

    List<Map<String,Object>> findByNationalCodeAndMobileNumber(String nationalCode,String mobileNumber);
}
