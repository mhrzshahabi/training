package dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class EvalCourseProtocol {

    private String title;
    private String code;
    private String duration;
    private String finishDate;
    private String startDate;

}
