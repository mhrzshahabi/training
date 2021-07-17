package response.evaluation.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class AveragePerQuestion {

    private String title;
    private Double score;

}
