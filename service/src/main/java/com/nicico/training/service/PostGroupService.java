package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:16 AM
    */

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.PostGroupDTO;
import com.nicico.training.iservice.IPostGroupService;
import com.nicico.training.model.Post;
import com.nicico.training.model.PostGroup;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.PostGroupDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class PostGroupService implements IPostGroupService {


    private final ModelMapper modelMapper;
    private final PostGroupDAO postGroupDAO;
    private final PostDAO postDAO;
    private final CompetenceDAO competenceDAO;

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
    public PostGroupDTO.Info update(Long id, PostGroupDTO.Update request) {
        final Optional<PostGroup> cById = postGroupDAO.findById(id);
        final PostGroup postGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        PostGroup updating = new PostGroup();
        modelMapper.map(postGroup, updating);
        modelMapper.map(request, updating);

        return modelMapper.map(postGroupDAO.saveAndFlush(updating),PostGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        postGroupDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(PostGroupDTO.Delete request) {
        final List<PostGroup> cAllById = postGroupDAO.findAllById(request.getIds());
        postGroupDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(postGroupDAO, request, postGroup -> modelMapper.map(postGroup, PostGroupDTO.Info.class));
    }

    // ------------------------------

    private PostGroupDTO.Info save(PostGroup postGroup, Set<Long> postIds) {
        final Set<Post> posts = new HashSet<>();
//        final Set<Competence> competences = new HashSet<>();
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
    public List<CompetenceDTO.Info> getCompetence(Long postGroupId) {
        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

//        return modelMapper.map(postGroup.getCompetenceSet(), new TypeToken<List<CompetenceDTO.Info>>() {}.getType());
        return null;
    }

    @Override
    @Transactional
    public List<PostDTO.Info> getPosts(Long postGroupID) {
        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupID);
        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        Set<Competence> competenceSet = postGroup.getCompetenceSet();
        Set<Post> posts = postGroup.getPostSet();
        ArrayList<PostDTO.Info> postList = new ArrayList<>();
        for (Post post : posts) {
            postList.add(modelMapper.map(post,PostDTO.Info.class));
        }
//        PostDTO.Info info = new PostDTO.Info();
//      --------------------------------------- By f.ghazanfari - start ---------------------------------------
//        for (Competence competence:postGroup.getCompetenceSet()
//             ) {
//
//            for (PostCompetence postCompetence:competence.getPostCompetenceSet()
//                 ) {
//                posts.add(postCompetence.getPost());
//
//            }
//        }
//      --------------------------------------- By f.ghazanfari - end ---------------------------------------
        return postList;
//        return infoList;
    }

    @Override
    @Transactional
    public boolean canDelete(Long postGroupId) {
        List<CompetenceDTO.Info> competences = getCompetence(postGroupId);
        if (competences.isEmpty() || competences.size() == 0)
            return true;
        else
            return false;
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
    public void removeFromCompetency(Long postGroupId, Long competenceId) {

//        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
//        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
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
        List<Post> allPosts = postDAO.findAll();
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

//    @Override
//    @Transactional
//    public List<PostDTO.Info> getPosts(Long postGroupId) {
//        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        return modelMapper.map(postGroup.getPostSet(), new TypeToken<List<PostDTO.Info>>() {
//        }.getType());
//    }
}
