package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEffectiveCoursesReportDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;

import java.text.ParseException;
import java.util.List;
import java.util.function.Function;

public interface IViewEffectiveCoursesReportService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
