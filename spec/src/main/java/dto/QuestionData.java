package dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
public class QuestionData {
    private Long testQuestionId;
    private Long questionBankId;
    private Long id;
    private QuestionBankData questionBank;

 }
