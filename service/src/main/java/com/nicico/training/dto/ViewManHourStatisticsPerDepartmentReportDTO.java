package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ViewManHourStatisticsPerDepartmentReportDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        //////////////////////Session - Attendance

        private Float presenceManHour;
        private Float absenceManHour;
        private Long presentStudentNumbers;
        private Long absentStudentNumbers;
        private Float participationPercentage;
        private Float PerCapita;

        ///////////////////////////department

        private String applicantCompanyName;
        private String complexTitle;
        private String ccpAssistant;
        private String ccpAffairs;

        ///////////////////////////Term
        private Long termId;

    }
}
