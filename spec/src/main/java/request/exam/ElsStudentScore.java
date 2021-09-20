package request.exam;


import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;


@Setter
@Getter
public class ElsStudentScore implements Serializable {
    private String nationalCode;
    private Float score;
}
