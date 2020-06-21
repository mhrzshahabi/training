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

@RequiredArgsConstructor
@Service
public class NeedsAssessmentTempService extends BaseService<NeedsAssessmentTemp, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentTempDAO> {

    //    @Autowired
//    private CompetenceService competenceService;
//
//    @Autowired
//    private ParameterValueService parameterValueService;
//
    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;
//
//    @Autowired
//    private NeedsAssessmentReportsService needsAssessmentReportsService;

    @Autowired
    NeedsAssessmentTempService(NeedsAssessmentTempDAO needsAssessmentTempDAO) {
        super(new NeedsAssessmentTemp(), needsAssessmentTempDAO);
    }

    @Transactional
    public void initial(String objectType, Long objectId) {
        List<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAll(getNICICOSpec(objectType, objectId));
        dao.saveAll(modelMapper.map(needsAssessments, new TypeToken<List<NeedsAssessmentTemp>>() {
        }.getType()));
    }


    @Transactional
    public void verify(String objectType, Long objectId) {
        List<NeedsAssessmentTemp> needsAssessmentTemps = dao.findAll(getNICICOSpec(objectType, objectId));
        needsAssessmentDAO.saveAll(modelMapper.map(needsAssessmentTemps, new TypeToken<List<NeedsAssessment>>() {
        }.getType()));
        dao.deleteAll(needsAssessmentTemps);
    }

    @Override
    @Transactional
    public NeedsAssessmentDTO.Info delete(Long id) {
        final Optional<NeedsAssessmentTemp> optional = dao.findById(id);
        final NeedsAssessmentTemp entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if (needsAssessmentDAO.existsById(id)) {
            entity.setEDeleted(1L);
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

    private NICICOSpecification getNICICOSpec(String objectType, Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        return NICICOSpecification.of(criteriaRq);
    }
}