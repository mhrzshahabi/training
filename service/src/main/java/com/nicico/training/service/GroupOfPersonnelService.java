package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.GroupOfPersonnelDTO;
import com.nicico.training.iservice.IGroupOfPersonnelService;
import com.nicico.training.model.GroupOfPersonnel;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.GroupOfPersonnelDAO;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.exam.ResendExamTimes;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class GroupOfPersonnelService implements IGroupOfPersonnelService {


    private final ModelMapper modelMapper;
    private final GroupOfPersonnelDAO groupOfPersonnelDao;
    private final PersonnelDAO personnelDAO;
//    private final PostDAO postDAO;
//    private final TrainingPostDAO trainingPostDAO;
//    private final IWorkGroupService workGroupService;
//    private final NeedsAssessmentTempService needsAssessmentTempService;
//    private final NeedsAssessmentService needsAssessmentService;

    //    @Transactional(readOnly = true)
//    @Override
//    public PostGroupDTO.Info get(Long id) {
//
//        final Optional<PostGroup> cById = postGroupDAO.findById(id);
//        final PostGroup postGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        return modelMapper.map(postGroup, PostGroupDTO.Info.class);
//    }
//
//    @Transactional(readOnly = true)
//    @Override
//    public List<PostGroupDTO.Info> list() {
//        final List<PostGroup> cAll = postGroupDAO.findAll();
//
//        return modelMapper.map(cAll, new TypeToken<List<PostGroupDTO.Info>>() {
//        }.getType());
//    }
//
    @Transactional
    @Override
    public BaseResponse create(GroupOfPersonnelDTO.Create request) {
        BaseResponse response = new ResendExamTimes();
        Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findFirstByCode(request.getCode());
        if (optionalGroupOfPersonnel.isPresent()) {
            response.setMessage("امکان ایجاد گروه با کد تکراری وجود ندارد .");
            response.setStatus(406);
        } else {
            final GroupOfPersonnel groupOfPersonnel = modelMapper.map(request, GroupOfPersonnel.class);
            try {
                groupOfPersonnelDao.save(groupOfPersonnel);
                response.setStatus(200);
            } catch (Exception e) {
                response.setMessage("عملیات انجام نشد .");
                response.setStatus(404);
            }
            ;
        }

        return response;

    }

    //
//    @Transactional
//    @Override
//    public void addPost(Long postId, Long postGroupId) {
//        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        final Optional<Post> postById = postDAO.findById(postId);
//        final Post post = postById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
//        postGroup.getPostSet().add(post);
//    }
//
//    @Transactional
//    @Override
//    public void addTrainingPost(Long trainingPostId, Long postGroupId) {
//        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        final Optional<TrainingPost> TrainingPostById = trainingPostDAO.findById(trainingPostId);
//        final TrainingPost trainingPost = TrainingPostById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
//        postGroup.getTrainingPostSet().add(trainingPost);
//    }
//
//
//    @Transactional
//    @Override
//    public void addPosts(Long postGroupId, Set<Long> postIds) {
//
//        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        Set<Post> postSet = postGroup.getPostSet();
//
//        for (Long postId : postIds) {
//
//            final Optional<Post> optionalPost = postDAO.findById(postId);
//            final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
//            postSet.add(post);
//        }
//        postGroup.setPostSet(postSet);
//    }
//
//
//    @Transactional
//    @Override
//    public void addTrainingPosts(Long postGroupId, Set<Long> trainingPostIds) {
//
//        final Optional<PostGroup> postGroupById = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = postGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        Set<TrainingPost> trainingPostSet = postGroup.getTrainingPostSet();
//
//        for (Long trainingPostId : trainingPostIds) {
//
//            final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostId);
//            final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
//            trainingPostSet.add(trainingPost);
//        }
//        postGroup.setTrainingPostSet(trainingPostSet);
//    }
//
//
    @Transactional
    @Override
    public BaseResponse update(Long id, GroupOfPersonnelDTO.Update request) {
        BaseResponse response = new ResendExamTimes();

        final Optional<GroupOfPersonnel> cById = groupOfPersonnelDao.findById(id);
        if (cById.isEmpty()) {
            response.setMessage("تیم وجود ندارد .");
            response.setStatus(406);
        } else {
            try {
                GroupOfPersonnel updating = new GroupOfPersonnel();
                modelMapper.map(cById.get(), updating);
                modelMapper.map(request, updating);
                Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findFirstByCode(updating.getCode());
                if (optionalGroupOfPersonnel.isPresent()) {
                    response.setMessage("امکان ایجاد گروه با کد تکراری وجود ندارد .");
                    response.setStatus(406);
                } else {
                    groupOfPersonnelDao.save(updating);
                    response.setStatus(200);
                }
            } catch (Exception e) {
                response.setMessage("عملیات انجام نشد .");
                response.setStatus(404);
            }
            ;
        }
        return response;
    }

    //
    @Transactional
    @Override
    public BaseResponse delete(Long id) {
        BaseResponse response = new ResendExamTimes();

        try {
            groupOfPersonnelDao.deleteById(id);
            response.setStatus(200);
        } catch (Exception e) {
            response.setMessage("عملیات انجام نشد .");
            response.setStatus(404);
        }
        return response;

    }

    //    @Transactional
//    @Override
//    public void delete(PostGroupDTO.Delete request) {
//        request.getIds().forEach(this::delete);
////        final List<PostGroup> cAllById = postGroupDAO.findAllById(request.getIds());
////        postGroupDAO.deleteAll(cAllById);
//    }
//
//    @Transactional(readOnly = true)
//    @Override
//    public SearchDTO.SearchRs<PostGroupDTO.Info> search(SearchDTO.SearchRq request) {
//        setCriteria(request, workGroupService.applyPermissions(PostGroup.class, SecurityUtil.getUserId()));
//        return SearchUtil.search(postGroupDAO, request, postGroup -> modelMapper.map(postGroup, PostGroupDTO.Info.class));
//    }
//
    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GroupOfPersonnelDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(groupOfPersonnelDao, request, group -> modelMapper.map(group, GroupOfPersonnelDTO.Info.class));
    }

    @Override
    public List<Long> getPersonnel(Long id) {
        final GroupOfPersonnel groupOfPersonnel = groupOfPersonnelDao.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        return groupOfPersonnelDao.getAllPersonnelByGroupId(groupOfPersonnel.getId());
    }

    @Override
    @Transactional
    public void addPersonnel(Long groupId, Set<Long> ids) {
        final Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findById(groupId);
        final GroupOfPersonnel groupOfPersonnel = optionalGroupOfPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<Personnel> personnelSet = groupOfPersonnel.getPersonnelSet();

        for (Long id : ids) {

            final Optional<Personnel> optionalPersonnel = personnelDAO.findById(id);
            final Personnel post = optionalPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
            personnelSet.add(post);
        }
//        postGroup.setPostSet(postSet);
    }
//
//    // ------------------------------


//
//    @Override
//    @Transactional
//    public List<PostDTO.Info> getPosts(Long postGroupID) {
//        final PostGroup postGroup = postGroupDAO.findById(postGroupID).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        return modelMapper.map(postGroup.getPostSet().stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
//        }.getType());
//    }
//
//    @Override
//    @Transactional
//    public List<TrainingPostDTO.Info> getTrainingPosts(Long postGroupID) {
//        final PostGroup postGroup = postGroupDAO.findById(postGroupID).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        return modelMapper.map(postGroup.getTrainingPostSet().stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<TrainingPostDTO.Info>>() {
//        }.getType());
//    }
//
//    @Override
//    @Transactional
//    public void removePost(Long postGroupId, Long postId) {
//        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        final Optional<Post> optionalPost = postDAO.findById(postId);
//        final Post post = optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
//        postGroup.getPostSet().remove(post);
//    }
//
//    @Override
//    @Transactional
//    public void removeTrainingPost(Long postGroupId, Long trainingPostId) {
//        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostId);
//        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
//        postGroup.getTrainingPostSet().remove(trainingPost);
//    }
//
//    @Override
//    @Transactional
//    public void removeFromCompetency(Long postGroupId, Long competenceId) {
//
////        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
////        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
////        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
////        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
////        postGroup.getCompetenceSet().remove(competence);
//    }
//
//    @Override
//    @Transactional
//    public void removeFromAllCompetences(Long postGroupId) {
//
////        Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
////        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
////        postGroup.getCompetenceSet().clear();
//
//    }
//
//    @Override
//    @Transactional
//    public Set<PostDTO.Info> unAttachPosts(Long postGroupId) {
//        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
//        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
//
//        Set<Post> activePosts = postGroup.getPostSet();
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//        BaseService.setCriteriaToNotSearchDeleted(request);
//        List<Post> allPosts = postDAO.findAll(NICICOSpecification.of(request));
//        Set<Post> unAttachPosts = new HashSet<>();
//
//        for (Post post : allPosts) {
//            if (!activePosts.contains(post))
//                unAttachPosts.add(post);
//        }
//
//        Set<PostDTO.Info> postInfoSet = new HashSet<>();
//        Optional.ofNullable(unAttachPosts)
//                .ifPresent(posts1 ->
//                        posts1.forEach(post1 ->
//                                postInfoSet.add(modelMapper.map(post1, PostDTO.Info.class))
//                        ));
//
//        return postInfoSet;
//
//    }
//
//    @Override
//    @Transactional
//    public void removePosts(Long postGroupId, Set<Long> postIds) {
//        for (long postId : postIds) {
//            removePost(postGroupId, postId);
//        }
//    }
//
//    @Override
//    @Transactional
//    public void removeTrainingPosts(Long postGroupId, Set<Long> trainingPostIds) {
//        for (long trainingPostId : trainingPostIds) {
//            removeTrainingPost(postGroupId, trainingPostId);
//        }
//    }
//
////    @Override
////    @Transactional
////    public List<PostDTO.Info> getPosts(Long postGroupId) {
////        final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(postGroupId);
////        final PostGroup postGroup = optionalPostGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
////        return modelMapper.map(postGroup.getPostSet(), new TypeToken<List<PostDTO.Info>>() {
////        }.getType());
////    }
//
//    @Override
//    @Transactional(readOnly = true)
//    public List<PostGroup> getPostGroupsByTrainingPostId(Long trainingPost) {
//        List<Long> ids = postGroupDAO.getAllPostGroupIdByTrainingPostId(trainingPost);
//        return postGroupDAO.findAllById(ids);
//    }
}
