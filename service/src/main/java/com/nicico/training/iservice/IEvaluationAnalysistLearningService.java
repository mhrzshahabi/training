package com.nicico.training.iservice;

import com.nicico.training.dto.ClassStudentDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IEvaluationAnalysistLearningService {
    @Transactional
    Float[] getStudents(Long id,String scoringMethod);

    @Transactional
    List<ClassStudentDTO.evaluationAnalysistLearning> getStudentWithOutPreTest(Long id);
}
