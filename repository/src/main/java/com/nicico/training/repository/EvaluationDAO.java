package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:2:37 PM
*/

import com.nicico.training.model.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface EvaluationDAO extends JpaRepository<Evaluation, Long>, JpaSpecificationExecutor<Evaluation> {
    List<Evaluation> findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(Long classId, Long evaluatorId, Long evaluatorTypeId);

    List<Evaluation> findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(Long classId, Long evaluatorId,
                                                                                                              Long evaluatorTypeId, Long EvaluatedId, Long EvaluatedTypeId);

    Evaluation findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(
            Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId,
            Long evaluatedTypeId, Long evaluationLevelId);

    List<Evaluation> findByClassIdAndEvaluatorTypeIdAndEvaluatorIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long classId,
                                                                                                       Long evaluatorTypeId,
                                                                                                       Long evaluatorId,
                                                                                                       Long evaluationLevelId,
                                                                                                       Long questionnaireTypeId);

    List<Evaluation>  findEvaluationByClassIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(Long classId,Long evaluatorTypeId, Long EvaluatedId, Long EvaluatedTypeId);

    List<Evaluation> findByClassIdAndEvaluatedIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long classId,Long evaluatedId, Long evaluationLevelId, Long questionnaireTypeId);

    List<Evaluation> findByQuestionnaireId(Long questionnarieId);

    Evaluation  findFirstByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
            Long ClassId,Long EvaluatedId, Long EvaluatedTypeId,Long EvaluatorTypeId,Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation>  findByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
            Long ClassId,Long EvaluatedId, Long EvaluatedTypeId,Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndStatus(Long ClassId,
                                                                                                             Long EvaluationLevelId,
                                                                                                             Long QuestionnaireTypeId,
                                                                                                             Long EvaluatedId,
                                                                                                             Long EvaluatedTypeId,
                                                                                                             Boolean Status);

    List<Evaluation> findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long EvaluatorId,
                                                                                                   Long EvaluatorTypeId,
                                                                                                   Long EvaluationLevelId,
                                                                                                   Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long ClassId, Long EvaluationLevelId, Long QuestionnaireTypeId);



    Optional<Evaluation> findTopByClassIdAndQuestionnaireTypeId(Long ClassId, Long typeId);
    List<Evaluation> findAllByClassIdAndQuestionnaireTypeId(Long ClassId, Long typeId);
    Set<Evaluation> findByClassId(Long ClassId);
}
