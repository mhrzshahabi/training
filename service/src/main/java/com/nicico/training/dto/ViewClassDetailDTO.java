package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)

public class ViewClassDetailDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewClassDetailInfo")
    public static class Info{
        private Long id;
        private Long tclassId;
        private Long termId;
        private Long instituteId;
        private Long teacherId;
        private Integer tclassStudentsCount;
        private String tclassCode;
        private String tclassStartDate;
        private String tclassEndDate;
        private String tclassYear;
        private String courseCode;
        private Long courseCategory;
        private Long courseSubCategory;
        private String courseTitleFa;
        private String courseEvaluationType;
        private Long tclassDuration;
        private Long tclassOrganizerId;
        private String tclassStatus;
        private String tclassEndingStatus;
        private Long tclassPlanner;
        private Long tclassSupervisor;
        private String termTitleFa;
        private String instituteTitleFa;
        private String classScoringMethod;
        private Boolean classPreCourseTest;
    }
}
