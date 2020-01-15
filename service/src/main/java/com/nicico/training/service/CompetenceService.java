/*
ghazanfari_f,
1/14/2020,
1:58 PM
*/
package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.model.Competence;
import com.nicico.training.repository.CompetenceDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}