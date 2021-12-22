package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import javax.validation.constraints.NotNull;
import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class TclassBaseDTO extends BaseResponse {
    private List<TclassDTO.TClassTimeDetails> data;
}