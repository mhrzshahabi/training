package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.PostGradeGroupDTO;
import com.nicico.training.iservice.IPostGradeGroupService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.PostGrade;
import com.nicico.training.model.PostGradeGroup;
import com.nicico.training.model.PostGroup;
import com.nicico.training.repository.PostGradeDAO;
import com.nicico.training.repository.PostGradeGroupDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class PostGradeGroupService implements IPostGradeGroupService {

    private final PostGradeGroupDAO postGradeGroupDAO;
    private final ModelMapper modelMapper;
    private final PostGradeDAO postGradeDAO;
    private final IWorkGroupService workGroupService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final NeedsAssessmentService needsAssessmentService;

    @Transactional(readOnly = true)
    @Override
    public PostGradeGroupDTO.Info get(Long id) {
        final Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(id);
        final PostGradeGroup postGradeGroup = optionalPostGradeGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(postGradeGroup, PostGradeGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public PostGradeGroupDTO.Info create(PostGradeGroupDTO.Create request) {
        PostGradeGroup postGradeGroup = modelMapper.map(request, PostGradeGroup.class);
        try {
            return modelMapper.map(postGradeGroupDAO.saveAndFlush(postGradeGroup), PostGradeGroupDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public PostGradeGroupDTO.Info update(Long id, PostGradeGroupDTO.Update request) {
        Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(id);
        PostGradeGroup currentPostGradeGroup = optionalPostGradeGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        PostGradeGroup postGradeGroup = new PostGradeGroup();
        modelMapper.map(currentPostGradeGroup, postGradeGroup);
        modelMapper.map(request, postGradeGroup);
        try {
            return modelMapper.map(postGradeGroupDAO.saveAndFlush(postGradeGroup), PostGradeGroupDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        if (needsAssessmentService.checkBeforeDeleteObject("PostGradeGroup", id) && needsAssessmentTempService.checkBeforeDeleteObject("PostGradeGroup", id))
            try {
                postGradeGroupDAO.deleteById(id);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.NotDeletable);
            }
        else
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
    }

    @Transactional
    @Override
    public void delete(PostGradeGroupDTO.Delete request) {
        request.getIds().forEach(id -> delete(id));
//        final List<PostGradeGroup> postGradeGroupList = postGradeGroupDAO.findAllById(request.getIds());
//        postGradeGroupDAO.deleteAll(postGradeGroupList);
    }

    @Transactional(readOnly = true)
    @Override
    public List<PostGradeGroupDTO.Info> list() {
        List<PostGradeGroup> postGradeGroupList = postGradeGroupDAO.findAll();
        return modelMapper.map(postGradeGroupList, new TypeToken<List<PostGradeGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGradeGroupDTO.Info> search(SearchDTO.SearchRq request) {
        setCriteria(request, workGroupService.applyPermissions(PostGradeGroup.class, SecurityUtil.getUserId()));
        return SearchUtil.search(postGradeGroupDAO, request, postGradeGroup -> modelMapper.map(postGradeGroup, PostGradeGroupDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostGradeGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(postGradeGroupDAO, request, postGradeGroup -> modelMapper.map(postGradeGroup, PostGradeGroupDTO.Info.class));
    }

    @Transactional
    @Override
    public List<PostGradeDTO.Info> getPostGrades(Long postGradeGroupId) {
        final Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(postGradeGroupId);
        final PostGradeGroup postGradeGroup = optionalPostGradeGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return postGradeGroup.getPostGradeSet().stream().filter(pg -> pg.getDeleted() == null).map(postGrade -> modelMapper.map(postGrade, PostGradeDTO.Info.class)).collect(Collectors.toList());
    }

    @Transactional
    @Override
    public void removePostGrades(Long postGradeGroupId, Set<Long> postGradeIds) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

        final Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(postGradeGroupId);
        final PostGradeGroup postGradeGroup = optionalPostGradeGroup.orElseThrow(trainingExceptionSupplier);

        for (long postGradeId : postGradeIds) {
            final Optional<PostGrade> optionalPost = postGradeDAO.findById(postGradeId);
            final PostGrade postGrade = optionalPost.orElseThrow(trainingExceptionSupplier);
            postGradeGroup.getPostGradeSet().remove(postGrade);
        }
    }


    @Override
    @Transactional(readOnly = true)
    public List<PostGradeGroup> getPostGradeGroupsByTrainingPostId(Long id) {
        List<Long> ids = postGradeGroupDAO.getAllPostGroupIdByPostGradeId(id);
        return postGradeGroupDAO.findAllById(ids);
    }

    @Transactional
    @Override
    public void addPostGrades(Long postGradeGroupId, Set<Long> postGradeIds) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

        final Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(postGradeGroupId);
        final PostGradeGroup postGradeGroup = optionalPostGradeGroup.orElseThrow(trainingExceptionSupplier);

        for (Long postGradeId : postGradeIds) {
            final Optional<PostGrade> optionalPost = postGradeDAO.findById(postGradeId);
            final PostGrade postGrade = optionalPost.orElseThrow(trainingExceptionSupplier);
            postGradeGroup.getPostGradeSet().add(postGrade);
        }
    }

}
