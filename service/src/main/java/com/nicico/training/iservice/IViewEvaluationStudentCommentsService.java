package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEvaluationCommentsDTO;

public interface IViewEvaluationStudentCommentsService {
    SearchDTO.SearchRs<ViewEvaluationCommentsDTO.Info> search(SearchDTO.SearchRq searchRq);
}