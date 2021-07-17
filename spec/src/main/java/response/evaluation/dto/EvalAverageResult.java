package response.evaluation.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class EvalAverageResult extends BaseResponse implements Serializable {

    private Double totalAverage;
    private Long limitScore;
    private Integer allStudentsNo;
    private Integer answeredStudentsNo;
    private List<AveragePerQuestion> averagePerQuestionList;
}
