package dto.Question;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class QuestionBankData {
    private String question;
    private Long questionBankId;
    private Long id;
    private QuestionTypeData questionType;
    private QuestionCategoryData category;

}
