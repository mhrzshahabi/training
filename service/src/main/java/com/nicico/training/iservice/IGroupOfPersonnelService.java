package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GroupOfPersonnelDTO;
import response.BaseResponse;

import java.util.List;
import java.util.Set;

public interface IGroupOfPersonnelService {
    //    PostGroupDTO.Info get(Long id);
//
//    List<PostGroupDTO.Info> list();
//
    BaseResponse create(GroupOfPersonnelDTO.Create request);

    //
    BaseResponse update(Long id, GroupOfPersonnelDTO.Update request);

    //
    BaseResponse delete(Long id);
//
//    void delete(PostGroupDTO.Delete request);
//
//    void addPost(Long postGroupId, Long postId);
//
//    void addTrainingPost(Long trainingPostId, Long postGroupId);
//
//    void addPosts(Long postGroupId, Set<Long> postIds);
//
//    void addTrainingPosts(Long postGroupId, Set<Long> trainingPostIds);
//
//    void removePost(Long postGroupId, Long postId);
//
//    void removeTrainingPost(Long postGroupId, Long trainingPostId);
//
//    void removePosts(Long postGroupId, Set<Long> postIds);
//
//    void removeTrainingPosts(Long postGroupId, Set<Long> trainingPostIds);
//
//    void removeFromCompetency(Long postGroupId, Long competenceId);
//
//    void removeFromAllCompetences(Long postGroupId);
//
//    Set<PostDTO.Info> unAttachPosts(Long postGroupId);
//
//    SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request);
//
    SearchDTO.SearchRs<GroupOfPersonnelDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    List<Long> getPersonnel(Long id);

    void addPersonnel(Long groupId, Set<Long> ids);
//
//    List<PostDTO.Info> getPosts(Long postGroupID);
//
//    List<TrainingPostDTO.Info> getTrainingPosts(Long postGroupID);
//    List<PostGroup> getPostGroupsByTrainingPostId(Long trainingPost);
}
