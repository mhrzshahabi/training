package request.student;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
public class StudentNationalCode implements Serializable {
    private String nationalCode;
}
