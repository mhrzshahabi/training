package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.model.Evaluation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface IEvaluationService {

    EvaluationDTO.Info get(Long id);

    List<EvaluationDTO.Info> list();

    EvaluationDTO.Info create(EvaluationDTO.Create request);

    EvaluationDTO.Info update(Long id, EvaluationDTO.Update request);

    void delete(Long id);

    void delete(EvaluationDTO.Delete request);

    SearchDTO.SearchRs<EvaluationDTO.Info> search(SearchDTO.SearchRq request);

    Evaluation getStudentEvaluationForClass(Long classId,Long studentId);

    Evaluation getTeacherEvaluationForClass(Long teacherId,Long classId);

    Evaluation getTrainingEvaluationForTeacher(Long teacherId, Long classId, Long trainingId);

    Evaluation getTrainingEvaluationForTeacherCustomized(Long teacherId, Long classId);

    Evaluation getBehavioralEvaluationByStudent(Long studentId, Long classId);

    EvaluationDTO.Info getEvaluationByData(Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId, Long evaluatedTypeId, Long evaluationLevelId);

    Boolean deleteEvaluation(@RequestBody HashMap req);

    void deleteAllReactionEvaluationForms(Long classId);

    double getEvaluationFormGrade(Evaluation evaluation);

    List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationFormAnswerDetail(Evaluation evaluation);

    EvaluationDTO.BehavioralResult getBehavioralEvaluationResult(Long classId);

}
