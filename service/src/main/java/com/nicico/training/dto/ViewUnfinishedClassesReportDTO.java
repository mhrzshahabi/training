package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewUnfinishedClassesReportDTO implements Serializable {
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {

        private Long classId;
        private String classCode;
        private Long courseId;
        private String courseCode;
        private String courseName;
        private Long duration;
        private String startDate;
        private String endDate;
        private String firstSession;
        private String instituteName;
        private Integer sessionCount;
        private Integer heldSessions;
        private String teacher;
        private Long studentId;
        private String nationalCode;
        private String firstName;
        private String lastName;
    }
}
