package request.exam;

import dto.evaluuation.EvalTargetUser;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Setter
@Getter
@ToString
public class ElsExtendedExamRequest {
    private Long startDate;
    private Long endDate;
    private int duration;
    private Long sourceExamId;
    private List<EvalTargetUser> users;
}
