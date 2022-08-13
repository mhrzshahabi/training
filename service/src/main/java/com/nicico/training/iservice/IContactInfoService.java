package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.model.ContactInfo;

import java.util.List;
import java.util.Map;

public interface IContactInfoService {
    ContactInfoDTO.Info get(Long id);

    List<ContactInfoDTO.Info> list();

    ContactInfoDTO.Info create(ContactInfoDTO.Create request);

    ContactInfoDTO.Info createNewFor(Long id, String type);

    ContactInfoDTO.Info update(Long id, ContactInfoDTO.Update request);

    void delete(Long id);

    void delete(ContactInfoDTO.Delete request);

    SearchDTO.SearchRs<ContactInfoDTO.Info> search(SearchDTO.SearchRq request);

    void modify(ContactInfoDTO.CreateOrUpdate request, ContactInfo contactInfo);

    ContactInfo fetchAndUpdateLastHrMobile(Long id, String type, String token);

    Map<Long, ContactInfo> fetchAndUpdateLastHrMobile(List<Long> ids, String type, String token);

    Map<String, Object> nationalCodeOfMobile(String mobile);

    Object getCorrespondingRecordOfContactInfo(Long id, Long parentId);
    boolean  updateAllRepositoriesWithThisContactInfo(Object record, ContactInfo contactInfo1);

    ContactInfo save(ContactInfoDTO.Info contactInfo);

    //Boolean has
}
