
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;

import com.nicico.training.dto.PostGradeDTO;
import com.nicico.training.dto.PostGradeGroupDTO;
import com.nicico.training.iservice.IPostGradeGroupService;
import com.nicico.training.model.PostGrade;
import com.nicico.training.model.PostGradeGroup;
import com.nicico.training.repository.PostGradeDAO;
import com.nicico.training.repository.PostGradeGroupDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.function.Supplier;

@Service
@RequiredArgsConstructor
public class PostGradeGroupService implements IPostGradeGroupService {

    private final PostGradeGroupDAO postGradeGroupDAO;
    private final ModelMapper modelMapper;
    private final PostGradeDAO postGradeDAO;

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
        return modelMapper.map(postGradeGroupDAO.saveAndFlush(postGradeGroup), PostGradeGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public PostGradeGroupDTO.Info update(Long id, PostGradeGroupDTO.Update request) {
        Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(id);
        PostGradeGroup currentPostGradeGroup = optionalPostGradeGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        PostGradeGroup postGradeGroup = new PostGradeGroup();
        modelMapper.map(currentPostGradeGroup, postGradeGroup);
        modelMapper.map(request, postGradeGroup);
        return modelMapper.map(postGradeGroupDAO.saveAndFlush(postGradeGroup), PostGradeGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        postGradeGroupDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(PostGradeGroupDTO.Delete request) {
        final List<PostGradeGroup> postGradeGroupList = postGradeGroupDAO.findAllById(request.getIds());
        postGradeGroupDAO.deleteAll(postGradeGroupList);
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
        return SearchUtil.search(postGradeGroupDAO, request, postGradeGroup -> modelMapper.map(postGradeGroup, PostGradeGroupDTO.Info.class));
    }

    @Transactional
    @Override
    public List<PostGradeDTO.Info> getPostGrades(Long postGradeGroupId) {
        final Optional<PostGradeGroup> optionalPostGradeGroup = postGradeGroupDAO.findById(postGradeGroupId);
        final PostGradeGroup postGradeGroup = optionalPostGradeGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Set<PostGrade> postGrades = postGradeGroup.getPostGradeSet();
        ArrayList<PostGradeDTO.Info> postGradeList = new ArrayList<>();
        for (PostGrade postGrade : postGrades) {
            postGradeList.add(modelMapper.map(postGrade, PostGradeDTO.Info.class));
        }
        return postGradeList;
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
