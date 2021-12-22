package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

@Getter
@Setter
@Accessors(chain = true)
public class TclassDataBaseDTO extends BaseResponse {
    private TclassDTO.TClassDataService data;
}