package request.exam;


import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UpdatedResultDto {

    private String mobileNumber;

    private Double score;

    private Double descriptiveResult;

    private Double finalResult;

}