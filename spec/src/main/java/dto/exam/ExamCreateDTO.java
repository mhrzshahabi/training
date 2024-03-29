package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ExamCreateDTO {
    private String code;
    private String description;
    private String name;
    private Long startDate;
    private Long endDate;
    private Long resultDate;
    private Integer questionCount;
    private Double score;
    private Double finalScore;
    private Double classScore;
    private Double practicalScore;
    private Double minimumAcceptScore;
    private int duration;
    private ExamStatus status;
    private ExamType type;
    private Long sourceExamId;
    private String method;
}
