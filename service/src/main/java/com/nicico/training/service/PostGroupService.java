package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:16 AM
    */

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGroupDTO;
import com.nicico.training.dto.TrainingPostDTO;
import com.nicico.training.iservice.IPostGroupService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.Post;
import com.nicico.training.model.PostGroup;
import com.nicico.training.model.TrainingPost;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.PostGroupDAO;
import com.nicico.training.repository.TrainingPostDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class PostGroupService implements IPostGroupService {


    private final ModelMapper modelMapper;
    private final PostGroupDAO postGroupDAO;
    private final PostDAO postDAO;
    private final TrainingPostDAO trainingPostDAO;
    private final IWorkGroupService workGroupService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final NeedsAssessmentService needsAssessmentService;

    @Transactional(readOnly = true)
    @Override
    public PostGroupDTO.Info get(Long id) {

        final Optional<PostGroup> cById = postGroupDAO.findById(id);
        final PostGroup postGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        return modelMapper.map(postGroup, PostGroupDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<PostGroupDTO.Info> list() {
        final List<PostGroup> cAll = postGroupDAO.findAll();

        return modelMapper.map(cAll, new TypeToken<List<PostGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public PostGroupDTO.Info create(PostGroupDTO.Create request) {
        final PostGroup postGroup = modelMapper.map(request, PostGroup.class);

        return save(postGroup, request.getPostIds());
    }

    @Transactional
    @Override
    public void addPost(Long postId, Long postGroupId) {
        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        final Optional<Post> postById = postDAO.findById(postId);
        final Post post = postById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
        postGroup.getPostSet().add(post);
    }

    @Transactional
    @Override
    public void addTrainingPost(Long trainingPostId, Long postGroupId) {
        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        final Optional<TrainingPost> TrainingPostById = trainingPostDAO.findById(trainingPostId);
        final TrainingPost trainingPost = TrainingPostById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        postGroup.getTrainingPostSet().add(trainingPost);
    }


    @Transactional
    @Override
    public void addPosts(Long postGroupId, Set<Long> postIds) {

        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<Post> postSet = postGroup.getPostSet();

        for (Long postId : postIds) {

            final Optional<Post> optionalPost = postDAO.findById(postId);
            final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
            postSet.add(post);
        }
        postGroup.setPostSet(postSet);
    }


    @Transactional
    @Override
    public void addTrainingPosts(Long postGroupId, Set<Long> trainingPostIds) {

        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<TrainingPost> trainingPostSet = postGroup.getTrainingPostSet();

        for (Long trainingPostId : trainingPostIds) {

            final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostId);
            final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
            trainingPostSet.add(trainingPost);
        }
        postGroup.setTrainingPostSet(trainingPostSet);
    }


    @Transactional
    @Override
    public PostGroupDTO.Info update(Long id, PostGroupDTO.Update request) {
        final Optional<PostGroup> cById = postGroupDAO.findById(id);
        final PostGroup postGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        PostGroup updating = new PostGroup();
        modelMapper.map(postGroup, updating);
        modelMapper.map(request, updating);

        return modelMapper.map(postGroupDAO.saveAndFlush(updating), PostGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public boolean delete(Long id) {
        try {
            if (needsAssessmentService.checkBeforeDeleteObject("PostGroup", id) && needsAssessmentTempService.checkBeforeDeleteObject("PostGroup", id)) {
                postGroupDAO.deleteById(id);
                return true;
            } else
                return false;
        } catch (Exception e) {
            return false;
        }

    }

    @Transactional
    @Override
    public void delete(PostGroupDTO.Delete request) {
        request.getIds().forEach(this::delete);
//        final List<PostGroup> cAllById = postGroupDAO.findAllById(request.getIds());
//        postGroupDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request) {
        setCriteria(request, workGroupService.applyPermissions(PostGroup.class, SecurityUtil.getUserId()));
        return SearchUtil.search(postGroupDAO, request, postGroup -> modelMapper.map(postGroup, PostGroupDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(postGroupDAO, request, postGroup -> modelMapper.map(postGroup, PostGroupDTO.Info.class));
    }

    // ------------------------------

    private PostGroupDTO.Info save(PostGroup postGroup, Set<Long> postIds) {
        final Set<Post> posts = new HashSet<>();
//        final Set<CompetenceOld> competences = new HashSet<>();
        Optional.ofNullable(postIds)
                .ifPresent(postIdSet -> postIdSet
                        .forEach(postId ->
                                posts.add(postDAO.findById(postId)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound)))
                        ));
//        Optional.ofNullable(competenceIds)
//                .ifPresent(competenceIdSet -> competenceIdSet
//                        .forEach(competenceIdss ->
//                                competences.add(competenceDAO.findById(competenceIdss)
//                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound)))
//                        ));

//        postGroup.setCompetenceSet(competences);
        postGroup.setPostSet(posts);
        //final PostGroup saved = postGroupDAO.saveAndFlush(postGroup);
        final PostGroup saved = postGroupDAO.save(postGroup);
        return modelMapper.map(saved, PostGroupDTO.Info.class);
    }

    @Override
    @Transactional
    public List<PostDTO.Info> getPosts(Long postGroupID) {
        final PostGroup postGroup = postGroupDAO.findById(postGroupID).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        return modelMapper.map(postGroup.getPostSet().stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public List<TrainingPostDTO.Info> getTrainingPosts(Long postGroupID) {
        final PostGroup postGroup = postGroupDAO.findById(postGroupID).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        return modelMapper.map(postGroup.getTrainingPostSet().stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<TrainingPostDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public void removePost(Long postGroupId, Long postId) {
        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        final Optional<Post> optionalPost = postDAO.findById(postId);
        final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
        postGroup.getPostSet().remove(post);
    }

    @Override
    @Transactional
    public void removeTrainingPost(Long postGroupId, Long trainingPostId) {
        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostId);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        postGroup.getTrainingPostSet().remove(trainingPost);
    }

    @Override
    @Transactional
    public void removeFromCompetency(Long postGroupId, Long competenceId) {

//        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
//        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
//        postGroup.getCompetenceSet().remove(competence);
    }

    @Override
    @Transactional
    public void removeFromAllCompetences(Long postGroupId) {

//        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        postGroup.getCompetenceSet().clear();

    }

    @Override
    @Transactional
    public Set<PostDTO.Info> unAttachPosts(Long postGroupId) {
        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<Post> activePosts = postGroup.getPostSet();
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        BaseService.setCriteriaToNotSearchDeleted(request);
        List<Post> allPosts = postDAO.findAll(NICICOSpecification.of(request));
        Set<Post> unAttachPosts = new HashSet<>();

        for (Post post : allPosts) {
            if (!activePosts.contains(post))
                unAttachPosts.add(post);
        }

        Set<PostDTO.Info> postInfoSet = new HashSet<>();
        Optional.ofNullable(unAttachPosts)
                .ifPresent(posts1 ->
                        posts1.forEach(post1 ->
                                postInfoSet.add(modelMapper.map(post1, PostDTO.Info.class))
                        ));

        return postInfoSet;

    }

    @Override
    @Transactional
    public void removePosts(Long postGroupId, Set<Long> postIds) {
        for (long postId : postIds) {
            removePost(postGroupId, postId);
        }
    }

    @Override
    @Transactional
    public void removeTrainingPosts(Long postGroupId, Set<Long> trainingPostIds) {
        for (long trainingPostId : trainingPostIds) {
            removeTrainingPost(postGroupId, trainingPostId);
        }
    }

//    @Override
//    @Transactional
//    public List<PostDTO.Info> getPosts(Long postGroupId) {
//        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        return modelMapper.map(postGroup.getPostSet(), new TypeToken<List<PostDTO.Info>>() {
//        }.getType());
//    }

    @Override
    @Transactional(readOnly = true)
    public List<PostGroup> getPostGroupsByTrainingPostId(Long trainingPost) {
        List<Long> ids = postGroupDAO.getAllPostGroupIdByTrainingPostId(trainingPost);
        return postGroupDAO.findAllById(ids);
    }
}
