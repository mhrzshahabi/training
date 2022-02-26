package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationLevelDTO;
import response.academicBK.ElsEducationLevelDto;

import java.util.List;

public interface IEducationLevelService {

    EducationLevelDTO.Info get(Long id);

    List<EducationLevelDTO.Info> list();

    EducationLevelDTO.Info create(EducationLevelDTO.Create request);

    EducationLevelDTO.Info update(Long id, EducationLevelDTO.Update request);

    void delete(Long id);

    void delete(EducationLevelDTO.Delete request);

    SearchDTO.SearchRs<EducationLevelDTO.Info> search(SearchDTO.SearchRq request);

    List<ElsEducationLevelDto> elsEducationLevelList();

    ElsEducationLevelDto elsEducationLevel(Long id);

}
