package com.nicico.training.service;

import com.nicico.training.dto.ViewPostGradeGroupDTO;
import com.nicico.training.iservice.IViewPostGradeGroupService;
import com.nicico.training.model.ViewPostGradeGroup;
import com.nicico.training.repository.ViewPostGradeGroupDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewPostGradeGroupService extends BaseService<ViewPostGradeGroup, Long, ViewPostGradeGroupDTO.Info, ViewPostGradeGroupDTO.Info, ViewPostGradeGroupDTO.Info, ViewPostGradeGroupDTO.Info, ViewPostGradeGroupDAO> implements IViewPostGradeGroupService {
    @Autowired
    ViewPostGradeGroupService(ViewPostGradeGroupDAO viewPostGradeGroupDAO) {
        super(new ViewPostGradeGroup(), viewPostGradeGroupDAO);
    }

}
