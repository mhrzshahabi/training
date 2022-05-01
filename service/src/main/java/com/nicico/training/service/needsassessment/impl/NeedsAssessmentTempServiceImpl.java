package com.nicico.training.service.needsassessment.impl;

import com.nicico.training.dto.NeedAssessmentTempDTO;
import com.nicico.training.model.NeedsAssessmentTemp;
import com.nicico.training.repository.needsassessment.NeedsAssessmentTempRepo;
import com.nicico.training.service.needsassessment.NeedsAssessmentTempService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

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

    @Override
    public boolean removeUnCompleteNaByCode(String code) {
        boolean b=true;
        List<NeedsAssessmentTemp> list=repo.findByObjectCode(code);
        try{
            repo.deleteAll(list);
        }catch(Exception ex){
            b=false;
        }
        return b;
    }

    @Override
    public NeedAssessmentTempDTO getAllNeedAssessmentTemp(String code) {
    List<NeedsAssessmentTemp> temps=  repo.findByObjectCode(code);
        NeedAssessmentTempDTO dto=new NeedAssessmentTempDTO();
      if(temps!=null && temps.size()>0){
        Optional<NeedsAssessmentTemp> findFirst=  temps.stream().findFirst();
       if( findFirst.isPresent())
           dto.setCreatedBy(findFirst.get().getCreatedBy());
           dto.setMainWorkStatus(findFirst.get().getMainWorkflowStatus());

      }
      return dto;
    }


}
