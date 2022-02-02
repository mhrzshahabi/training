package request.exam;

import dto.evaluuation.EvalTargetUser;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@ToString
public class ResendExamImportedRequest implements Serializable {
    private String startDate;
    private Long duration;
    private String time;
    private Long sourceExamId;
    private List<EvalTargetUser> users;
}
