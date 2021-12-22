package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class TclassSessionDetailBaseDTO extends BaseResponse {
    private List<ClassSessionDTO.TClassSessionsDetail> data;
}