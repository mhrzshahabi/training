package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:2:37 PM
*/

import com.nicico.training.model.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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

    List<Evaluation> findAllByClassId(Long ClassId);

    Set<Evaluation> findByClassId(Long ClassId);

    @Query(value = "SELECT eval.* " +
            "FROM tbl_EVALUATION eval " +
            "         INNER JOIN TBL_TEACHER teacher ON eval.F_EVALUATOR_ID = teacher.ID " +
            "         INNER JOIN TBL_PERSONAL_INFO personal ON teacher.F_PERSONALITY = personal.ID " +
            "         INNER JOIN TBL_CLASS class ON eval.F_CLASS_ID = class.ID " +
            "WHERE personal.C_NATIONAL_CODE =:evaluatorNationalCode " +
            "  AND eval.F_EVALUATOR_TYPE_ID =:evaluatorTypeId " +
            "  AND class.TEACHER_ONLINE_EVAL_STATUS = 1  AND eval.f_evaluation_level_id != 156 ", nativeQuery = true)
    List<Evaluation> getTeacherEvaluationsWithEvaluatorNationalCodeAndEvaluatorList(@Param("evaluatorNationalCode") String evaluatorNationalCode, @Param("evaluatorTypeId") Long evaluatorTypeId);

    @Query(value = "SELECT eval.*  " +
            "FROM tbl_EVALUATION eval  " +
            "         INNER JOIN TBL_CLASS_STUDENT cs ON eval.F_EVALUATOR_ID = cs.ID  " +
            "         INNER JOIN TBL_STUDENT student ON cs.STUDENT_ID = student.ID  " +
            "         INNER JOIN TBL_CLASS class ON eval.F_CLASS_ID = class.ID  " +
            "WHERE student.NATIONAL_CODE =:evaluatorNationalCode  " +
            "  AND eval.F_EVALUATOR_TYPE_ID =:evaluatorTypeId  " +
            "  AND class.STUDENT_ONLINE_EVAL_STATUS = 1 " +
            "And cs.evaluation_status_reaction = 1 AND eval.f_evaluation_level_id != 156" +
            "", nativeQuery = true)
    List<Evaluation> getStudentEvaluationsWithEvaluatorNationalCodeAndEvaluatorList(@Param("evaluatorNationalCode") String evaluatorNationalCode,@Param("evaluatorTypeId") Long evaluatorTypeId);


    Evaluation findFirstByQuestionnaireId(Long QuestionnaireId);


    @Query(value = "SELECT\n" +
            "    *\n" +
            "\n" +
            "FROM\n" +
            "         tbl_evaluation\n" +
            "WHERE\n" +
            "       tbl_evaluation.b_status = 0\n" +
            "       and\n" +
            "       tbl_evaluation.f_evaluation_level_id=156",nativeQuery = true)
    List<Evaluation> getBehavioralEvaluations();
}
