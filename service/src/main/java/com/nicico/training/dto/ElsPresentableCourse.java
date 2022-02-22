package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ElsPresentableCourse {
    private Long id;
    private Long courseId;
    private String description;
    private String nationalCode;
    private List<Long> categoryIds;
    private List<Long> subCategoryIds;

}
