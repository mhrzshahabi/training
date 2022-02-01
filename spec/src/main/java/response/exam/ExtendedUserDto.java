package response.exam;

import dto.evaluuation.EvalTargetUser;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ExtendedUserDto {
    private EvalTargetUser user;
    private Long startDate;
    private Long endDate;
}
