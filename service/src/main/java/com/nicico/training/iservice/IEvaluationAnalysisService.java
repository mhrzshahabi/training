package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.EvaluationAnalysisDTO;
import com.nicico.training.dto.EvaluationDTO;
import com.nicico.training.model.EvaluationAnalysis;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface IEvaluationAnalysisService {
    EvaluationAnalysisDTO.Info get(Long id);

    List<EvaluationAnalysisDTO.Info> list();

    EvaluationAnalysisDTO.Info create(EvaluationAnalysis request);

    EvaluationAnalysisDTO.Info update(Long id, EvaluationAnalysisDTO.Update request);

    void delete(Long id);

    void delete(EvaluationAnalysisDTO.Delete request);

    SearchDTO.SearchRs<EvaluationAnalysisDTO.Info> search(SearchDTO.SearchRq request);

    void updateLearningEvaluation(Long classId, String scoringMethod);

    void updateReactionEvaluation(Long classId);

    void updateBehavioral(Long classId);

    void print (HttpServletResponse response, String type , String fileName, Long testQuestionId, String receiveParams,  String suggestions, String opinion) throws Exception;

    void printBehaviorChangeReport(HttpServletResponse response, String type, String fileName, Long classId, String receiveParams, String suggestions, String opinion) throws Exception;

    @Transactional
    Float[] getStudents(Long id, String scoringMethod);

    @Transactional
    List<ClassStudentDTO.evaluationAnalysistLearning> getStudentWithOutPreTest(Long id);

    EvaluationDTO.EvaluationLearningResult evaluationAnalysistLearningResultTemp(Long classId, String scoringMethod);

    Double findTeacherGradeByClass(Long classId);
}
