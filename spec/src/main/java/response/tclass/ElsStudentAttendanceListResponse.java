package response.tclass;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.tclass.dto.ElsStudentAttendanceInfoDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsStudentAttendanceListResponse extends BaseResponse implements Serializable {
    private static final long serialVersionUID = -2402556835532954900L;
    private String nationalCode;
    private String classCode;
    private List<ElsStudentAttendanceInfoDto> studentAttendanceInfoDtoList;
}
