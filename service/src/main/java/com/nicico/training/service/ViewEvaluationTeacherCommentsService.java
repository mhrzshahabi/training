package com.nicico.training.service;



import com.nicico.training.dto.ViewEvaluationCommentsDTO;


import com.nicico.training.model.ViewEvaluationTeacherComments;

import com.nicico.training.repository.ViewEvaluationTeacherCommentsDAO;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



@RequiredArgsConstructor
@Service
public class ViewEvaluationTeacherCommentsService extends BaseService<ViewEvaluationTeacherComments, Long, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationTeacherCommentsDAO> {

    @Autowired
    ViewEvaluationTeacherCommentsService(ViewEvaluationTeacherCommentsDAO viewEvaluationTeacherCommentsDAO) {
        super(new ViewEvaluationTeacherComments(), viewEvaluationTeacherCommentsDAO);
    }
}
