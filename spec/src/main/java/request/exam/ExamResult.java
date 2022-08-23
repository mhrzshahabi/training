package request.exam;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class ExamResult implements Serializable {
    private String cellNumber;
    private String nationalCode;
    private String descriptiveResult;
    private String finalResult;
    private String testResult;
    private String classScore;
    private String practicalScore;
}
