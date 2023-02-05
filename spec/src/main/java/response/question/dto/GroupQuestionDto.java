package response.question.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class GroupQuestionDto {
    private Long id;
    private String question;
    private String type;
    private String correctAnswer;
    private String priority;
    private List<ElsQuestionOptionDto> optionList;
}
