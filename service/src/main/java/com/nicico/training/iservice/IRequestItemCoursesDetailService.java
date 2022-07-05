package com.nicico.training.iservice;

import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.model.RequestItemCoursesDetail;

import java.util.List;


public interface IRequestItemCoursesDetailService {

    RequestItemCoursesDetail create(RequestItemCoursesDetailDTO.Create create);

    List<RequestItemCoursesDetailDTO.Info> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId);

    RequestItemCoursesDetailDTO.OpinionInfo findAllOpinionByRequestItemProcessDetailId(Long requestItemProcessDetailId, String chiefOpinion);

    List<RequestItemCoursesDetailDTO.Info> findAllByRequestItem(Long requestItemId);

}
