/*
ghazanfari_f, 8/29/2019, 11:50 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.PostDTO;

import java.util.List;

public interface IJobService {

    List<JobDTO.Info> list();

    SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq rq);

    SearchDTO.SearchRs<JobDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    TotalResponse<JobDTO.Info> search(NICICOCriteria request);

    JobDTO.Info get(Long id);

    List<PostDTO.Info> getPosts(Long jobId);

    List<PostDTO.Info> getPostsWithTrainingPost(Long jobId);
}
