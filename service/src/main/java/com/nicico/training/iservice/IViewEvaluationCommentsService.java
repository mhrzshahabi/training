package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;

import java.text.ParseException;
import java.util.List;
import java.util.function.Function;

public interface IViewEvaluationCommentsService {
//
    <T> SearchDTO.SearchRs<T> search(String type,SearchDTO.SearchRq request, Function converter);
//    List<ViewNeedAssessmentInRangeDTO.Info> getList(String start, String end) throws ParseException;
}
