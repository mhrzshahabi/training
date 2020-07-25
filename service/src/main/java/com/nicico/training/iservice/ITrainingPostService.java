package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;

import java.util.List;
import java.util.Set;

public interface ITrainingPostService {

    void addPosts(Long trainingPostID, Set<Long> postIds);

    void removePost(Long trainingPostID, Long postId);

    void removePosts(Long trainingPostID, Set<Long> postIds);

    List<PostDTO.Info> getPosts(Long trainingPostID);

    List<PersonnelDTO.Info> getPersonnel(Long trainingPostID);
}
