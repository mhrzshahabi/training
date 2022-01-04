package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;
import response.PaginationDto;

import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class TclassBaseDTO extends BaseResponse {
    private List<TclassDTO.TClassTimeDetails> data;
    private PaginationDto pagination;
}