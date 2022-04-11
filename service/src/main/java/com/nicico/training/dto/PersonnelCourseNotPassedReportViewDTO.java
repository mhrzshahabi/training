package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelCourseNotPassedReportViewDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info {
        private long personnelId;
        private String personnelFirstName;
        private String personnelLastName;
        private String personnelNationalCode;
        private String personnelPersonnelNo2;
        private String personnelPostTitle;
        private String personnelPostGradeTitle;
        private String personnelComplexTitle;
        private String personnelCompanyName;
        private String personnelCcpCode;
        private String personnelCcpArea;
        private String personnelCcpAssistant;
        private String personnelCcpAffairs;
        private String personnelCcpSection;
        private String personnelCcpUnit;
        private String personnelCcpTitle;
        private Long pgId;
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private Long categoryId;
        private Long isStudent;
        private Long hasNa;
    }
}
