package dto.Question;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;


@Getter
@Setter
@ToString
public class QuestionScores {

    private Long id;
    private String question;
    private String score;
 }
