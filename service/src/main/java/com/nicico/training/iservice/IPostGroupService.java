package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGroupDTO;
import com.nicico.training.dto.TrainingPostDTO;
import com.nicico.training.model.PostGroup;

import java.util.List;
import java.util.Set;

public interface IPostGroupService {
    PostGroupDTO.Info get(Long id);

    List<PostGroupDTO.Info> list();

    PostGroupDTO.Info create(PostGroupDTO.Create request);

    PostGroupDTO.Info update(Long id, PostGroupDTO.Update request);

    boolean delete(Long id);

    void delete(PostGroupDTO.Delete request);

    void addPost(Long postGroupId, Long postId);

    void addTrainingPost(Long trainingPostId, Long postGroupId);

    void addPosts(Long postGroupId, Set<Long> postIds);

    void addTrainingPosts(Long postGroupId, Set<Long> trainingPostIds);

    void removePost(Long postGroupId, Long postId);

    void removeTrainingPost(Long postGroupId, Long trainingPostId);

    void removePosts(Long postGroupId, Set<Long> postIds);

    void removeTrainingPosts(Long postGroupId, Set<Long> trainingPostIds);

    void removeFromCompetency(Long postGroupId, Long competenceId);

    void removeFromAllCompetences(Long postGroupId);

    Set<PostDTO.Info> unAttachPosts(Long postGroupId);

    SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<PostGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    List<PostDTO.Info> getPosts(Long postGroupID);

    List<TrainingPostDTO.Info> getTrainingPosts(Long postGroupID);
    List<PostGroup> getPostGroupsByTrainingPostId(Long trainingPost);
}
