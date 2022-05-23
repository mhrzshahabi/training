package response.exam;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ElsExamStudentsStateDto {
    private String firstName;
    private String lastName;
    private String nationalCode;
    private String testEntryStatus;
    private boolean hasExamResult;
    private boolean hasPreparationTest;
    private boolean hasAnsweredAnyQuestion;
}
