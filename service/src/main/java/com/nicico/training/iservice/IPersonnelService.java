package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.Personnel;

import java.util.List;
import java.util.function.Function;

public interface IPersonnelService {

    List<PersonnelDTO.Info> list();

    PersonnelDTO.Info get(Long id);

    Personnel getPersonnel(Long id);

    SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq rq);

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request);

    List<PersonnelDTO.InfoForStudent> checkPersonnelNos(List<String> personnelNos,Long courseId);

    List<PersonnelDTO.Info> getByPostCode(Long postId);

    List<Personnel> getByPostCode(String postCode);

    List<PersonnelDTO.Info> getByJobNo(String jobNo);

    PersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

    PersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode);

    List<PersonnelDTO.Info> findAllStatisticalReportFilter(String reportType);

    Personnel findPersonnelByPersonnelId(Long personnelId, String personnelNo);

    SearchDTO.SearchRs<PersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName);

//    <R> R getPOrRegisteredP(Long id, Function<Object, R> converter);
}
