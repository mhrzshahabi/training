package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EducationMajorDTO;
import com.nicico.training.dto.EducationOrientationDTO;
import response.academicBK.ElsEducationMajorDto;

import java.util.List;

public interface IEducationMajorService {

    EducationMajorDTO.Info get(Long id);

    List<EducationMajorDTO.Info> list();

    EducationMajorDTO.Info create(EducationMajorDTO.Create request);

    EducationMajorDTO.Info update(Long id, EducationMajorDTO.Update request);

    void delete(Long id);

    void delete(EducationMajorDTO.Delete request);

    SearchDTO.SearchRs<EducationMajorDTO.Info> search(SearchDTO.SearchRq request);

    List<EducationOrientationDTO.Info> listByMajorId(Long majorId);

    List<ElsEducationMajorDto> elsEducationMajorList();

}
