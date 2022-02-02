package response.tclass;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.tclass.dto.ElsSessionUsersDto;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsSessionResponse extends BaseResponse implements Serializable {
    private String code;
    private List<ElsSessionUsersDto> users;
    private List<ElsSessionDetailDto> sessions;
}
