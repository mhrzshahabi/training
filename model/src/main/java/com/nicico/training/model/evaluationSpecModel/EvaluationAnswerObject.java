package com.nicico.training.model.evaluationSpecModel;

import com.nicico.training.model.Auditable;
import com.nicico.training.model.EducationLevel;
import com.nicico.training.model.EducationMajor;
import com.nicico.training.model.PersonalInfo;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Setter
@Getter

public class EvaluationAnswerObject {


    private Long classId;
    private Long evaluatedId;
    private Long evaluatedTypeId;
    private Long evaluationLevelId;
    private Long evaluatorId;
    private Long evaluatorTypeId;
    private Long questionnaireTypeId;
    private List<Answer> evaluationAnswerList;
    private Boolean evaluationFull;

    public static class Answer {
        private Long id;
        private Long answerId;
    }
}
