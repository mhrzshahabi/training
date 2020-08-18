package com.nicico.training.service;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ITrainingPostService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.UniqueConstraint;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class TrainingPostService implements ITrainingPostService {
    @Autowired
    private MessageSource messageSource;

    private final ModelMapper modelMapper;
    private final TrainingPostDAO trainingPostDAO;
    private final PostDAO postDAO;
    private final PersonnelService personnelService;
    private final PostService postService;
    private final ViewPostService viewPostService;
    private final DepartmentDAO departmentDAO;
    private final JobDAO jobDAO;
    private final PostGradeDAO postGradeDAO;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final NeedsAssessmentService needsAssessmentService;

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
        return modelMapper.map(posts.stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Override
    public List<PostDTO.Info> getNullPosts() {
        List<ViewPostDTO.Info> nullViewPosts = viewPostService.search(new SearchDTO.SearchRq().setCriteria(makeNewCriteria("trainingPostSet", null, EOperator.isNull, null))).getList();
        return modelMapper.map(nullViewPosts.stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public List<PersonnelDTO.Info> getPersonnel(Long trainingPostID) {
        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        List<PersonnelDTO.Info> infoList = new ArrayList<>();
        Set<Post> posts = trainingPost.getPostSet();
        posts = posts.stream().filter(post -> post.getDeleted() == null).collect(Collectors.toSet());
        if (posts != null && posts.size() > 0) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteria.getCriteria().add(makeNewCriteria("postId", posts.stream().map(Post::getId).collect(Collectors.toList()), EOperator.inSet, null));
            criteria.getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
            infoList = personnelService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        }
        return infoList;
    }

    @Transactional
    @Override
    public TrainingPostDTO create(TrainingPostDTO.Create create, HttpServletResponse response) throws IOException {
        try {
            return modelMapper.map(trainingPostDAO.save(convertDTO2Obj(create)), TrainingPostDTO.class);
        }
//        catch (TrainingException e){
//            Locale locale = LocaleContextHolder.getLocale();
//            if(e.getErrorCode().equals(TrainingException.ErrorType.DepartmentNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در دپارتمان", null, locale));
//            else if(e.getErrorCode().equals(TrainingException.ErrorType.JobNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در شغل", null, locale));
//            else if(e.getErrorCode().equals(TrainingException.ErrorType.PostGradeNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در رده پستی", null, locale));
//        }
        catch (Exception e) {
            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("exception.un-managed", null, locale));
        }
        return null;
    }

    @Transactional
    @Override
    public TrainingPostDTO update(Long id, TrainingPostDTO.Update update, HttpServletResponse response) throws IOException {
        try {
            TrainingPost currentEntity = trainingPostDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            modelMapper.getConfiguration().setSkipNullEnabled(true);
            modelMapper.map(convertDTO2Obj(update), currentEntity);
            if (update.getEnabled() == null)
                currentEntity.setEnabled(null);
            return modelMapper.map(currentEntity, TrainingPostDTO.class);
        }
//        catch (TrainingException e){
//            Locale locale = LocaleContextHolder.getLocale();
//            if(e.getErrorCode().equals(TrainingException.ErrorType.DepartmentNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در دپارتمان", null, locale));
//            else if(e.getErrorCode().equals(TrainingException.ErrorType.JobNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در شغل", null, locale));
//            else if(e.getErrorCode().equals(TrainingException.ErrorType.PostGradeNotFound))
//                response.sendError(404, messageSource.getMessage("خطا در رده پستی", null, locale));
//            else if(e.getErrorCode().equals(TrainingException.ErrorType.PostGradeNotFound))
//                response.sendError(404, messageSource.getMessage("exception.record.not−found", null, locale));
//        }
        catch (Exception e) {
            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("exception.un-managed", null, locale));
        }
        return null;
    }

    @Transactional
    @Override
    public void delete(Long id) {
        if (needsAssessmentService.checkBeforeDeleteObject("TrainingPost", id) && needsAssessmentTempService.checkBeforeDeleteObject("TrainingPost", id))
            trainingPostDAO.deleteById(id);
        else
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
    }

    private TrainingPost convertDTO2Obj(TrainingPostDTO trainingPostDTO) throws Exception {
        Department department = trainingPostDTO.getDepartmentId() == null ? null : departmentDAO.findById(trainingPostDTO.getDepartmentId()).orElse(null);//.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.DepartmentNotFound));
        Job job = trainingPostDTO.getJobId() == null ? null : jobDAO.findById(trainingPostDTO.getJobId()).orElse(null);//.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
        PostGrade postGrade = trainingPostDTO.getPostGradeId() == null ? null : postGradeDAO.findById(trainingPostDTO.getPostGradeId()).orElse(null);//.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGradeNotFound));
        final TrainingPost entity = new TrainingPost();
        if (department != null) {
            entity.setArea(department.getHozeTitle());
            entity.setAssistance(department.getMoavenatTitle());
            entity.setAffairs(department.getOmorTitle());
            entity.setSection(department.getGhesmatTitle());
            entity.setUnit(department.getVahedTitle());
            entity.setCostCenterCode(department.getCode());
            entity.setCostCenterTitleFa(department.getTitle());
            entity.setDepartmentId(department.getId());
        }
        if (job != null)
            entity.setJob(job);
        if (postGrade != null)
            entity.setPostGrade(postGrade);
        entity.setCode(trainingPostDTO.getCode());
        entity.setTitleFa(trainingPostDTO.getTitleFa());
        entity.setPeopleType(trainingPostDTO.getPeopleType());
        entity.setEnabled(trainingPostDTO.getEnabled());
        return entity;
    }
}
