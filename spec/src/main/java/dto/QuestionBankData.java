package dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class QuestionBankData {
    private String question;
    private String questionBankId;
    private Long id;
    private QuestionTypeData questionType;
    private QuestionCategoryData category;

}
