package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTOOld;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGroupDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

public interface IPostGroupService {
    PostGroupDTO.Info get(Long id);

    List<PostGroupDTO.Info> list();

    PostGroupDTO.Info create(PostGroupDTO.Create request);

    PostGroupDTO.Info update(Long id, PostGroupDTO.Update request);

    void delete(Long id);

    void delete(PostGroupDTO.Delete request);

    void addPost(Long postGroupId, Long postId);

    void addPosts(Long postGroupId, Set<Long> postIds);

    void removePost(Long postGroupId, Long postId);

    void removePosts(Long postGroupId, Set<Long> postIds);

    void removeFromCompetency(Long postGroupId, Long competenceId);

    void removeFromAllCompetences(Long postGroupId);

    Set<PostDTO.Info> unAttachPosts(Long postGroupId);

    boolean canDelete(Long postGroupId);

    SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<PostGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    List<CompetenceDTOOld.Info> getCompetence(Long postGroupID);

    List<PostDTO.Info> getPosts(Long postGroupID);


}
