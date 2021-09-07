package com.nicico.training.service;


import com.nicico.training.dto.ViewEvaluationCommentsDTO;
import com.nicico.training.model.ViewEvaluationStudentComments;
import com.nicico.training.repository.ViewEvaluationStudentCommentsDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@RequiredArgsConstructor
@Service
public class ViewEvaluationStudentCommentsService extends BaseService<ViewEvaluationStudentComments, Long, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationStudentCommentsDAO> {

    @Autowired
    ViewEvaluationStudentCommentsService(ViewEvaluationStudentCommentsDAO viewEvaluationStudentCommentsDAO) {
        super(new ViewEvaluationStudentComments(), viewEvaluationStudentCommentsDAO);
    }
}
