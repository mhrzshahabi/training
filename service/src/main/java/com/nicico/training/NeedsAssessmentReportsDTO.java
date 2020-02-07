package com.nicico.training;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class NeedsAssessmentReportsDTO implements Serializable {


    @Getter
    @Setter
    @ApiModel("NeedsAssessment - Courses")
    public static class NeedsCourses {
        private Long id;
        private String code;
        private String titleFa;
        private Float theoryDuration;
        private Integer eneedAssessmentPriorityId;
        private String status;
    }
}
