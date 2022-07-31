package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;

public interface ITeacherExperienceInfoService {
    SearchDTO.SearchRs<TeacherExperienceInfoDTO> search(SearchDTO.SearchRq request, Long teacherId);
}
