package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsCourseDTO  extends BaseResponse {
    private String duration;
    private List<String> preCourseTitles;
    private List<String> courseSyllabusList;
}
