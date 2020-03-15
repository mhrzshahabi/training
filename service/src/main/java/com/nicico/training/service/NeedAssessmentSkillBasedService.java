package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.INeedAssessmentSkillBasedService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.JobDAO;
import com.nicico.training.repository.NeedAssessmentSkillBasedDAO;
import com.nicico.training.repository.PostDAO;
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
import java.util.function.Supplier;

@Service
@RequiredArgsConstructor
public class NeedAssessmentSkillBasedService implements INeedAssessmentSkillBasedService {

    private final PostDAO postDAO;
    private final JobDAO jobDAO;

    private final NeedAssessmentSkillBasedDAO needAssessmentSkillBasedDAO;
    private final ModelMapper modelMapper;
    private final EnumsConverter.ENeedAssessmentPriorityConverter eNeedAssessmentPriorityConverter = new EnumsConverter.ENeedAssessmentPriorityConverter();

    @Transactional(readOnly = true)
    @Override
    public NeedAssessmentSkillBasedDTO.Info get(Long id) {
        final Optional<NeedAssessmentSkillBased> optionalNeedAssessment = needAssessmentSkillBasedDAO.findById(id);
        final NeedAssessmentSkillBased needAssessment = optionalNeedAssessment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(needAssessment, NeedAssessmentSkillBasedDTO.Info.class);
    }

    @Transactional
    @Override
    public NeedAssessmentSkillBasedDTO.Info create(NeedAssessmentSkillBasedDTO.Create request) {
        NeedAssessmentSkillBased needAssessment = modelMapper.map(request, NeedAssessmentSkillBased.class);
        needAssessment.setEneedAssessmentPriority(eNeedAssessmentPriorityConverter.convertToEntityAttribute(request.getEneedAssessmentPriorityId()));
        try {
            return modelMapper.map(needAssessmentSkillBasedDAO.saveAndFlush(needAssessment), NeedAssessmentSkillBasedDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public NeedAssessmentSkillBasedDTO.Info update(Long id, NeedAssessmentSkillBasedDTO.Update request) {
        Optional<NeedAssessmentSkillBased> optionalNeedAssessment = needAssessmentSkillBasedDAO.findById(id);
        NeedAssessmentSkillBased currentNeedAssessment = optionalNeedAssessment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        NeedAssessmentSkillBased needAssessment = new NeedAssessmentSkillBased();
        modelMapper.map(currentNeedAssessment, needAssessment);
        modelMapper.map(request, needAssessment);
        List<NeedAssessmentSkillBasedDTO.Info> updated = new ArrayList<>();
        try {
            updated.add(modelMapper.map(needAssessmentSkillBasedDAO.saveAndFlush(needAssessment),
                    NeedAssessmentSkillBasedDTO.Info.class));
            setObjectType(updated);
            return updated.get(0);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            needAssessmentSkillBasedDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(NeedAssessmentSkillBasedDTO.Delete request) {
        final List<NeedAssessmentSkillBased> needAssessmentList = needAssessmentSkillBasedDAO.findAllById(request.getIds());
        try {
            needAssessmentSkillBasedDAO.deleteAll(needAssessmentList);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public List<NeedAssessmentSkillBasedDTO.Info> list() {
        List<NeedAssessmentSkillBased> needAssessmentList = needAssessmentSkillBasedDAO.findAll();
        return modelMapper.map(needAssessmentList, new TypeToken<List<NeedAssessmentSkillBasedDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> searchRs = SearchUtil.search(needAssessmentSkillBasedDAO, request, needAssessment -> modelMapper.map(needAssessment,
                NeedAssessmentSkillBasedDTO.Info.class));
        setObjectType(searchRs.getList());
        return searchRs;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> deepSearch(SearchDTO.SearchRq request, String objectType, Long objectId) {

        if (objectId != null && objectType != null) {

            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
            addCriteria(criteriaRq, objectType, objectId);

            List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else {
                    criteriaRqList.add(criteriaRq);
                    request.getCriteria().setCriteria(criteriaRqList);
                }
            } else
                request.setCriteria(criteriaRq);
        }

        SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> searchRs = SearchUtil.search(needAssessmentSkillBasedDAO, request, needAssessment -> modelMapper.map(needAssessment,
                NeedAssessmentSkillBasedDTO.Info.class));
        setObjectType(searchRs.getList());

        return searchRs;
    }

    private void setObjectType(List<NeedAssessmentSkillBasedDTO.Info> searchRs) {
        for (NeedAssessmentSkillBasedDTO.Info object : searchRs) {
            switch (object.getObjectType()) {
                case "Job":
                    object.setObject(modelMapper.map(object.getObject(), JobDTO.Info.class));
                    break;
                case "Post":
                    object.setObject(modelMapper.map(object.getObject(), PostDTO.Info.class));
                    break;
                case "JobGroup":
                    object.setObject(modelMapper.map(object.getObject(), JobGroupDTO.Info.class));
                    break;
                case "PostGroup":
                    object.setObject(modelMapper.map(object.getObject(), PostGroupDTO.Info.class));
                    break;
            }
        }
    }

    private void addCriteria(SearchDTO.CriteriaRq criteriaRq, String objectType, Long objectId) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.and, list));
        switch (objectType) {
            case "Post":
                Optional<Post> optionalPost = postDAO.findById(objectId);
                Post currentPost = optionalPost.orElseThrow(trainingExceptionSupplier);
                if (currentPost.getJob() != null)
                    addCriteria(criteriaRq, "Job", currentPost.getJob().getId());
                currentPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId()));
                break;
            case "Job":
                Optional<Job> optionalJob = jobDAO.findById(objectId);
                Job currentJob = optionalJob.orElseThrow(trainingExceptionSupplier);
                currentJob.getJobGroupSet().forEach(jobGroup -> addCriteria(criteriaRq, "JobGroup", jobGroup.getId()));
                break;
        }
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

}
