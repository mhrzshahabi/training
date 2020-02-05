package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.model.Evaluation;

import java.util.List;

public interface IEvaluationService {

    EvaluationDTO.Info get(Long id);

    List<EvaluationDTO.Info> list();

    EvaluationDTO.Info create(Object request);

    EvaluationDTO.Info update(Long id, EvaluationDTO.Update request);

    void delete(Long id);

    void delete(EvaluationDTO.Delete request);

    SearchDTO.SearchRs<EvaluationDTO.Info> search(SearchDTO.SearchRq request);

    Evaluation getStudentEvaluationForTeacher(Long classId,Long teacherId,Long studentId);
}
