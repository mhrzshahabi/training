package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import java.util.function.Function;


public interface ITimeInterferenceComprehensiveClassesReportService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
