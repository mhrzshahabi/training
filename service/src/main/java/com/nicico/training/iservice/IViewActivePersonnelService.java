package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.model.ViewActivePersonnel;

import java.util.List;
import java.util.Optional;

public interface IViewActivePersonnelService {
    List<ViewActivePersonnelDTO.Info> list();

    SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> search(SearchDTO.SearchRq searchRq);

    List<ViewActivePersonnelDTO.Info> checkPersonnelNos(List<String> personnelNos);

    List<ViewActivePersonnelDTO.Info> getByPostCode(Long postId);

    List<ViewActivePersonnelDTO.Info> getByJobNo(String jobNo);

    ViewActivePersonnelDTO.PersonalityInfo getByPersonnelCode(String personnelCode);

    ViewActivePersonnelDTO.PersonalityInfo getByNationalCode(String nationalCode);

    List<ViewActivePersonnelDTO.Info> findAllStatisticalReportFilter(String reportType);

    ViewActivePersonnel findPersonnelByPersonnelId(Long personnelId, String personnelNo);

    SearchDTO.SearchRs<ViewActivePersonnelDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName);

    Optional<ViewActivePersonnel> findById(Long personnelId);

    String getPersonnelFullName(Long personnelId);

    ViewActivePersonnel[] findByNationalCode(String personnelNationalCode);

    ViewActivePersonnel findFirstByPostId(Long postId);

}
