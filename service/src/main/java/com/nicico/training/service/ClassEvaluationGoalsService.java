package com.nicico.training.service;


import com.nicico.training.dto.ClassEvaluationGoalsDTO;
import com.nicico.training.model.ClassEvaluationGoals;
import com.nicico.training.repository.ClassEvaluationGoalsDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ClassEvaluationGoalsService extends BaseService<ClassEvaluationGoals, Long, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDTO.Info, ClassEvaluationGoalsDAO>{

    @Autowired
    ClassEvaluationGoalsService(ClassEvaluationGoalsDAO classEvaluationGoalsDAO) {
        super(new ClassEvaluationGoals(), classEvaluationGoalsDAO);
    }

}
