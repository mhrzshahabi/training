package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PaginationDto;

import java.util.List;

@Getter
@Setter
public class TeacherInfoBaseDTO extends BaseResponse {
    private List<TeacherInfoDTO> data;
    private PaginationDto paginationDto;
}
