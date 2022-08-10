package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.function.Function;

public interface IPostService {

    List<PostDTO.Info> list();

    @Transactional(readOnly = true)
    PostDTO.Info get(Long id);

    @Transactional(readOnly = true)
    Page<Post> listByJobId(Long jobId, Pageable pageable);

    @Transactional(readOnly = true)
    PostDTO.Info getByPostCode(String postCode);

    Optional<Post> isPostExist(String postCode);

    SearchDTO.SearchRs<PostDTO.Info> search(SearchDTO.SearchRq rq);

    <T> SearchDTO.SearchRs<T> searchWithoutPermission(SearchDTO.SearchRq request, Function converter);

    SearchDTO.SearchRs<PostDTO.Info> unassignedSearch(SearchDTO.SearchRq request);

    PostDTO.needAssessmentInfo getNeedAssessmentInfo(String postCode);

    Boolean updatePostDeletionStatus(Long postId);


}
