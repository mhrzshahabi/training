package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;
import response.evaluation.TrainingEvaluationDto;

import java.util.Set;

@Getter
@Setter
public class TclassEvaluationsDto {
    private long id;
    private Set<TrainingEvaluationDto> evaluations;
}
