package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewCoursesPassedPersonnelReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        private String empNo;
        private String personnelNo;
        private String nationalCode;
        private String firstName;
        private String lastName;
        private String courseCode;
        private String courseTitleFa;
        private Long classStudentScoresStateId;
        private String classStartDate;
        private String classEndDate;
        private Long classHDduration;
        private String termCode;
        private String termTitleFa;
        private Long termId;
        private String classYear;
        private String postGradeCode;
        private String affairs;
        private String area;
        private String assistant;
        private String section;
        private String unit;
        private String companyName;
        private String complexTitle;
        private String courseType;
        private Long naPriorityId;
        private Long courseId;
        private Long personnelId;
        private Float score;
    }
}
