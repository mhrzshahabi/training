package com.nicico.training.service;

import com.nicico.training.dto.ViewPostGroupDTO;
import com.nicico.training.iservice.IViewPostGroupService;
import com.nicico.training.model.ViewPostGroup;
import com.nicico.training.repository.ViewPostGroupDAO;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@RequiredArgsConstructor
@Service
public class ViewPostGroupService extends BaseService<ViewPostGroup, Long, ViewPostGroupDTO.Info, ViewPostGroupDTO.Info, ViewPostGroupDTO.Info, ViewPostGroupDTO.Info, ViewPostGroupDAO> implements IViewPostGroupService {

    @Autowired
    ViewPostGroupService(ViewPostGroupDAO viewPostGroupDAO) {
        super(new ViewPostGroup(), viewPostGroupDAO);
    }

}
