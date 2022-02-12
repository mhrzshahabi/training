package com.nicico.training.service;

import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.IViewTrainingPostService;
import com.nicico.training.model.ViewTrainingPost;
import com.nicico.training.repository.ViewTrainingPostDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTrainingPostService extends BaseService<ViewTrainingPost, Long, ViewTrainingPostDTO.Info, ViewTrainingPostDTO.Info, ViewTrainingPostDTO.Info, ViewTrainingPostDTO.Info, ViewTrainingPostDAO> implements IViewTrainingPostService {

    @Autowired
    ViewTrainingPostService(ViewTrainingPostDAO viewTrainingPostDAO) {
        super(new ViewTrainingPost(), viewTrainingPostDAO);
    }
}
