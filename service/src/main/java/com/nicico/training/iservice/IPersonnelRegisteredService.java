package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:Lotfy
*/

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;

import java.util.HashMap;
import java.util.List;

public interface IPersonnelRegisteredService {

    PersonnelRegisteredDTO.Info get(Long id);

    List<PersonnelRegisteredDTO.Info> list();

    PersonnelRegisteredDTO.Info create(PersonnelRegisteredDTO.Create request);

    PersonnelRegisteredDTO.Info update(Long id, PersonnelRegisteredDTO.Update request);

    void delete(Long id);

    void delete(PersonnelRegisteredDTO.Delete request);

    SearchDTO.SearchRs<PersonnelRegisteredDTO.Info> search(SearchDTO.SearchRq request);

    HashMap<String, PersonnelRegisteredDTO.Info> checkPersonnelNos(List<String> personnelNos);

    TotalResponse<PersonnelRegisteredDTO.Info> search(NICICOCriteria request);

    PersonnelRegisteredDTO.Info getOneByNationalCode(String nationalCode);

    PersonnelRegisteredDTO.Info getByPersonnelCode(String personnelCode);
}
