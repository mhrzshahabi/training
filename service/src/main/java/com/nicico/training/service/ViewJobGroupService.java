package com.nicico.training.service;

import com.nicico.training.dto.ViewJobGroupDTO;
import com.nicico.training.iservice.IViewJobGroupService;
import com.nicico.training.model.ViewJobGroup;
import com.nicico.training.repository.ViewJobGroupDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewJobGroupService extends BaseService<ViewJobGroup, Long, ViewJobGroupDTO.Info, ViewJobGroupDTO.Info, ViewJobGroupDTO.Info, ViewJobGroupDTO.Info, ViewJobGroupDAO> implements IViewJobGroupService {

    @Autowired
    ViewJobGroupService(ViewJobGroupDAO viewJobGroupDAO) {
        super(new ViewJobGroup(), viewJobGroupDAO);
    }

}
