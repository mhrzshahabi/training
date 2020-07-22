package com.nicico.training.service;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.ITrainingPostService;
import com.nicico.training.model.Post;
import com.nicico.training.model.PostGroup;
import com.nicico.training.model.TrainingPost;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.PostGroupDAO;
import com.nicico.training.repository.TrainingPostDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class TrainingPostService implements ITrainingPostService {

    private final ModelMapper modelMapper;
    private final TrainingPostDAO trainingPostDAO;
    private final PostDAO postDAO;
    private final PersonnelService personnelService;

    @Transactional
    @Override
    public void addPosts(Long trainingPostID, Set<Long> postIds) {

        final Optional<TrainingPost> trainingPostById = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = trainingPostById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));

        Set<Post> postSet = trainingPost.getPostSet();

        for (Long postId : postIds) {

            final Optional<Post> optionalPost = postDAO.findById(postId);
            final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
            postSet.add(post);
        }
        trainingPost.setPostSet(postSet);
    }

    @Override
    @Transactional
    public void removePost(Long trainingPostID, Long postId) {
        Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        final Optional<Post> optionalPost = postDAO.findById(postId);
        final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
        trainingPost.getPostSet().remove(post);
    }

    @Override
    @Transactional
    public void removePosts(Long trainingPostID, Set<Long> postIds) {
        for (long postId : postIds) {
            removePost(trainingPostID, postId);
        }
    }

    @Transactional
    @Override
    public List<PostDTO.Info> getPosts(Long trainingPostID) {
        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        Set<Post> posts = trainingPost.getPostSet();
        ArrayList<PostDTO.Info> postList = new ArrayList<>();
        for (Post post : posts) {
            postList.add(modelMapper.map(post, PostDTO.Info.class));
        }
        return postList;
    }

    @Transactional
    @Override
    public List<PersonnelDTO.Info> getPersonnel(Long trainingPostID) {
        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        Set<Post> posts = trainingPost.getPostSet();
        if(posts.size() > 0)
        {
            List<Long> values = new ArrayList<>();
            for (Post post : posts) {
                values.add(post.getId());
            }

            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteria.getCriteria().add(makeNewCriteria("postId", values, EOperator.inSet, null));
            criteria.getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
            criteria.getCriteria().add(makeNewCriteria("employmentStatusId", 5, EOperator.equals, null));
            return personnelService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        }
        return null;
    }
}
