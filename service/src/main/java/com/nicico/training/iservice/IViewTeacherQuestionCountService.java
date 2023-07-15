package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTeacherQuestionCountDTO;

public interface IViewTeacherQuestionCountService {
    SearchDTO.SearchRs<ViewTeacherQuestionCountDTO.Info> search(SearchDTO.SearchRq request);
}
