/*
ghazanfari_f,
1/14/2020,
1:58 PM
*/
package com.nicico.training.service;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.model.Competence;
import com.nicico.training.repository.CompetenceDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class CompetenceService extends BaseService<Competence, Long, CompetenceDTO.Info, CompetenceDTO.Create, CompetenceDTO.Update, CompetenceDTO.Delete, CompetenceDAO> {

    @Autowired
    private CompetenceService competenceService;
    @Autowired
    private ParameterValueService parameterValueService;

    @Autowired
    CompetenceService(CompetenceDAO competenceDAO) {
        super(new Competence(), competenceDAO);
    }

    @Transactional
    public CompetenceDTO.Info checkAndCreate(CompetenceDTO.Create rq) {
        Long competenceTypeId = rq.getCompetenceTypeId();
        if (parameterValueService.isExist(competenceTypeId)) {
            return create(rq);
        }
        throw new TrainingException(TrainingException.ErrorType.CompetenceTypeNotFound);
    }

    @Override
    @Transactional
    public CompetenceDTO.Info delete(Long id) {
        final Optional<Competence> optional = dao.findById(id);
        final Competence entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        if (!entity.getCreatedBy().equals(SecurityUtil.getUsername()))
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        try {
            dao.deleteById(id);
            return modelMapper.map(entity, CompetenceDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
}