package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
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
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.NeedsAssessmentTempService.getCriteria;

@Service
@RequiredArgsConstructor
public class TrainingPostService implements ITrainingPostService {
    @Autowired
    private MessageSource messageSource;

    private final JobDAO jobDAO;
    private final PostDAO postDAO;
    private final ModelMapper modelMapper;
    private final PostGradeDAO postGradeDAO;
    private final DepartmentDAO departmentDAO;
    private final TrainingPostDAO trainingPostDAO;
    private final ViewPostService viewPostService;
    private final PersonnelService personnelService;
    private final NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final NeedsAssessmentWithGapDAO needsAssessmentWithGapDAO;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TrainingPostDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(trainingPostDAO, request, model -> modelMapper.map(model, TrainingPostDTO.Info.class));
    }


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
    @Transactional
    @Override
    public TrainingPostDTO.Info getTrainingPost(Long trainingPostID) {
        final Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findById(trainingPostID);
        final TrainingPost trainingPost = optionalTrainingPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TrainingPostNotFound));
        return modelMapper.map(trainingPost, TrainingPostDTO.Info.class);

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
    public boolean delete(Long id) {
        if (needsAssessmentService.checkBeforeDeleteObject("TrainingPost", id) &&
                needsAssessmentTempService.checkBeforeDeleteObject("TrainingPost", id) &&
                checkGapBeforeDeleteObject( id)
        ) {
            trainingPostDAO.deleteById(id);
            return true;
        }

        return false;
    }

    private boolean checkGapBeforeDeleteObject( Long id) {
        List<NeedsAssessmentWithGap> needsAssessments = needsAssessmentWithGapDAO.findAll(NICICOSpecification.of(getCriteria("TrainingPost", id, true)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return true;
        if (needsAssessments.get(0).getMainWorkflowStatusCode() == null) {
            needsAssessmentWithGapDAO.deleteAllByObjectIdAndObjectType(id, "TrainingPost");
            return true;
        }
        return false;
    }

    @Override
    public boolean updateToUnDeleted(Long id) {
        try {
            TrainingPost currentEntity = trainingPostDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            currentEntity.setId(id);
            currentEntity.setDeleted(null);
            currentEntity.setEnabled(null);
            trainingPostDAO.save(currentEntity);
            return true;
        }catch (Exception e){
            return false;
        }

    }

    @Override
    public boolean updateToUnDeleted(String code) {
        try {
            TrainingPost currentEntity = trainingPostDAO.findFirstByCode(code).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            currentEntity.setId(currentEntity.getId());
            currentEntity.setDeleted(null);
            currentEntity.setEnabled(null);
            trainingPostDAO.save(currentEntity);
            return true;
        }catch (Exception e){
            return false;
        }
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

    public List<String> getAllArea() {
        return trainingPostDAO.findAllArea();
    }

    @Override
    public Optional<TrainingPost> isTrainingPostExist(String trainingPostCode) {
        return trainingPostDAO.findByCodeAndDeleted(trainingPostCode, null);
    }

    @Transactional(readOnly = true)
    @Override
    public TrainingPostDTO.needAssessmentInfo getNeedAssessmentInfo(String trainingPostCode) {
        Optional<TrainingPost> optionalTrainingPost = trainingPostDAO.findByCodeAndDeleted(trainingPostCode, null);
        if (optionalTrainingPost.isPresent())
            return modelMapper.map(optionalTrainingPost.get(), TrainingPostDTO.needAssessmentInfo.class);
        else
            throw new TrainingException(TrainingException.ErrorType.NotFound);
    }

    @Transactional
    @Override
    public Boolean updateTrainingPostDeletionStatus(Long trainingPostId) {
        TrainingPost trainingPost = trainingPostDAO.findById(trainingPostId)
                .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        if (trainingPost.getDeleted() != null && trainingPost.getDeleted() == 75) {
            trainingPostDAO.setNullToDeleted(trainingPostId);
            return true;
        }

        return false;
    }


    @Override
    @Transactional(readOnly = true)
    public List<TrainingPost> getTrainingPostWithPostId(Long id) {
        List<Long> ids = trainingPostDAO.getAllTrainingPostIdByPostId(id);
        return trainingPostDAO.findAllById(ids);
    }

    @Override
    @Transactional
    public Boolean updateTrainingPostFromPost(Long trainingPostId, Long postId) {

        try {
            TrainingPost trainingPost = trainingPostDAO.findById(trainingPostId)
                    .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            Post post = postDAO.findById(postId)
                    .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            if (post.getCode()!=null &&  post.getCode().contains("/")){
                String code = post.getCode().substring(0, post.getCode().indexOf("/"));

                if (code.equals(trainingPost.getCode())) {
                    trainingPost.setDepartmentId(post.getDepartmentId());
                    trainingPost.setAssistance(post.getAssistance());
                    trainingPost.setAffairs(post.getAffairs());
                    trainingPost.setSection(post.getSection());
                    trainingPost.setUnit(post.getUnit());
                    trainingPost.setJob(post.getJob());
                    trainingPost.setPostGrade(post.getPostGrade());
                    trainingPost.setCostCenterCode(post.getCostCenterCode());
                    trainingPost.setCostCenterTitleFa(post.getCostCenterTitleFa());
                    trainingPost.setTitleFa(post.getTitleFa());
                    trainingPostDAO.save(trainingPost);
                    return true;
                }
            }
            return false;
        } catch (TrainingException e) {
            return false;
        }
    }


    @Scheduled(cron = "0 30 17 1/1 * ?")
    public void changeTrainingPostStatus() {

        try {
            List<Long> postIds=    trainingPostDAO.getDeletedPost();
            if (postIds.size()>0){
                postIds.forEach(this::updateToUnDeleted);
            }
         } catch (Exception e) {
             e.printStackTrace();
        }

    }

}
