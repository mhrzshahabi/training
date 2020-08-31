package com.nicico.training.service;

import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.dto.ViewTrainingFileDTO;
import com.nicico.training.model.ViewPost;
import com.nicico.training.model.ViewTrainingFile;
import com.nicico.training.repository.ViewPostDAO;
import com.nicico.training.repository.ViewTrainingFileDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTrainingFileService extends BaseService<ViewTrainingFile, Long, ViewTrainingFileDTO.Info, ViewTrainingFileDTO.Info, ViewTrainingFileDTO.Info, ViewTrainingFileDTO.Info, ViewTrainingFileDAO>{
    @Autowired
    ViewTrainingFileService(ViewTrainingFileDAO viewTrainingFileDAO) {
        super(new ViewTrainingFile(), viewTrainingFileDAO);
    }
}
