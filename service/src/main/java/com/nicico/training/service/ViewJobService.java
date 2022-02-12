package com.nicico.training.service;

import com.nicico.training.dto.ViewjobDTO;
import com.nicico.training.iservice.IViewJobService;
import com.nicico.training.model.ViewJob;
import com.nicico.training.repository.ViewJobDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewJobService extends BaseService<ViewJob, Long, ViewjobDTO.Info, ViewjobDTO.Info, ViewjobDTO.Info, ViewjobDTO.Info, ViewJobDAO> implements IViewJobService {

    @Autowired
    ViewJobService(ViewJobDAO viewJobDAO) {
        super(new ViewJob(), viewJobDAO);
    }

}
