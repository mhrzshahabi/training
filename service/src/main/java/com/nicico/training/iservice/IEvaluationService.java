package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationAnswerDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.EvaluationAnswer;
import com.nicico.training.model.ViewActivePersonnel;
import dto.evaluuation.EvalElsData;
import dto.evaluuation.EvalQuestionDto;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

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

    List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long ClassId, Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluatedIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long classId, Long evaluatedId, Long evaluationLevelId, Long questionnaireTypeId);

    Evaluation findFirstByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long ClassId, Long EvaluatedId, Long EvaluatedTypeId, Long EvaluatorTypeId, Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation> findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long EvaluatorId,
                                                                                                   Long EvaluatorTypeId,
                                                                                                   Long EvaluationLevelId,
                                                                                                   Long QuestionnaireTypeId);

    Optional<ViewActivePersonnel> findById(Long evaluatorId);

    ViewActivePersonnel findPersonnelByPersonnelNo(String personnelId);
}
