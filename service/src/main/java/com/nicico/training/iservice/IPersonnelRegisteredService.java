package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:Lotfy
*/

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.model.PersonnelRegistered;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface IPersonnelRegisteredService {

    PersonnelRegisteredDTO.Info get(Long id);

    List<PersonnelRegisteredDTO.Info> list();

    PersonnelRegisteredDTO.Info create(PersonnelRegisteredDTO.Create request);
    void createList(List<PersonnelRegistered> requests);

    PersonnelRegisteredDTO.Info update(Long id, PersonnelRegisteredDTO.Update request);

    void delete(Long id);

    void delete(PersonnelRegisteredDTO.Delete request);

    SearchDTO.SearchRs<PersonnelRegisteredDTO.Info> search(SearchDTO.SearchRq request);

    List<PersonnelRegisteredDTO.InfoForStudent> checkPersonnelNos(List<String> personnelNos, Long courseId);

    TotalResponse<PersonnelRegisteredDTO.Info> search(NICICOCriteria request);

    PersonnelRegisteredDTO.Info getOneByNationalCode(String nationalCode);

    PersonnelRegisteredDTO.Info getByPersonnelCode(String personnelCode);

    PersonnelRegisteredDTO.Info getByPersonnelCodeAndNationalCode(String nationalCode, String personnelNo);

    Optional<PersonnelRegistered> getByNationalCode(String nationalCode);

    List<PersonnelRegistered> checkPersonnelNationalCodes(List<String> personnelNationalCodes);

    void changeContactInfo(List<Long> id);

    boolean isPresent(String nationalCode);

    List<Map<String,Object>> findByNationalCodeAndMobileNumber(String nationalCode, String mobileNumber);

}
