/*
ghazanfari_f,
1/14/2020,
1:58 PM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.model.NeedsAssessmentTemp;
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

@RequiredArgsConstructor
@Service
public class NeedsAssessmentTempService extends BaseService<NeedsAssessmentTemp, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentTempDAO> {

    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;

    @Autowired
    NeedsAssessmentTempService(NeedsAssessmentTempDAO needsAssessmentTempDAO) {
        super(new NeedsAssessmentTemp(), needsAssessmentTempDAO);
    }

    @Transactional(readOnly = true)
    public Boolean isReadOnlyObject(Long objectId, String objectType) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        return needsAssessmentTemps != null && needsAssessmentTemps.size() > 0;
    }

    @Transactional
    public void initial(String objectType, Long objectId) {
        List<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAll(NICICOSpecification.of(getCriteria(objectType, objectId)));
        dao.saveAll(modelMapper.map(needsAssessments, new TypeToken<List<NeedsAssessmentTemp>>() {
        }.getType()));
    }


    @Transactional
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId)));
        needsAssessmentDAO.saveAll(modelMapper.map(needsAssessmentTemps, new TypeToken<List<NeedsAssessment>>() {
        }.getType()));
        dao.deleteAll(needsAssessmentTemps);
    }

    @Transactional
    public void rollback(String objectType, Long objectId) {
        dao.deleteAll(dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId))));
    }

    @Transactional
    public NeedsAssessmentDTO.Info create(Boolean isFirstChange, NeedsAssessmentDTO.Create rq) {
        if (isFirstChange) {
            initial(rq.getObjectType(), rq.getObjectId());
        }
        Optional<NeedsAssessmentTemp> optionalNA = dao.findFirstByObjectIdAndObjectTypeAndCompetenceIdAndSkillIdAndNeedsAssessmentDomainIdAndNeedsAssessmentPriorityId(rq.getObjectId(), rq.getObjectType(), rq.getCompetenceId(), rq.getSkillId(), rq.getNeedsAssessmentDomainId(), rq.getNeedsAssessmentPriorityId());
        if (optionalNA.isPresent()) {
            optionalNA.get().setEDeleted(76L);
            return modelMapper.map(dao.save(optionalNA.get()), NeedsAssessmentDTO.Info.class);
        }
        return super.create(rq);
    }

    @Transactional
    public NeedsAssessmentDTO.Info update(Boolean isFirstChange, Long id, NeedsAssessmentDTO.Update rq) {
        if (isFirstChange) {
            final NeedsAssessment entity = needsAssessmentDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            initial(entity.getObjectType(), entity.getObjectId());
        }
        return super.update(id, rq);
    }

    @Transactional
    public NeedsAssessmentDTO.Info delete(Boolean isFirstChange, Long id) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        if (isFirstChange) {
            final NeedsAssessment entity = needsAssessmentDAO.findById(id).orElseThrow(trainingExceptionSupplier);
            initial(entity.getObjectType(), entity.getObjectId());
        }
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp entity = optional.orElseThrow(trainingExceptionSupplier);
        if (needsAssessmentDAO.existsById(id)) {
            entity.setEDeleted(75L);
            dao.saveAndFlush(entity);
            return modelMapper.map(entity, NeedsAssessmentDTO.Info.class);
        } else {
            try {
                dao.deleteById(id);
                return modelMapper.map(entity, NeedsAssessmentDTO.Info.class);
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