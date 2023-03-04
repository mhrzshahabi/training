package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ActiveCourses {
    private Long id;
    private String courseCode;
    private String courseTitle;

    public ActiveCourses(Long id, String courseCode, String courseTitle) {
        this.id = id;
        this.courseCode = courseCode;
        this.courseTitle = courseTitle;
    }
}
