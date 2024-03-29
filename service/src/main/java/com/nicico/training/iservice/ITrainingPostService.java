package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.TrainingPostDTO;
import com.nicico.training.model.TrainingPost;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface ITrainingPostService {

    SearchDTO.SearchRs<TrainingPostDTO.Info> search(SearchDTO.SearchRq request);

    void addPosts(Long trainingPostID, Set<Long> postIds);

    void removePost(Long trainingPostID, Long postId);

    void removePosts(Long trainingPostID, Set<Long> postIds);

    List<PostDTO.Info> getPosts(Long trainingPostID);

    TrainingPostDTO.Info getTrainingPost(Long trainingPostID);

    List<PostDTO.Info> getNullPosts();

    List<PersonnelDTO.Info> getPersonnel(Long trainingPostID);

    TrainingPostDTO create(TrainingPostDTO.Create create, HttpServletResponse response) throws IOException;

    TrainingPostDTO update(Long id,TrainingPostDTO.Update update, HttpServletResponse response) throws IOException;

    boolean delete (Long id);
    boolean updateToUnDeleted (Long id);
    boolean updateToUnDeleted (String code);

    List<String> getAllArea();

    Optional<TrainingPost> isTrainingPostExist(String trainingPostCode);

    TrainingPostDTO.needAssessmentInfo getNeedAssessmentInfo(String trainingPostCode);

    Boolean updateTrainingPostDeletionStatus(Long trainingPostId);


    List<TrainingPost> getTrainingPostWithPostId(Long objectId);

    Boolean updateTrainingPostFromPost(Long trainingPostId, Long postId);
}
