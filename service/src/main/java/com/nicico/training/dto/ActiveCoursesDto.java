package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.PaginationDto;

import java.util.List;

@Setter
@Getter
public class ActiveCoursesDto extends BaseResponse {
    private List<ActiveCourses> activeCourses;
    private PaginationDto pagination;
}
