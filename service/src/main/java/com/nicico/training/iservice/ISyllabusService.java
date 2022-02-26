package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SyllabusDTO;

import java.util.List;

public interface ISyllabusService {

    SyllabusDTO.Info get(Long id);

    List<SyllabusDTO.Info> list();

    SyllabusDTO.Info create(SyllabusDTO.Create request);

    SyllabusDTO.Info update(Long id, SyllabusDTO.Update request);

    void delete(Long id);

    void delete(SyllabusDTO.Delete request);

    SearchDTO.SearchRs<SyllabusDTO.Info> search(SearchDTO.SearchRq request);

    List<SyllabusDTO.Info> getSyllabusCourse(Long courseId);
}
