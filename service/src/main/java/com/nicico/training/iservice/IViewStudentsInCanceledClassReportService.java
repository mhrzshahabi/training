/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/14
 * Last Modified: 2020/09/14
 */


package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewAllPostDTO;

import java.util.List;
import java.util.function.Function;

public interface IViewStudentsInCanceledClassReportService {
    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);
}
