package response.tclass;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.tclass.dto.ElsSessionAttendanceUserInfoDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsSessionAttendanceResponse extends BaseResponse implements Serializable {
    private static final long serialVersionUID = -3970933610365993352L;
    private Long sessionId;
    private List<ElsSessionAttendanceUserInfoDto> studentAttendanceInfos;

}
