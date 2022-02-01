package dto.exam;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ImportedUser {
    private String surname;
    private String lastName;
    private String cellNumber;
    private String nationalCode;
    private String gender;
}
