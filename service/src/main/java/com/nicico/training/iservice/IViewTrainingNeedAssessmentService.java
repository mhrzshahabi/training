package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;

import java.util.function.Function;

public interface IViewTrainingNeedAssessmentService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
//    SearchDTO.SearchRs<ViewTrainingNeedAssessmentDTO.Info> searchs(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;
}
