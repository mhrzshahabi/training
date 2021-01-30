package response.evaluation;

import dto.TermDto;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.evaluation.dto.EvalResultDto;
import response.teacher.dto.TeacherInCourseDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class TrainingEvaluationDto {
    private long id;

}
