package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.model.RequestItem;

import java.util.List;

public interface INeedsAssessmentService {

    List<NeedsAssessmentDTO.Info> list();

    TotalResponse<NeedsAssessmentDTO.Info> search(NICICOCriteria nicicoCriteria);

    SearchDTO.SearchRs<NeedsAssessmentDTO.Info> fullSearch(Long objectId, String objectType);

    SearchDTO.SearchRs<NeedsAssessmentDTO.Info> verifiedNeedsAssessmentList(Long objectId, String objectType);

    SearchDTO.SearchRs<NeedsAssessmentDTO.Info> workflowSearch(Long objectId, String objectType);

    TotalResponse<NeedsAssessmentDTO.Tree> tree(NICICOCriteria nicicoCriteria);

    List<NeedsAssessmentDTO.CourseDetail> findCoursesByTrainingPostCode(String trainingPostCode);

    List<NeedsAssessmentDTO.PlanningExpertsExcel> findCoursesForPlanningExpertsByTrainingPostCode(RequestItem requestItem);
}
