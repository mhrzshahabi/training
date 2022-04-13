package com.nicico.training.service.needsassessment.impl;

import com.nicico.training.model.NeedsAssessmentTemp;
import com.nicico.training.repository.needsassessment.NeedsAssessmentTempRepo;
import com.nicico.training.service.needsassessment.NeedsAssessmentTempService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class NeedsAssessmentTempServiceImpl implements NeedsAssessmentTempService {

    private final NeedsAssessmentTempRepo repo;

    public NeedsAssessmentTempServiceImpl(NeedsAssessmentTempRepo repo) {
        this.repo = repo;
    }

    @Override
    public void update(NeedsAssessmentTemp temp) {
        repo.save(temp);
    }

    @Override
    public NeedsAssessmentTemp get(long id) {
        return repo.findById(id).get();
    }

    @Override
    public void removeUnCompleteNa(String code,String status) {
        List<NeedsAssessmentTemp> list= repo.findAllByObjectCodeAndMainWorkflowStatus(code,status);
        repo.deleteAll(list);
    }

}
