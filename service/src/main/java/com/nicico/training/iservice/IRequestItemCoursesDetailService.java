package com.nicico.training.iservice;

import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.model.RequestItemCoursesDetail;
import response.BaseResponse;

import java.util.List;
import java.util.Set;


public interface IRequestItemCoursesDetailService {

    RequestItemCoursesDetail create(RequestItemCoursesDetailDTO.Create create);

    RequestItemCoursesDetail findById(Long id);

    void save(RequestItemCoursesDetail requestItemCoursesDetail);

    List<RequestItemCoursesDetailDTO.Info> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId);

    RequestItemCoursesDetailDTO.OpinionInfo findAllOpinionByRequestItemProcessDetailId(Long requestItemProcessDetailId, String chiefOpinion, Long chiefOpinionId);

    List<RequestItemCoursesDetailDTO.Info> findAllByRequestItem(Long requestItemId);

    BaseResponse updateCoursesDetailAfterRunSupervisorReview(String processInstanceId, String taskId, String courseCode);

    BaseResponse updateCoursesDetailAfterRunExpertManualReview(String processInstanceId, String courseCode);

    void approveCompleteTasks();

    Set<Long> getByNationalCodeAndClassId(Long classId, String userNationalCode);

}
