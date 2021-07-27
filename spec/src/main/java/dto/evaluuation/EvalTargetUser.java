package dto.evaluuation;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class EvalTargetUser {

    private Long studentId;
    private String surname;
    private String lastName;
    private String cellNumber;
    private String nationalCode;
    private String gender;
}
