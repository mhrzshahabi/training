package com.nicico.training.iservice;

import com.nicico.training.dto.ClassEvaluationGoalsDTO;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public interface IClassEvaluationGoalsService {
    List<ClassEvaluationGoalsDTO.Info> getClassGoals(Long classId);

    void editClassGoalsQuestions(ArrayList<LinkedHashMap> request);

    void deleteClassGoalsQuestions(Long classId);
}
