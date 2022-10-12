package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ClassCreateDTO {
    private String code;
    private String titleClass;
    private Double score;
    private Double acceptancelimit;
    private Integer questionCount;
    private Long courseId;
    private String courseCode;
}
