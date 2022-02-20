package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AcademicBKDTO;
import com.nicico.training.model.AcademicBK;

public interface IAcademicBKService {

    AcademicBKDTO.Info get(Long id);

    AcademicBK getAcademicBK(Long id);

    AcademicBKDTO.Info update(Long id, AcademicBKDTO.Update request);

    SearchDTO.SearchRs<AcademicBKDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    AcademicBKDTO.Info addAcademicBK(AcademicBKDTO.Create request, Long teacherId);

    void deleteAcademicBK(Long teacherId, Long academicBKId);
}
