package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import response.academicBK.ElsEducationOrientationDto;

import java.util.List;

public interface IEducationOrientationService {

    EducationOrientationDTO.Info get(Long id);

    List<EducationOrientationDTO.Info> list();

    EducationOrientationDTO.Info create(EducationOrientationDTO.Create request);

    EducationOrientationDTO.Info update(Long id, EducationOrientationDTO.Update request);

    void delete(Long id);

    void delete(EducationOrientationDTO.Delete request);

    SearchDTO.SearchRs<EducationOrientationDTO.Info> search(SearchDTO.SearchRq request);

    List<EducationOrientationDTO.Info> listByLevelIdAndMajorId(Long levelId, Long majorId);

    List<ElsEducationOrientationDto> elsEducationOrientationList(Long levelId, Long majorId);

    ElsEducationOrientationDto elsEducationOrientation(Long id);

}
