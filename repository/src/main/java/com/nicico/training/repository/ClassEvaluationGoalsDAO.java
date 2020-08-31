package com.nicico.training.repository;

import com.nicico.training.model.ClassEvaluationGoals;
import org.springframework.stereotype.Repository;


@Repository
public interface ClassEvaluationGoalsDAO extends BaseDAO<ClassEvaluationGoals, Long> {
    ClassEvaluationGoals findByClassIdAndSkillIdAndGoalId(Long classId,Long skillId,Long goalId);
}

