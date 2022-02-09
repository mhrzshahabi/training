package com.nicico.training.service;

import com.nicico.training.dto.ViewClassDetailDTO;
import com.nicico.training.iservice.IViewClassDetailService;
import com.nicico.training.model.ViewClassDetail;
import com.nicico.training.repository.ViewClassDetailDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewClassDetailService extends BaseService<ViewClassDetail, Long, ViewClassDetailDTO.Info, ViewClassDetailDTO.Info, ViewClassDetailDTO.Info, ViewClassDetailDTO.Info, ViewClassDetailDAO> implements IViewClassDetailService {

    @Autowired
    ViewClassDetailService(ViewClassDetailDAO viewClassDetailDAO) {
        super(new ViewClassDetail(), viewClassDetailDAO);
    }

}
