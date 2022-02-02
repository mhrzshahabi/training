package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewTeacherReportDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewTeacherReportInfo")
    public static class Info {
        private Long id;
        private Long teacherId;
        private String firstName;
        private String lastName;
        private String nationalCode;
        private String mobile;
        private Integer classCounts;
        private Boolean teacherEnableStatus;
        private Boolean personnelStatus;
        private String teacherCode;
        private String personnelCode;
        private Long educationMajor;
        private Long educationLevel;
        private Long state;
        private Long city;
        private String lastClass;
        private String lastClassGrade;
        private String teacherCategories;
        private String teacherSubCategories;
        private String teachingHistoryCats;
        private String teachingHistorySubCats;
        private String teacherTermIds;
        private String teacherTermTitles;
        private String educationMajorTitle;
    }
}
