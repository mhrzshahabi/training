package response.tclass.dto;

import dto.TermDto;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import response.evaluation.TrainingEvaluationDto;
import response.teacher.dto.TeacherInCourseDto;

import java.util.Set;

@Getter
@Setter
public class TclassEvaluationsDto {
    private long id;
    private Set<TrainingEvaluationDto> evaluations;

}
