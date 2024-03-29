package response.exam;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ExamResultDto {
    private String surname;
    private String lastName;
    private String nationalCode;
    private String cellNumber;
    private String score; //نمره کسب شده
    private String practicalScore;
    private String classScore;
    private String resultStatus;
    private String testResult;//نمره تستی
    private String descriptiveResult;
    private String finalResult;//نمره +ارفاق
    private List<ExamAnswerDto> answers;
}
