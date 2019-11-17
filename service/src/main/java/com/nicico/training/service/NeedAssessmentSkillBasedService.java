
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.INeedAssessmentSkillBasedService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        Object object;

        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

        NeedAssessmentSkillBased needAssessment = modelMapper.map(request, NeedAssessmentSkillBased.class);
        needAssessment.setEneedAssessmentPriority(eNeedAssessmentPriorityConverter.convertToEntityAttribute(request.getEneedAssessmentPriorityId()));
        switch (needAssessment.getObjectType()) {
            case "Job":
                final Optional<Job> optionalJob = jobDAO.findById(needAssessment.getObjectId());
                object = optionalJob.orElseThrow(trainingExceptionSupplier);
                break;
            case "JobGroup":
                final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(needAssessment.getObjectId());
                object = optionalJobGroup.orElseThrow(trainingExceptionSupplier);
                break;
            case "Post":
                final Optional<Post> optionalPost = postDAO.findById(needAssessment.getObjectId());
                object = optionalPost.orElseThrow(trainingExceptionSupplier);
                break;
            case "PostGroup":
                final Optional<PostGroup> optionalPostGroup = postGroupDAO.findById(needAssessment.getObjectId());
                object = optionalPostGroup.orElseThrow(trainingExceptionSupplier);
                break;
            default:
                return null;
        }
        needAssessment.setObject(object);
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
        return modelMapper.map(needAssessmentSkillBasedDAO.saveAndFlush(needAssessment), NeedAssessmentSkillBasedDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        needAssessmentSkillBasedDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(NeedAssessmentSkillBasedDTO.Delete request) {
        final List<NeedAssessmentSkillBased> needAssessmentList = needAssessmentSkillBasedDAO.findAllById(request.getIds());
        needAssessmentSkillBasedDAO.deleteAll(needAssessmentList);
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
        for (NeedAssessmentSkillBasedDTO.Info test : searchRs.getList()) {
            switch (test.getObjectType()) {
                case "Job":
                    test.setObject(modelMapper.map(test.getObject(), JobDTO.Info.class));
                    break;
                case "Post":
                    test.setObject(modelMapper.map(test.getObject(), PostDTO.Info.class));
                    break;
                case "JobGroup":
                    test.setObject(modelMapper.map(test.getObject(), JobGroupDTO.Info.class));
                    break;
                case "PostGroup":
                    test.setObject(modelMapper.map(test.getObject(), PostGroupDTO.Info.class));
                    break;
            }
        }
        return  searchRs;
    }

}
