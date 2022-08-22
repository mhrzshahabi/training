package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScoringClassDto {
    private Long classId;
    private String classScore;
    private String practicalScore;
}
