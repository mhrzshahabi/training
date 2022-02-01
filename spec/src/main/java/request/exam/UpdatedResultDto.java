package request.exam;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UpdatedResultDto {
    private String mobileNumber;
    private String nationalCode;
    private Double testResult;
    private Double descriptiveResult;
    private Double finalResult;
}