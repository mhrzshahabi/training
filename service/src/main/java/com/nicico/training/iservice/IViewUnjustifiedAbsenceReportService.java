package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;

import java.util.function.Function;

public interface IViewUnjustifiedAbsenceReportService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
