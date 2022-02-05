package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ContinuousStatusReportViewDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        private Long personnelId;
        private String empNo;
        private String personnelNo;
        private String nationalCode;
        private String firstName;
        private String lastName;
        private Long classId;
        private String classCode;
        private String classStatus;
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private String classStartDate;
        private String classEndDate;
        private Long classHDduration;
        private String classYear;
        private String termCode;
        private String termTitleFa;
        private Long termId;
        private String postTitle;
        private Long pgId;
        private String postGradeTitle;
        private String affairs;
        private String area;
        private String assistant;
        private String section;
        private String unit;
        private String companyName;
        private String complexTitle;
        private String courseType;
        private Long naPriorityId;
    }
}
