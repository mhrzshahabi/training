package com.nicico.training.service;


import com.nicico.training.dto.ViewEvaluationCommentsDTO;
import com.nicico.training.model.ViewEvaluationPersonnelComments;
import com.nicico.training.model.ViewEvaluationTeacherComments;
import com.nicico.training.repository.ViewEvaluationPersonnelCommentsDAO;
import com.nicico.training.repository.ViewEvaluationTeacherCommentsDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@RequiredArgsConstructor
@Service
public class ViewEvaluationPersonnelCommentsService extends BaseService<ViewEvaluationPersonnelComments, Long, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationCommentsDTO.Info, ViewEvaluationPersonnelCommentsDAO> {

    @Autowired
    ViewEvaluationPersonnelCommentsService(ViewEvaluationPersonnelCommentsDAO evaluationPersonnelCommentsDAO) {
        super(new ViewEvaluationPersonnelComments(), evaluationPersonnelCommentsDAO);
    }
}
