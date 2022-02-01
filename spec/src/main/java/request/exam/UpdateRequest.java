package request.exam;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class UpdateRequest {
    private Long sourceExamId;
    private List<UpdatedResultDto> results;
}