package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassesReactiveAssessmentHasNotReachedQuorumDTO;
import java.text.ParseException;
import java.util.List;
import java.util.function.Function;

public interface IClassesReactiveAssessmentHasNotReachedQuorumService {

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
    List<ClassesReactiveAssessmentHasNotReachedQuorumDTO.Info> getList(String start, String end) throws ParseException;
}
