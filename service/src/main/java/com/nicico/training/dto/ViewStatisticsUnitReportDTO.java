package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ViewStatisticsUnitReportDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Grid")
    public static class Grid {
        //////////////////////Session - Attendance
        private String sessionDate;

        private Float presenceHour;

        private Float presenceMinute;

        private Float absenceHour;

        private Float absenceMinute;
        //////////////////////////////////////////

        ///////////////////////Class
        private Long classId;

        private String classCode;

        private String classStatus;

        private String classStartDate;

        private String classEndDate;

        private String classTeachingType;

        private String classReason;

        private Long classTargetPopulationTypeId;

        private Long classHoldingClassTypeId;

        private String classYear;

        private Long classPlanner;

        private Long classSupervisor;
        //////////////////////////////////////////

        //////////////////////////Course
        private String courseCode;

        private String courseTitleFa;

        private String courseETechnicalType;

        private Long courseDuration;

        private String courseTheoType;

        private Long courseCategory;

        private Long courseSubCategory;
        /////////////////////////////////////////

        ///////////////////////////Student
        private Long studentId;

        private String studentPersonnelNo2;

        private String studentPersonnelNo;

        private String studentNationalCode;

        private String studentFirstName;

        private String studentLastName;

        private String studentCcpAssistant;

        private String studentCcpAffairs;

        private String studentCcpSection;

        private String studentCcpUnit;

        private String classStudentApplicantCompanyName;

        private String personnelComplexTitle;

        private String studentWorkPlaceTitle;

        private String studentPostGradeTitle;

        private String studentJobTitle;
        /////////////////////////////////////////

        ///////////////////////////Teacher
        private String teacherFirstName;

        private String teacherLastName;

        private Long courseTeacherStatus;

        private Long courseTeacherId;
        ////////////////////////////////////////

        ///////////////////////////Institute
        private Long instituteId;

        private String instituteTitleFa;
        ///////////////////////////////////////

        ///////////////////////////Term
        private Long termId;
        //////////////////////////////////////

        ///////////////////////////Evalution
        private String evaluationBehavioralGrade;

        private Boolean evaluationBehavioralPass;

        private Boolean evaluationBehavioralStatus;

        private String evaluationEffectivenessGrade;

        private Boolean evaluationEffectivenessPass;

        private Boolean evaluationEffectivenessStatus;

        private String evaluationLearningGrade;

        private Boolean evaluationLearningPass;

        private Boolean evaluationLearningStatus;

        private String evaluationReactionGrade;

        private Boolean evaluationReactionPass;

        private Boolean evaluationReactionStatus;

        private String evaluationResultsGrade;

        private Boolean evaluationResultsPass;

        private Boolean evaluationResultsStatus;

        private String evaluationTeacherGrade;

        private Boolean evaluationTeacherPass;

        private Boolean evaluationTeacherStatus;
        //////////////////////////////////////////

        private String teachingMethodTitle;

    }
}
