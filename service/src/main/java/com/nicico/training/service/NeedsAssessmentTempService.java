
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.model.NeedsAssessmentTemp;
import com.nicico.training.model.Skill;
import com.nicico.training.repository.NeedsAssessmentDAO;
import com.nicico.training.repository.NeedsAssessmentTempDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentTempService extends BaseService<NeedsAssessmentTemp, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentTempDAO> {

    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;

    private Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

    @Autowired
    NeedsAssessmentTempService(NeedsAssessmentTempDAO needsAssessmentTempDAO) {
        super(new NeedsAssessmentTemp(), needsAssessmentTempDAO);
    }

    @Transactional
    public void initial(String objectType, Long objectId) {
        List<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return;
        needsAssessments.forEach(needsAssessment -> {
            NeedsAssessmentTemp needsAssessmentTemp = new NeedsAssessmentTemp();
            modelMapper.map(needsAssessment, needsAssessmentTemp);
            dao.saveAndFlush(needsAssessmentTemp);
        });
    }

    @Transactional
    public Boolean copyNA(String sourceObjectType, Long sourceObjectId, String objectType, Long objectId) {
        switch (readOnlyStatus(objectType, objectId)) {
            case 0:
                initial(objectType, objectId);
                break;
            case 2:
                return false;
        }
        List<Skill> skillList = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId))).stream().map(NeedsAssessment::getSkill).collect(Collectors.toList());
        List<NeedsAssessment> sourceNeedsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(sourceObjectType, sourceObjectId)));
        sourceNeedsAssessments.forEach(sourceNA -> {
            if (!skillList.contains(sourceNA.getSkill())) {
                NeedsAssessmentDTO.Create newNA = new NeedsAssessmentDTO.Create();
                modelMapper.map(sourceNA, newNA);
                newNA.setObjectId(objectId).setObjectType(objectType);
                create(newNA);
            }
        });
        return true;
    }


    @Transactional
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentDTO.verify> needsAssessmentTemps = modelMapper.map(dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId))), new TypeToken<List<NeedsAssessmentDTO.verify>>() {
        }.getType());
        needsAssessmentTemps.forEach(needsAssessmentTemp -> {
            Optional<NeedsAssessment> optional = needsAssessmentDAO.findById(needsAssessmentTemp.getId());
            if (optional.isPresent()) {
                if (needsAssessmentTemp.getEDeleted() != null && needsAssessmentTemp.getEDeleted().equals(75L))
                    needsAssessmentDAO.deleteById(needsAssessmentTemp.getId());
                else {
                    modelMapper.map(needsAssessmentTemp, optional.get());
                    needsAssessmentDAO.saveAndFlush(optional.get());
                }
            } else {
                NeedsAssessment needsAssessment = new NeedsAssessment();
                modelMapper.map(needsAssessmentTemp, needsAssessment);
                needsAssessmentDAO.saveAndFlush(needsAssessment);
            }
        });
        dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional
    public void rollback(String objectType, Long objectId) {
        dao.deleteAllByObjectIdAndObjectType(objectId, objectType);
    }

    @Transactional(readOnly = true)
    public Integer readOnlyStatus(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null || needsAssessmentTemps.isEmpty())
            return 0; //this object is editable and needs to be initialize
        if (needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername()))
            return 1; //this object is editable and dont needs to be initialize
        return 2; //this object is read only
    }

    @Transactional(readOnly = true)
    public Boolean isEditable(String objectType, Long objectId) {
        switch (readOnlyStatus(objectType, objectId)) {
            case 0:
                initial(objectType, objectId);
                return true;
            case 1:
                return true;
            case 2:
                return false;
        }
        return false;
    }

    @Override
    @Transactional
    public NeedsAssessmentDTO.Info create(NeedsAssessmentDTO.Create rq) {
        Optional<NeedsAssessmentTemp> optionalNA = dao.findFirstByObjectIdAndObjectTypeAndCompetenceIdAndSkillIdAndNeedsAssessmentDomainIdAndNeedsAssessmentPriorityId(rq.getObjectId(), rq.getObjectType(), rq.getCompetenceId(), rq.getSkillId(), rq.getNeedsAssessmentDomainId(), rq.getNeedsAssessmentPriorityId());
        if (optionalNA.isPresent()) {
            optionalNA.get().setEDeleted(null);
            return modelMapper.map(dao.saveAndFlush(optionalNA.get()), NeedsAssessmentDTO.Info.class);
        }
        rq.setId(needsAssessmentDAO.getNextId());
        return super.create(rq);
    }

    @Override
    @Transactional
    public NeedsAssessmentDTO.Info delete(Long id) {
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp entityTemp = optional.orElseThrow(trainingExceptionSupplier);
        if (needsAssessmentDAO.existsById(id)) {
            entityTemp.setEDeleted(75L);
            dao.saveAndFlush(entityTemp);
            return modelMapper.map(entityTemp, NeedsAssessmentDTO.Info.class);
        } else {
            try {
                dao.deleteById(id);
                return modelMapper.map(entityTemp, NeedsAssessmentDTO.Info.class);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.NotDeletable);
            }
        }
    }

    public static SearchDTO.CriteriaRq getCriteria(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        return criteriaRq;
    }
}