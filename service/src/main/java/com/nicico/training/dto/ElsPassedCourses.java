package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PaginationDto;

import java.util.List;

@Setter
@Getter
public class ElsPassedCourses extends BaseResponse {
    private List<TclassDTO.PassedClasses> passedClasses;
    private PaginationDto pagination;
 }
