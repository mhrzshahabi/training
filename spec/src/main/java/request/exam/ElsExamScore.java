package request.exam;


import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;


@Setter
@Getter
public class ElsExamScore implements Serializable {
    private List<ElsStudentScore> studentScores;
    private Long examId;
    private String type;
 }
