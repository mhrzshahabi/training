package request.exam;


import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;


@Setter
@Getter
public class ElsExamScore implements Serializable {
    private Long examId;
    private String nationalCode;
    private Float score;
    private String type;
}
