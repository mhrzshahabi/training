package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.Personnel;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.function.Function;

public interface IPersonnelService {

    List<PersonnelDTO.Info> list();

    PersonnelDTO.Info get(String personnelNo);

    Personnel getPersonnel(String personnelNo);

    SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq rq);

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request);

    HashMap<String, PersonnelDTO.Info> checkPersonnelNos(List<String> personnelNos);

    List<PersonnelDTO.Info> getByPostCode(Long postId);

    List<Personnel> getByPostCode(String postCode);

    List<PersonnelDTO.Info> getByJobNo(String jobNo);

    PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

    @Transactional
    PersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode);

    List<PersonnelDTO.Info> findAllStatisticalReportFilter(String reportType);

    Personnel findPersonnelByPersonnelNo(String personnelNo);

    SearchDTO.SearchRs<PersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName);

    <R> R getPOrRegisteredP(String personnelNo, Function<Object, R> converter);
}
