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
        Integer totalEssentialPersonnelCount = 0;
        Integer notPassedEssentialPersonnelCount = 0;
        Integer totalImprovingPersonnelCount = 0;
        Integer notPassedImprovingPersonnelCount = 0;
        Integer totalDevelopmentalPersonnelCount = 0;
        Integer notPassedDevelopmentalPersonnelCount = 0;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NotPassedPersonnel")
    public static class NotPassedPersonnel {
        private Long priorityId;
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
        private String personnelPostGradeLvlCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("MinInfo")
    public static class MinInfo{
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private String personnelPersonnelNo;
        private String personnelPersonnelNo2;
        private String personnelFirstName;
        private String personnelLastName;
        private String personnelNationalCode;
        private String personnelPostTitle;
        private String personnelCcpAffairs;
        private String personnelCcpSection;
        private String personnelCcpUnit;
        private String personnelPostCode;
        private Long priorityId;
        private Long isPassed;
        private String personnelPostGradeLvlCode;
        private String personnelPostGradeTitle;
        private Long postGradeId;
    }
}
