package response.evaluation.dto;


import lombok.*;

 import java.util.List;

@Setter
@Getter

public class EvaluationAnswerObject {


    private Long classId;
    private Long id;
    private Long evaluatedId;
    private Long evaluatedTypeId;
    private Long evaluationLevelId;
    private Long evaluatorId;
    private Long evaluatorTypeId;
    private Long questionnaireTypeId;
    private Long questionnaireId;
    private Boolean evaluationFull;
    private Boolean status;
    private String sendDate;
    private String description;
    private List<TeacherEvaluationAnswer> evaluationAnswerList;


}
