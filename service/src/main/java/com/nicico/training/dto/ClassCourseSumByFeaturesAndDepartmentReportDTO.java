package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ClassCourseSumByFeaturesAndDepartmentReportDTO implements Serializable {

    public enum GroupBy {
        CLASS_STATUS,
        CLASS_TEACHING_TYPE,
        COURSE_TECHNICAL_TYPE,
        COURSE_RUN_TYPE,
        COURSE_THEO_TYPE,
        COURSE_LEVEL_TYPE,
        EMPTY
    }

    private Integer presenceManHour;

    private Integer absenceManHour;

    private Integer unknownManHour;

    private Integer personnelCount;

    private Integer studentCount;

    private Double participationPercent;

    private Double presencePerPerson;

    private String classTeachingType;

    private String classStatus;

    private String courseTechnicalType;

    private String courseRunType;

    private String courseTheoType;

    private String courseLevelType;

    private String mojtameCode;

    private String mojtameTitle;

    private String moavenatCode;

    private String moavenatTitle;

    private String omorCode;

    private String omorTitle;

    private String ghesmatCode;

    private String ghesmatTitle;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs")
    public static class ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs {
        private ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassCourseSumByFeaturesAndDepartmentReportDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AttendanceReportDTOSpecRs")
    public static class ReportResponse {
          SpecRs response;
    }
}
