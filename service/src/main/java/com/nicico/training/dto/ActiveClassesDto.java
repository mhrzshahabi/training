package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PaginationDto;

import java.util.List;

@Setter
@Getter
public class ActiveClassesDto extends BaseResponse {
    private List<ActiveClasses> activeClasses;
    private PaginationDto pagination;
}
