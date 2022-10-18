package com.nicico.training.service;

import com.nicico.training.dto.RequestItemProcessDetailDTO;
import com.nicico.training.iservice.IRequestItemProcessDetailService;
import com.nicico.training.model.RequestItemProcessDetail;
import com.nicico.training.repository.RequestItemProcessDetailDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RequestItemProcessDetailService implements IRequestItemProcessDetailService {

    private final ModelMapper modelMapper;
    private final RequestItemProcessDetailDAO requestItemProcessDetailDAO;

    @Override
    public RequestItemProcessDetail get(Long id) {
        return requestItemProcessDetailDAO.findById(id).orElse(null);
    }

    @Override
    public List<RequestItemProcessDetail> findAllByRequestItemId(Long requestItemId) {
        return requestItemProcessDetailDAO.findAllByRequestItemId(requestItemId);
    }

    @Override
    public RequestItemProcessDetail findByRequestItemIdAndExpertNationalCode(Long requestItemId, String expertNationalCode) {
        return requestItemProcessDetailDAO.findFirstByRequestItemIdAndExpertNationalCode(requestItemId, expertNationalCode).orElse(null);
    }

    @Override
    public RequestItemProcessDetail findFirstByRequestItemIdAndRoleName(Long requestItemId, String roleName) {
        return requestItemProcessDetailDAO.findFirstByRequestItemIdAndRoleName(requestItemId, roleName).orElse(null);
    }

    @Override
    public List<RequestItemProcessDetail> findByRequestItemIdAndRoleName(Long requestItemId, String roleName) {
        return requestItemProcessDetailDAO.findByRequestItemIdAndRoleName(requestItemId, roleName);
    }

    @Override
    @Transactional
    public RequestItemProcessDetail create(RequestItemProcessDetailDTO.Create create) {
        RequestItemProcessDetail requestItemProcessDetail = modelMapper.map(create, RequestItemProcessDetail.class);
        return requestItemProcessDetailDAO.saveAndFlush(requestItemProcessDetail);
    }

    @Override
    @Transactional
    public void updateOpinion(Long id, Long opinionId) {
        RequestItemProcessDetail requestItemProcessDetail = get(id);
        if (requestItemProcessDetail != null) {
            requestItemProcessDetail.setExpertsOpinionId(opinionId);
            requestItemProcessDetailDAO.saveAndFlush(requestItemProcessDetail);
        }
    }
}
