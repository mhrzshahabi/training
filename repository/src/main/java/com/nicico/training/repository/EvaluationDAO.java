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

}
