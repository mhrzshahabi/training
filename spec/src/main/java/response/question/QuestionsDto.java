package response.question;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuestionsDto {
    private Long id;
    private String question;
    private String type;
    private String score;
    private String time;
    private String options;
    private Double proposedPointValue;
    private Double proposedTimeValue;
}
