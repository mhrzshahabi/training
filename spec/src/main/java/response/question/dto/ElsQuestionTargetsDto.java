package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsQuestionTargetsDto extends BaseResponse implements Serializable {

    @ApiModelProperty
    private List<ElsQuestionTargetDto> questionTargetDtoList;


}
