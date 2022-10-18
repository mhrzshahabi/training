package com.nicico.training.iservice;

import com.nicico.training.dto.RequestItemProcessDetailDTO;
import com.nicico.training.model.RequestItemProcessDetail;

import java.util.List;

public interface IRequestItemProcessDetailService {

    RequestItemProcessDetail get(Long id);

    List<RequestItemProcessDetail> findAllByRequestItemId(Long requestItemId);

    RequestItemProcessDetail findByRequestItemIdAndExpertNationalCode(Long requestItemId, String expertNationalCode);

    RequestItemProcessDetail findFirstByRequestItemIdAndRoleName(Long requestItemId, String roleName);

    List<RequestItemProcessDetail> findByRequestItemIdAndRoleName(Long requestItemId, String roleName);

    RequestItemProcessDetail create(RequestItemProcessDetailDTO.Create create);

    void updateOpinion(Long id, Long opinionId);
}
