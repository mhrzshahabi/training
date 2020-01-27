/*
ghazanfari_f, 8/29/2019, 11:50 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IPostService {

    List<PostDTO.Info> list();

    @Transactional(readOnly = true)
    Page<Post> listByJobId(Long jobId, Pageable pageable);

    SearchDTO.SearchRs<PostDTO.Info> search(SearchDTO.SearchRq rq);

    SearchDTO.SearchRs<PostDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<PostDTO.Info> unassignedSearch(SearchDTO.SearchRq request);
}
