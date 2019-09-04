/*
ghazanfari_f, 8/29/2019, 11:50 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.JobDTO;

import java.util.List;

public interface IPostService {

    List<JobDTO.Info> list();

    SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq rq);
}
