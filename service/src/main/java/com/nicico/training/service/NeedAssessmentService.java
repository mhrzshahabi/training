/*
ghazanfari_f, 9/7/2019, 10:57 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedAssessmentDTO;
import com.nicico.training.iservice.INeedAssessmentService;
import com.nicico.training.model.Competence;
import com.nicico.training.model.NeedAssessment;
import com.nicico.training.model.Post;
import com.nicico.training.model.Skill;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.NeedAssessmentDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.SkillDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NeedAssessmentService implements INeedAssessmentService {

    private final NeedAssessmentDAO needAssessmentDAO;
    private final PostDAO postDAO;
    private final CompetenceDAO competenceDAO;
    private final SkillDAO skillDAO;
    private final ModelMapper modelMapper;
    private final EnumsConverter.EDomainTypeConverter eDomainTypeConverter = new EnumsConverter.EDomainTypeConverter();
    private final EnumsConverter.ENeedAssessmentPriorityConverter eNeedAssessmentInputTypeConverter = new EnumsConverter.ENeedAssessmentPriorityConverter();

    @Transactional(readOnly = true)
    @Override
    public NeedAssessmentDTO.Info get(Long id) {
        final Optional<NeedAssessment> optionalNeedAssessment = needAssessmentDAO.findById(id);
        final NeedAssessment needAssessment = optionalNeedAssessment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NeedAssessmentNotFound));
        return modelMapper.map(needAssessment, NeedAssessmentDTO.Info.class);
    }

    @Transactional
    @Override
    public NeedAssessmentDTO.Info create(NeedAssessmentDTO.Create request) {
        final Optional<Post> optionalPost = postDAO.findById(request.getPostId());
        final Post post = optionalPost.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.PostNotFound));

        final Optional<Competence> optionalCompetence = competenceDAO.findById(request.getCompetenceId());
        final Competence competence = optionalCompetence.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        final Optional<Skill> optionalSkill = skillDAO.findById(request.getSkillId());
        final Skill skill = optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));

        NeedAssessment needAssessment = modelMapper.map(request, NeedAssessment.class);
        needAssessment.setEDomainType(eDomainTypeConverter.convertToEntityAttribute(request.getEdomainTypeId()));
        needAssessment.setENeedAssessmentPriority(eNeedAssessmentInputTypeConverter.convertToEntityAttribute(request.getEneedAssessmentPriorityId()));
        return modelMapper.map(needAssessmentDAO.saveAndFlush(needAssessment), NeedAssessmentDTO.Info.class);
    }

    @Transactional
    @Override
    public NeedAssessmentDTO.Info update(Long id, NeedAssessmentDTO.Update request) {
        Optional<NeedAssessment> optionalNeedAssessment = needAssessmentDAO.findById(id);
        NeedAssessment currentNeedAssessment = optionalNeedAssessment.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NeedAssessmentNotFound));

        NeedAssessment needAssessment = new NeedAssessment();
        modelMapper.map(currentNeedAssessment, needAssessment);
        modelMapper.map(request, needAssessment);
        return modelMapper.map(needAssessmentDAO.saveAndFlush(needAssessment), NeedAssessmentDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        needAssessmentDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(NeedAssessmentDTO.Delete request) {
        final List<NeedAssessment> needAssessmentList = needAssessmentDAO.findAllById(request.getIds());
        needAssessmentDAO.deleteAll(needAssessmentList);
    }

    @Transactional(readOnly = true)
    @Override
    public List<NeedAssessmentDTO.Info> list() {
        List<NeedAssessment> needAssessmentList = needAssessmentDAO.findAll();
        return modelMapper.map(needAssessmentList, new TypeToken<List<NeedAssessmentDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<NeedAssessmentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(needAssessmentDAO, request, needAssessment -> modelMapper.map(needAssessment, NeedAssessmentDTO.Info.class));
    }

}
