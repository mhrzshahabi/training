
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.INeedAssessmentSkillBasedService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
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
    private final PostGroupDAO postGroupDAO;
    private final JobDAO jobDAO;
    private final JobGroupDAO jobGroupDAO;

//    private final CompetenceDAO competenceDAO;
//    private final SkillDAO skillDAO;

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

//        final Optional<Skill> optionalSkill = skillDAO.findById(request.getSkillId());
//        final Skill skill = optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        Object object;

//        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

        NeedAssessmentSkillBased needAssessment = modelMapper.map(request, NeedAssessmentSkillBased.class);
        needAssessment.setEneedAssessmentPriority(eNeedAssessmentPriorityConverter.convertToEntityAttribute(request.getEneedAssessmentPriorityId()));

//        switch (needAssessment.getObjectType()) {
//            case "Job":
//                final Optional<Job> optionalJob = jobDAO.findById(needAssessment.getObjectId());
//                object = optionalJob.orElseThrow(trainingExceptionSupplier);
//                break;
//            case "JobGroup":
//                final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(needAssessment.getObjectId());
//                object = optionalJobGroup.orElseThrow(trainingExceptionSupplier);
//                break;
//            case "Post":
//                final Optional<Post> optionalPost = postDAO.findById(needAssessment.getObjectId());
//                object = optionalPost.orElseThrow(trainingExceptionSupplier);
//                break;
//            case "PostGroup":
//                final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(needAssessment.getObjectId());
//                object = optionalPostGroup.orElseThrow(trainingExceptionSupplier);
//                break;
//            default:
//                return null;
//        }
//        needAssessment.setObject(object);
        return modelMapper.map(needAssessmentSkillBasedDAO.saveAndFlush(needAssessment), NeedAssessmentSkillBasedDTO.Info.class);
    }

    @Transactional
    @Override
    public NeedAssessmentSkillBasedDTO.Info update(Long id, NeedAssessmentSkillBasedDTO.Update request) {
        Optional<NeedAssessmentSkillBased> optionalNeedAssessment = needAssessmentSkillBasedDAO.findById(id);
        NeedAssessmentSkillBased currentNeedAssessment = optionalNeedAssessment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        NeedAssessmentSkillBased needAssessment = new NeedAssessmentSkillBased();
        modelMapper.map(currentNeedAssessment, needAssessment);
        modelMapper.map(request, needAssessment);
        List <NeedAssessmentSkillBasedDTO.Info> updated = new ArrayList<>();
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

//    @Transactional
//    @Override
//    public void updatePriority(MultiValueMap<String, String> body) {
//        Long id = Long.parseLong(body.get("id").get(0));
//        NeedAssessmentSkillBased currentNeedAssessment = needAssessmentSkillBasedDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
//        Set<String> strings = body.keySet();
//
//        if (strings.contains("eneedAssessmentPriority")) {
//            String newId = ((body.get("eneedAssessmentPriority").get(0).split("\"id\":"))[1]).split(",")[0];
//            currentNeedAssessment.setEneedAssessmentPriorityId(Integer.valueOf(newId));
//        }
//        needAssessmentSkillBasedDAO.saveAndFlush(currentNeedAssessment);
////        return update(id, modelMapper.map(currentNeedAssessment, NeedAssessmentSkillBasedDTO.Update.class));
//    }

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
    public SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> deepSearch(SearchDTO.SearchRq request) {

        String objectType = null;
        Long objectId = null;

        List<SearchDTO.CriteriaRq> willRemove = new ArrayList<>();
        for (SearchDTO.CriteriaRq criteriaRq : request.getCriteria().getCriteria()) {
            if (criteriaRq.getFieldName().equals("objectType")) {
                objectType = (String) criteriaRq.getValue().get(0);
                willRemove.add(criteriaRq);
            } else if (criteriaRq.getFieldName().equals("objectId")) {
                objectId = Long.valueOf(criteriaRq.getValue().get(0).toString());
                willRemove.add(criteriaRq);
            }
        }
        request.getCriteria().getCriteria().removeAll(willRemove);

        if (objectId == null || objectType == null)
            return null;

        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.or);
        criteriaRq.setCriteria(new ArrayList<>());
        addCriteria(criteriaRq, objectType, objectId);
        request.getCriteria().getCriteria().add(criteriaRq);

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
        criteriaRq.getCriteria().add(makeNewCriteria(objectType, objectId));
        switch (objectType) {
            case "Post":
                Optional<Post> optionalPost = postDAO.findById(objectId);
                Post currentPost = optionalPost.orElseThrow(trainingExceptionSupplier);
                if (currentPost.getJob() != null)
                    addCriteria(criteriaRq, "Job", currentPost.getJob().getId());
                for (PostGroup postGroup : currentPost.getPostGroupSet()) {
                    addCriteria(criteriaRq, "PostGroup", postGroup.getId());
                }
                break;
            case "Job":
                Optional<Job> optionalJob = jobDAO.findById(objectId);
                Job currentJob = optionalJob.orElseThrow(trainingExceptionSupplier);
                for (JobGroup jobGroup : currentJob.getJobGroupSet()) {
                    addCriteria(criteriaRq, "JobGroup", jobGroup.getId());
                }
                break;
        }
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String objectType, Long objectId) {
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();

        SearchDTO.CriteriaRq idRq = new SearchDTO.CriteriaRq();
        idRq.setOperator(EOperator.equals);
        idRq.setFieldName("objectId");
        idRq.setValue(objectId);
        list.add(idRq);

        SearchDTO.CriteriaRq typeRq = new SearchDTO.CriteriaRq();
        typeRq.setOperator(EOperator.equals);
        typeRq.setFieldName("objectType");
        typeRq.setValue(objectType);
        list.add(typeRq);

        SearchDTO.CriteriaRq rq = new SearchDTO.CriteriaRq();
        rq.setOperator(EOperator.and);
        rq.setCriteria(list);

        return rq;
    }


}
