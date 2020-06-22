/*
ghazanfari_f,
1/14/2020,
1:58 PM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
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

    private Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

    @Autowired
    NeedsAssessmentTempService(NeedsAssessmentTempDAO needsAssessmentTempDAO) {
        super(new NeedsAssessmentTemp(), needsAssessmentTempDAO);
    }

    @Transactional(readOnly = true)
    public Boolean isReadOnlyObject(Long objectId, String objectType) {
        SearchDTO.CriteriaRq criteriaRq = getCriteria(objectType, objectId);
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(criteriaRq));
        if (needsAssessmentTemps == null)
            return false;
        return needsAssessmentTemps.size() > 0 && !needsAssessmentTemps.get(0).getCreatedBy().equals(SecurityUtil.getUsername());
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
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(NICICOSpecification.of(getCriteria(objectType, objectId)));
        needsAssessmentTemps.forEach(needsAssessmentTemp -> {
            Optional<NeedsAssessment> optional = needsAssessmentDAO.findById(needsAssessmentTemp.getId());
            if (optional.isPresent()) {
                if (needsAssessmentTemp.getEDeleted().equals(75L))
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
//        needsAssessmentDAO.saveAll(modelMapper.map(needsAssessmentTemps, new TypeToken<List<NeedsAssessment>>() {
//        }.getType()));
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
            optionalNA.get().setEDeleted(null);
            dao.recycle(optionalNA.get().getId());
            return modelMapper.map(optionalNA.get(), NeedsAssessmentDTO.Info.class);
        }
        rq.setId(needsAssessmentDAO.getNextId());
        NeedsAssessmentTemp needsAssessmentTemp = new NeedsAssessmentTemp();
        modelMapper.map(rq, needsAssessmentTemp);
        return modelMapper.map(dao.saveAndFlush(needsAssessmentTemp), NeedsAssessmentDTO.Info.class);
    }

    @Transactional
    public NeedsAssessmentDTO.Info update(Boolean isFirstChange, Long id, NeedsAssessmentDTO.Update rq) {
        if (isFirstChange) {
            final NeedsAssessment entity = needsAssessmentDAO.findById(id).orElseThrow(trainingExceptionSupplier);
            initial(entity.getObjectType(), entity.getObjectId());
        }
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp currentEntity = optional.orElseThrow(trainingExceptionSupplier);
        NeedsAssessmentTemp updating = new NeedsAssessmentTemp();
        modelMapper.map(currentEntity, updating);
        modelMapper.map(rq, updating);
        try {
            return modelMapper.map(dao.saveAndFlush(updating), NeedsAssessmentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }

//        return super.update(id, rq);
    }

    @Transactional
    public NeedsAssessmentDTO.Info delete(Boolean isFirstChange, Long id) {
        if (isFirstChange) {
            final NeedsAssessment entity = needsAssessmentDAO.findById(id).orElseThrow(trainingExceptionSupplier);
            initial(entity.getObjectType(), entity.getObjectId());
        }
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp entity = optional.orElseThrow(trainingExceptionSupplier);
        if (needsAssessmentDAO.existsById(id)) {
            entity.setEDeleted(75L);
//            dao.saveAndFlush(entity);
            dao.softDelete(entity.getId());
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