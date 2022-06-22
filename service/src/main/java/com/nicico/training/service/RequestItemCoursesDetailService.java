package com.nicico.training.service;

import com.nicico.training.dto.RequestItemCoursesDetailDTO;
import com.nicico.training.iservice.IRequestItemCoursesDetailService;
import com.nicico.training.model.RequestItemCoursesDetail;
import com.nicico.training.repository.RequestItemCoursesDetailDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class RequestItemCoursesDetailService implements IRequestItemCoursesDetailService {

    private final ModelMapper modelMapper;
    private final RequestItemCoursesDetailDAO requestItemCoursesDetailDAO;

    @Override
    public RequestItemCoursesDetail create(RequestItemCoursesDetailDTO.Create create) {
        RequestItemCoursesDetail requestItemCoursesDetail = modelMapper.map(create, RequestItemCoursesDetail.class);
        return requestItemCoursesDetailDAO.saveAndFlush(requestItemCoursesDetail);
    }

    @Override
    public List<RequestItemCoursesDetailDTO.Info> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId) {
        List<RequestItemCoursesDetail> requestItemCoursesDetails = requestItemCoursesDetailDAO.findAllByRequestItemProcessDetailId(requestItemProcessDetailId);
        return modelMapper.map(requestItemCoursesDetails, new TypeToken<List<RequestItemCoursesDetailDTO.Info>>(){}.getType());
    }

}
