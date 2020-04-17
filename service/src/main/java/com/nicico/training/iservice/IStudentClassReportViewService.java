package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;

import java.util.List;
import java.util.Map;
import java.util.function.Function;

public interface IStudentClassReportViewService {


    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

}
