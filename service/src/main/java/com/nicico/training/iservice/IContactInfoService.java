package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.StudentDTO.ClassStudentInfo;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.model.ContactInfo;

import java.util.List;

public interface IContactInfoService {
    ContactInfoDTO.Info get(Long id);

    List<ContactInfoDTO.Info> list();

    ContactInfoDTO.Info create(ContactInfoDTO.Create request);

    ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request);

    void delete(Long id);

    void delete(ContactInfoDTO.Delete request);

    SearchDTO.SearchRs<ContactInfoDTO.Info> search(SearchDTO.SearchRq request);

    void modify(ContactInfoDTO.CreateOrUpdate request, ContactInfo contactInfo);

    String fetchAndUpdateLastHrMobile(String nationalCode, ClassStudentInfo classStudentInfo, String token);

    String fetchAndUpdateLastHrMobile(String nationalCode, PersonnelDTO.Info personnelInfo, String token);

}
