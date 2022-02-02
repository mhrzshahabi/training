package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class PresenceReportViewDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        private Float presenceHour;
        private Float presenceMinute;
        private Float absenceHour;
        private Float absenceMinute;
        ///////////////////////////////////////////////////class///////////////////////////////////////
        private long classId;
        private String classCode;
        private String classStartDate;
        private String classEndDate;
        //        private String classTeachingType;
        private String holdingClassTypeId;
        private String holdingClassTypeTitle;
        private String teachingMethodId;
        private String teachingMethodTitle;
        ///////////////////////////////////////////////////session///////////////////////////////////////
        private String sessionDate;
        ///////////////////////////////////////////////////student///////////////////////////////////////
        private Long studentId;
        private String studentPersonnelNo;
        private String studentPersonnelNo2;
        private String studentFirstName;
        private String studentLastName;
        private String studentNationalCode;
        private String studentCcpAssistant;
        private String studentCcpAffairs;
        private String studentCcpSection;
        private String studentCcpUnit;
        ///////////////////////////////////////////////////classStudent///////////////////////////////////////
        private String classStudentApplicantCompanyName;
        ///////////////////////////////////////////////////personnel/////////////////////////////////////////
        private String personnelComplexTitle;
        ///////////////////////////////////////////////////course/////////////////////////////////////////////
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
        private Long categoryId;
        private String courseRunType;
        private String courseTheoType;
        private String courseLevelType;
        private String courseTechnicalType;
        ///////////////////////////////////////////////////institute///////////////////////////////////////
        private Long instituteId;
        private String instituteTitleFa;
    }
}
