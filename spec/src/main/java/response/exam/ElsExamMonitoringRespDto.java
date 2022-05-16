package response.exam;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
public class ElsExamMonitoringRespDto extends BaseResponse {
    private List<ElsExamStudentsStateDto> examParticipants;
}
