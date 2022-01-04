package com.nicico.training.dto;

import com.nicico.training.model.Tclass;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PaginationDto;

import java.util.List;

@Getter
@Setter
public class ClassBaseResponse extends BaseResponse {
    private List<Tclass> data;
    private PaginationDto paginationDto;
}
