package com.nicico.training.service.needsassessment;

import com.nicico.training.dto.NeedAssessmentTempDTO;
import com.nicico.training.model.NeedsAssessmentTemp;

public interface NeedsAssessmentTempService {
    void update(NeedsAssessmentTemp temp);
    void updateLimitSufficiency(String objectType, Long objectId,Long id,Long limitSufficiency);
    NeedsAssessmentTemp get(long id);

    void removeUnCompleteNa(String code,String status);
    boolean removeUnCompleteNaByCode(String code);
    NeedAssessmentTempDTO getAllNeedAssessmentTemp(String code);
}
