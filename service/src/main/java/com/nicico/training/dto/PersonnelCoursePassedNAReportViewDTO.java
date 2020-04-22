package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelCoursePassedNAReportViewDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        Integer totalPersonnelCount = 0;
        Integer notPassedPersonnelCount = 0;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NotPassedPersonnel")
    public static class NotPassedPersonnel {
        private long personnelId;
        private String personnelPersonnelNo;
        private String personnelFirstName;
        private String personnelLastName;
        private String personnelNationalCode;
        private String personnelPostTitle;
        private String personnelPostCode;
        private String personnelComplexTitle;
        private String personnelEducationLevelTitle;
        private String personnelJobNo;
        private String personnelJobTitle;
        private String personnelCompanyName;
        private String personnelPersonnelNo2;
        private String personnelPostGradeTitle;
        private String personnelPostGradeCode;
        private String personnelCcpCode;
        private String personnelCcpArea;
        private String personnelCcpAssistant;
        private String personnelCcpAffairs;
        private String personnelCcpSection;
        private String personnelCcpUnit;
        private String personnelCcpTitle;
    }

}
