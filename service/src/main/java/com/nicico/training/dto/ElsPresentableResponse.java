package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsPresentableResponse extends BaseResponse {
    private Long id;
    private Long courseId;
    private String courseTitle;
    private String courseDuration;
    private String description;
    private String nationalCode;
    private List<Long> categoryIds;
    private List<Long> subCategoryIds;
    private List<String> categoryTitles;
    private List<String> subCategoryTitles;
    private List<String> preCourseTitles;
    private List<String> courseSyllabusTitles;

}
