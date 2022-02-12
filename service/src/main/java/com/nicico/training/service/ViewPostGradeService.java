package com.nicico.training.service;

import com.nicico.training.dto.ViewPostGradeDTO;
import com.nicico.training.iservice.IViewPostGradeService;
import com.nicico.training.model.ViewPostGrade;
import com.nicico.training.repository.ViewPostGradeDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewPostGradeService extends BaseService<ViewPostGrade, Long, ViewPostGradeDTO.Info, ViewPostGradeDTO.Info, ViewPostGradeDTO.Info, ViewPostGradeDTO.Info, ViewPostGradeDAO> implements IViewPostGradeService {

    @Autowired
    ViewPostGradeService(ViewPostGradeDAO viewPostGradeDAO) {
        super(new ViewPostGrade(), viewPostGradeDAO);
    }
}
