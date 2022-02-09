package com.nicico.training.service;

import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.iservice.IViewPostService;
import com.nicico.training.model.ViewPost;
import com.nicico.training.repository.ViewPostDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewPostService extends BaseService<ViewPost, Long, ViewPostDTO.Info, ViewPostDTO.Info, ViewPostDTO.Info, ViewPostDTO.Info, ViewPostDAO> implements IViewPostService {
    @Autowired
    ViewPostService(ViewPostDAO viewPostDAO) {
        super(new ViewPost(), viewPostDAO);
    }
}
