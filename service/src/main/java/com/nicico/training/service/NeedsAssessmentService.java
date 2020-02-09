/*
ghazanfari_f,
1/14/2020,
1:58 PM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.repository.NeedsAssessmentDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class NeedsAssessmentService extends BaseService<NeedsAssessment, Long, NeedsAssessmentDTO.Info, NeedsAssessmentDTO.Create, NeedsAssessmentDTO.Update, NeedsAssessmentDTO.Delete, NeedsAssessmentDAO> {

    @Autowired
    private CompetenceService competenceService;

    @Autowired
    private ParameterValueService parameterValueService;

    @Autowired
    NeedsAssessmentService(NeedsAssessmentDAO competenceDAO) {
        super(new NeedsAssessment(), competenceDAO);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<NeedsAssessmentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(dao, request, na -> modelMapper.map(na, NeedsAssessmentDTO.Info.class));
    }

    @Transactional
    public NeedsAssessmentDTO.Info checkAndCreate(NeedsAssessmentDTO.Create rq) {
        if (!competenceService.isExist(rq.getCompetenceId())) {
            throw new TrainingException(TrainingException.ErrorType.CompetenceNotFound);
        }
        if (!parameterValueService.isExist(rq.getNeedsAssessmentDomainId())) {
            throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentDomainNotFound);
        }
        if (!parameterValueService.isExist(rq.getNeedsAssessmentPriorityId())) {
            throw new TrainingException(TrainingException.ErrorType.NeedsAssessmentPriorityNotFound);
        }
        return create(rq);
    }
}