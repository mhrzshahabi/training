package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCourseNotPassedReportViewDTO;
import org.springframework.http.ResponseEntity;

import java.util.function.Function;

public interface IPersonnelCourseNotPassedReportViewService {
    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
