package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;

import java.util.function.Function;

public interface IPersonnelCoursePassedNAReportViewService {
    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.Grid> searchCourseList(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.MinInfo> searchMinList(SearchDTO.SearchRq request);
}
