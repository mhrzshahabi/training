package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsSuggestedCourse extends BaseResponse {
    private Long id;
    private String nationalCode;
    private String courseTitle;
    private String description;
    private List<Long> categories;
    private List<Long> subcategories;
}
