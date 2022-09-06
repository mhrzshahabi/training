package com.nicico.training.iservice;

  import com.nicico.copper.common.dto.search.SearchDTO;
   import com.nicico.training.dto.NeedsAssessmentWithGapDTO;


public interface INeedsAssessmentWithGapService {

    SearchDTO.SearchRs<NeedsAssessmentWithGapDTO.Info> fullSearch(Long objectId, String objectType);

}
