package request.exam;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class UpdateRequest implements Serializable {
    private Long sourceExamId;
    private String modifiedBy;
    private List<UpdatedResultDto> results;
}