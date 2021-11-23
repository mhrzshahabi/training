package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;

@Getter
@Setter
public class ElsAddQuestionResponse extends BaseResponse implements Serializable {

    @ApiModelProperty
    private Long questionId;
}
