package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.EvaluationAnswer;
import dto.evaluuation.EvalElsData;
import dto.evaluuation.EvalQuestionDto;
import org.springframework.web.bind.annotation.RequestBody;
import response.BaseResponse;

import java.util.HashMap;
import java.util.List;
import java.util.Set;

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

    Double getEvaluationFormGrade(Evaluation evaluation);

    List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationFormAnswerDetail(Evaluation evaluation);

    EvaluationDTO.BehavioralResult getBehavioralEvaluationResult(Long classId);

    Evaluation getById(long id);

    List<EvalQuestionDto> getEvaluationQuestions(List<EvaluationAnswer> answers);

    EvalElsData GetTeacherElsData( HashMap req);
    EvalElsData GetStudentElsData( HashMap req);

    List<Long> getAllReactionEvaluationForms(Long classId);

    Boolean classHasEvaluationForm(Long classId);

    List<EvaluationAnswerDTO.EvaluationAnswerFullData> getEvaluationForm(HashMap req);

    List<Evaluation> getEvaluationsByEvaluatorNationalCode(String evaluatorNationalCode, Long EvaluatorTypeId , String evaluatorType);

 }
