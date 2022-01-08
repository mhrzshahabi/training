package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ActiveStudentsBaseDTO extends BaseResponse {
    List<StudentDTO.LmsInfo> infos;
}
