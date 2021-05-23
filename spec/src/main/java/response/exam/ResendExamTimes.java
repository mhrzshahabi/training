package response.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Setter
@Getter
public class ResendExamTimes extends BaseResponse implements Serializable {

    private List<ExtendedUserDto> extendedUsers;

    private Long sourceExamId;
}
